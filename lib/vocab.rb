# encoding: utf-8
class Hash
  def method_missing(name, *args, &block)
    if name.to_s[-1] == "="
      self[name.to_s[0..name.to_s.length-2].intern] = args[0]
    else
      return self[name]
    end
  end
end

class String
  def ending
    return self[-1]
  end
  def ending=(new_ending)
    self[-1] = new_ending
  end
end

module Japanese
  class List
    include Enumerable

    def initialize &block
      @list = Array.new
      instance_eval(&block)
    end

    def each
      @list.each {|w| yield w }
    end

    def ichidan(dictionary)
      @list << IchidanVerb.new(dictionary)
    end

    def godan(dictionary)
      @list << GodanVerb.new(dictionary)
    end

    def adjectival(dictionary)
      @list << Adjectival.new(dictionary)
    end

    def nominal(dictionary)
      @list << Nominal.new(dictionary)
    end

    def na_nominal(dictionary)
      @list << Nominal.new(dictionary, modifier: "な")
    end
  end

  class Word
    attr_reader :dictionary
    def initialize(dictionary)
      @dictionary = dictionary
    end

    def to_s
      @dictionary
    end
  end

  class Nominal < Word
    def initialize(dictionary, opts)
      super(dictionary)
      @modifier = opts[:modifier] || "の"
    end

    def self.negative(nominal)
      nominal + "じゃない"
    end
  end

  class Adjectival < Word
    def perfective
      Adjectival::perfective(@dictionary)
    end

    def self.perfective(adjectival)
      stem = adjectival[0..adjectival.length-2]
      stem + "かった"
    end
  end

  class Verb < Word
    attr_reader :conjugation
    def initialize(dictionary)
      super(dictionary)

      @conjugation = {
        direct: {
          imperfective: @dictionary
        },
        distal: {
          imperfective: stem + "ます",
          perfective: stem + "ました",
          gerund: stem + "まして",
          negative: {
            imperfective: stem + "ません",
            perfective: stem + "ませんでした",
          }
        }
      }
    end

    def method_missing(name, *args, &block)
      @conjugation[name]
    end

    def stem; end
    def root; end
  end

  class IchidanVerb < Verb
    def initialize(dictionary)
      super(dictionary)
      @conjugation.direct.merge!({
        perfective: stem + "た",
        gerund: stem + "て",
        negative: {
          imperfective: stem + "ない",
        }
      })
      direct.negative.perfective = Adjectival::perfective(direct.negative.imperfective)
    end

    def stem
      @dictionary[0..@dictionary.length-2]
    end

    def root
      stem
    end
  end

  class GodanVerb < Verb
    def initialize(dictionary)
      super(dictionary)

      direct.perfective = direct_perfective
      direct.gerund = direct_gerund

      direct.negative = {}
      direct.negative.imperfective = direct_negative_imperfective
      direct.negative.perfective = Adjectival::perfective(direct.negative.imperfective)
    end

    def split
      prefix = @dictionary[0..@dictionary.length-2]
      ending = @dictionary[-1]
      return prefix, ending
    end
    private :split

    def stem
      prefix, ending = split
      transform = {
        "く" => "き",
        "す" => "し",
        "つ" => "ち",
        "ぶ" => "び",
        "む" => "み",
        "る" => "り",
        "う" => "い",
      }
      prefix + transform[ending]
    end

    def direct_perfective
      prefix, ending = split
      transform = {
        "く" => "いた",
        "す" => "した",
        "つ" => "った",
        "ぶ" => "んだ",
        "む" => "んだ",
        "る" => "った",
        "う" => "った",
      }
      prefix + transform[ending]
    end

    def direct_gerund
      perfective = direct_perfective
      gerund = perfective
      if perfective.ending == "た"
        gerund.ending = "て"
      elsif perfective.ending == "だ"
        gerund.ending = "で"
      end
      return gerund
    end

    def direct_negative_imperfective
      prefix, ending = split
      transform = {
        "く" => "か",
        "す" => "さ",
        "つ" => "た",
        "ぶ" => "ば",
        "む" => "ま",
        "る" => "ら",
        "う" => "わ",
      }
      prefix + transform[ending] + "ない"
    end
  end

  class IrregularVerb < Verb
    def initialize(dictionary)
      super(dictionary)

      case @dictionary
      when "来る"
        @conjugation.direct.merge!({
          perfective: "きた",
          gerund: "きて",
          negative: {
            imperfective: "こない",
          },
        })
      when "する"
        @conjugation.direct.merge!({
          perfective: "した",
          gerund: "して",
          negative: {
            imperfective: "しない",
          },
        })
      end

      direct.negative.perfective = Adjectival::perfective(direct.negative.imperfective)
    end

    def stem
      case @dictionary
      when "来る"
        "き"
      when "する"
        "し"
      end
    end
  end
end


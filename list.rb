#!/usr/bin/env ruby
#encoding: utf-8
require './lib/vocab'

vocab = Hash.new
vocab[1] = Hash.new
vocab[1][:a] = Japanese::List.new do
  godan       "分かる", "understand; become understandable"
  nominal     "今日", "today"
  irregular   "する", "do"
  godan       "ちがいます", "be different; be wrong"
  nominal     "明日", "tomorrow"
  godan       "作る", "make, construct"
  nominal     "きのう", "yesterday"
  ichidan     "できる", "become completed; can do; be possible"
  irregular   "来る", "come"
  godan       "飲む", "drink"
  ichidan     "食べる", "eat"
  godan       "いただく", "eat, drink, accept (humble-polite)"
  irregular   "行く", "go"
end

vocab[1][:b] = Japanese::List.new do
  adjectival  "いい", "good; fine; all right"
  adjectival  "高い", "expensive; high"
  adjectival  "安い", "cheap"
  adjectival  "大きい", "big"
  adjectival  "小さい", "small"
  adjectival  "新しい", "new, fresh"
  adjectival  "古い", "old (not new)"
  adjectival  "おもしろい", "interesting, amusing, fun"
  godan       "買う", "buy"
  godan       "困る", "become upset; become a problem"
  adjectival  "つまらない", "boring; trifling"
end

vocab[2] = Hash.new
vocab[2][:a] = Japanese::List.new do
  nominal     "何", "what"
  nominal     "手紙", "tegami"
  nominal     "電話", "telephone"
  nominal     "どう", "what way, how"
  na_nominal  "だめ", "no good"
  na_nominal  "だいじょうぶ", "all right; safe"
  nominal     "そう", "that way, like that"
  nominal     "日本語", "Japanese language"
  nominal     "国語", "Japanese language, to the Japanese"
  nominal     "中国語", "Chinese language"
  nominal     "英語", "English language"
  nominal     "フランス語", "French language"
  nominal     "ドイツ語", "German language"
  nominal     "スペイン語", "Spanish language"
  nominal     "ロシア語", "Russian language"
  na_nominal  "きれい", "pretty; clean"
  na_nominal  "ざんねん", "regrettable, too bad, a pity"
  nominal     "東京", "Tokyo"
  nominal     "京都", "Kyoto"
end
vocab[2][:b] = Japanese::List.new do
  nominal     "どれ", "which thing (of three or more)"
  nominal     "それ", "that thing (near you or just mentioned)"
  nominal     "これ", "this thing"
  nominal     "じしょ", "dictionary"
  nominal     "本", "book"
  nominal     "ざっし", "magazine"
  nominal     "新聞", "newspaper"
  nominal     "えいわじてん", "English-Japanese dictionary"
  nominal     "わえいじてん", "Japanese-English dictionary"
  nominal     "あれ", "that thing over there"
  nominal     "私", "I, me"
  nominal     "ぼく", "I, me (primarily male)"
  nominal     "先生", "teacher, doctor"
  nominal     "学生", "student"
  nominal     "友だち", "friend"
  nominal     "あなた", "you"
  nominal     "だれ", "who"
  nominal     "どなた", "who (polite)"
  nominal     "いくら", "how much"
  counter     "円", "yen"
  nominal     "本当", "true; truth"
  nominal     "一", "one"
  nominal     "二", "two"
  nominal     "三", "three"
  nominal     "四", "four"
  nominal     "五", "five"
  nominal     "六", "six"
  nominal     "七", "seven"
  nominal     "八", "eight"
  nominal     "九", "nine"
  nominal     "十", "ten"
  nominal     "百", "hundred"
  nominal     "千", "thousand"
end

vocab.each do |lesson, sections|
  sections.each do |section, list|
    list.each {|w, m| puts "#{w.dictionary}\t#{m}" }
  end
end

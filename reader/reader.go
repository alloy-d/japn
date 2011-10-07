package main

import (
	"bufio"
	"flag"
	"fmt"
	"json"
	"log"
	"os"
	"regexp"
	"strings"
	"github.com/hoisie/mustache.go"
)

type Compound struct {
	Kanji   string	`json:"kanji"`
	Reading string	`json:"reading"`
	Meaning string	`json:"meaning"`
}

var html *bool = flag.Bool("html", false, "Output HTML")

func main() {
	compounds := make(map[string]Compound)
	flag.Parse()

	if flag.NArg() < 1 {
		log.Fatal("Need a file to open!")
	}

	list, err := os.Open(flag.Arg(0))
	if err != nil {
		log.Fatal(err)
	}
	reader := bufio.NewReader(list)
	spaces := regexp.MustCompile("\x20+")

	for {
		line, err := reader.ReadString('\n')
		if err == os.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		line = spaces.ReplaceAllString(line, " ")
		parts := strings.SplitN(line, " ", 3)
		if len(parts) < 3 {
			continue
		}

		compound := Compound{strings.TrimSpace(parts[0]),
			strings.TrimSpace(parts[1]),
			strings.TrimSpace(parts[2])}

		_, exists := compounds[compound.Meaning]
		if exists {
			log.Printf("Duplicate meaning: %v", compound.Meaning)
		}
		compounds[compound.Meaning] = compound
	}

	array := make([]Compound, len(compounds))
	i := 0
	for _, compound := range compounds {
		array[i] = compound
		i += 1
	}

	var out string
	if *html {
		out = mustache.RenderFile("list.mustache", map[string][]Compound{"compounds": array})
	} else {
		json_list, _ := json.MarshalIndent(array, "", "  ")
		out = string(json_list)
	}
	fmt.Print(out)
}

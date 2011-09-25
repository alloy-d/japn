package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
	"github.com/hoisie/mustache.go"
)

type Compound struct {
	kanji   string
	reading string
	meaning string
}

func main() {
	compounds := make(map[string]Compound)

	list, err := os.Open("kanji.txt")
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

		_, exists := compounds[compound.meaning]
		if exists {
			log.Printf("Duplicate meaning: %v", compound.meaning)
		}
		compounds[compound.meaning] = compound
	}

	array := make([]Compound, len(compounds))
	i := 0
	for _, compound := range compounds {
		array[i] = compound
		i += 1
	}

	out := mustache.RenderFile("list.mustache",
		map[string][]Compound{"compounds": array})
	fmt.Print(out)
}

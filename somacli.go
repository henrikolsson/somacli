package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"

	"github.com/pterm/pterm"
)

type station struct {
	name        string
	description string
	url         string
}

func getStations() []station {
	resp, err := http.Get("https://somafm.com/listen/")
	if err != nil {
		log.Fatal(err)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	resp.Body.Close()
	html := string(body)
	var name, descr, url string
	stations := []station{}
	tagRe := regexp.MustCompile(`>([^>]+)<`)
	hrefRe := regexp.MustCompile(`href="([^"]+)"`)
	for _, s := range strings.Split(html, "\n") {
		if strings.Index(s, "<h3>") == 0 {
			res := tagRe.FindStringSubmatch(s)
			name = res[1]
		} else if strings.Index(s, "<p class=\"descr") == 0 {
			res := tagRe.FindStringSubmatch(s)
			descr = res[1]
		} else if strings.Index(s, "<br/><nobr>MP3 PLS (SSL): <a href=") == 0 {
			res := hrefRe.FindStringSubmatch(s)
			url = res[1]
			x := station{name: name, description: descr, url: fmt.Sprintf("https://somafm.com%s", url)}
			stations = append(stations, x)
		}
	}
	return stations
}

func main() {
	if _, err := exec.LookPath("mpv"); err != nil {
		log.Fatal(err)
	}
	stations := getStations()
	options := make([]string, len(stations))
	for i, s := range stations {
		options[i] = fmt.Sprintf("%d - %s - %s", i+1, s.name, s.description)
	}
	for {
		result, _ := pterm.DefaultInteractiveSelect.WithOptions(options).WithMaxHeight(10).Show()
		idx, _ := strconv.Atoi(strings.Split(result, " - ")[0])
		cmd := exec.Command("mpv", stations[idx-1].url)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Stdin = os.Stdin
		if err := cmd.Start(); err != nil {
			log.Fatal(err)
		}
		cmd.Wait()
	}
}

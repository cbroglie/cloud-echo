package main

import (
	"net/http"
	"os"
	"text/template"
)

var tmpl = template.Must(template.New("output").Parse(`{{ .banner }}
{{ with .headers }}
Request headers:
{{ range $key, $value := . }}
  {{- $key }}: {{ $value }}
{{ end }}
{{ end }}
`))

const cloud = "" +
	"        _  _\n" +
	"       ( `   )_\n" +
	"      (    )    `)\n" +
	"    (_   (_ .  _) _)\n"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	banner := os.Getenv("BANNER")
	if banner == "" {
		banner = cloud
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		err := tmpl.Execute(w, map[string]interface{}{
			"banner":  banner,
			"headers": r.Header,
		})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "text/plain")
	})
	http.ListenAndServe(":"+port, nil)
}

{{- define "print" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{/* Definiert eine Funktion, die prüft, ob ein String in einer Liste enthalten ist */}}
{{ define "contains" }}
  {{/* Nimmt die Argumente als Map entgegen */}}
  {{- $dict := .}}
  
  {{/* Erstellt eine Variable, um das Ergebnis der Suche zu speichern */}}
  {{- $found := false }}
  
  {{/* Iteriert über die Liste und prüft, ob der gesuchte String enthalten ist */}}
  {{- range $index, $value := $dict.list }}
    {{- if eq $value $dict.value }}
      {{- $found = true }}
      {{- break }}
    {{- end }}
  {{- end }}
  
  {{/* Gibt das Ergebnis der Suche zurück */}}
  {{ $found }}
{{ end }}

{{/* Erstellt eine Liste der angegebenen Namespaces */}}
{{- $allNamespaces := list .Values.certManager.namespace "scylla-operator"}}

{{/* Erstellt eine neue Liste, die nur die Elemente enthaelt, die noch nicht in der neuen Liste vorhanden sind */}}
{{- $uniqueNamespaces := list }}
{{- range $index, $value := $allNamespaces }}
  {{- $dict := dict "list" $uniqueNamespaces "value" $value}}
  {{- $contains := include "contains" $dict }}
  {{- if not ($contains) }}
    {{- $uniqueNamespaces = append $uniqueNamespaces $value }}
  {{- end }}
{{- end }}

{{/* Iteriert über die Liste ohne Duplikate und legt Namespaces an */}}
{{- range $index, $value := $uniqueNamespaces }}
{{- template "print" $uniqueNamespaces }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ $value }}
{{- end }}

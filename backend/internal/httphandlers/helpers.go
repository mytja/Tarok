package httphandlers

import (
	"encoding/json"
	"net/http"
)

func DumpJSON(jsonstruct interface{}) []byte {
	marshal, _ := json.Marshal(jsonstruct)
	return marshal
}

func WriteJSON(w http.ResponseWriter, jsonstruct interface{}, statusCode int) {
	w.WriteHeader(statusCode)
	w.Header().Set("Content-Type", "application/json")
	w.Write(DumpJSON(jsonstruct))
}

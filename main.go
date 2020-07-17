package main

import (
	_ "github.com/v8kr/recharge/config"
	"github.com/v8kr/recharge/http"
)

func main() {
	http.Start()
}

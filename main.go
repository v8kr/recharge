package main

import (
	_ "github.com/v8kr/recharge/config"
	"github.com/v8kr/recharge/http"
	"github.com/v8kr/recharge/models"
)

func main() {
	defer models.DB.Close()
	http.Start()
}

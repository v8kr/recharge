package http

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/v8kr/recharge/config"
	"io"
	"os"
)

func Start() {
	ginInit()

	r := gin.Default()

	regRoute(r)

	e := r.Run()
	if e != nil {
		fmt.Println(e)
	}
}

func regRoute(r *gin.Engine) {

	r.GET("/", func(context *gin.Context) {
		context.String(200, "Hello!!")
	})

	api := r.Group("/api/v1")
	{
		api.POST("/flow", commit)
		api.GET("/flow", query)
	}

}

func ginInit() {
	if !config.Debug() {
		gin.SetMode(gin.ReleaseMode)
	}

	gin.DisableConsoleColor()
	f, _ := os.Create("./storage/logs/web.log")
	gin.DefaultWriter = io.MultiWriter(f, os.Stdout)
}

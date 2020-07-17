package http

import (
	"fmt"
	"github.com/gin-gonic/gin"
)

func Start() {

	r := gin.Default()

	r.GET("/", func(context *gin.Context) {
		context.String(200, "Hello!!")
	})

	e := r.Run()
	if e != nil {
		fmt.Println(e)
	}
}

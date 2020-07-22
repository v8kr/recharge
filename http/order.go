package http

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/v8kr/recharge/common"
	"github.com/v8kr/recharge/logger"
)

type CommitRequest struct {
	Uid       string `form:"uid" binding:"required,alphanum,max=32,min=32"`
	OrderId   string `form:"order_id" binding:"required,alphanum,max=32,min=1"`
	ProductId string `form:"product_id" binding:"required,alphanum"`
	Amount    uint16 `form:"amount" binding:"required,numeric"`
	Cellphone string `form:"cellphone" binding:"required,numeric,min=11,max=11"`
	Operator  string `form:"operator" binding:"required,alpha"`
	Time      string `form:"time" binding:"required"`
	NotifyUrl string `form:"notify_url" binding:"required,url"`
	Sign      string `form:"sign" binding:"required,hexadecimal,min=40,max=40"`
}

func commit(c *gin.Context) {

	var commitRequest CommitRequest

	if e := c.ShouldBind(&commitRequest); e != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("数据校验失败 %s", e),
		})
		return
	}
	l := logger.Get("flow-commit")
	l.Info(fmt.Sprintf("%+v", commitRequest))

	user, err := common.ApiLoadUser(commitRequest.Uid, c.ClientIP())
	if err != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("%s", err),
		})
		return
	}

	p := common.LoadProduct(commitRequest.ProductId, user.ID)

	fmt.Printf("%+v", p)

	if p.Product.ID <= 0 {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  "产品编码错误或未配置，请联系运营配置。",
		})
		return
	}

	c.String(200, fmt.Sprintf("commit order %+v", user))

}

func query(c *gin.Context) {
	c.String(200, "query order")
}

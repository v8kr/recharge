package http

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/v8kr/recharge/common"
	"github.com/v8kr/recharge/logger"
	"github.com/v8kr/recharge/models"
)

func commit(c *gin.Context) {

	var commitRequest common.ApiFlowParams

	if e := c.ShouldBind(&commitRequest); e != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("数据校验失败 %s", e),
		})
		return
	}
	commitRequest.Ip = c.ClientIP()

	l := logger.Get("flow-commit")
	l.Info(fmt.Sprintf("%+v", commitRequest))

	user, err := models.ApiLoadUser(commitRequest.Uid, commitRequest.Ip)

	if err != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("%s", err),
		})
		return
	}

	err = commitRequest.CheckSign(c, user.Secret)
	if err != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("%s", err),
		})
		return
	}

	if order, exists := commitRequest.UserOrderExists(user.ID); exists {
		c.JSON(200, gin.H{
			"code":         200,
			"msg":          "订单已存在。",
			"order_status": order.Status,
			"bill_no":      order.OrderId,
			"order_id":     order.UserOrderId,
		})
		return
	}

	p := models.LoadProduct(commitRequest.ProductId, user.ID)
	if p.Product.ID <= 0 {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  "产品编码错误或未配置，请联系运营配置。",
		})
		return
	}

	cellphone, err := models.GetCellphone(commitRequest.Cellphone)
	if err != nil || cellphone.ProvinceId != p.ProvinceId || cellphone.CityId != p.CityId {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  "不支持的号段或号码与产品归属不一致。",
		})
		return
	}

	commitRequest.CellphoneInfo = cellphone

	order, err := commitRequest.Trade(&user, &p)
	if err != nil {
		c.JSON(422, gin.H{
			"code": 422,
			"msg":  fmt.Sprintf("%s", err),
		})
		return
	}

	c.String(200, fmt.Sprintf("commit order \r\n%+v", order))
}

func query(c *gin.Context) {
	c.String(200, "query order")
}

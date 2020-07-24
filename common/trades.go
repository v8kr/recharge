package common

import (
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"github.com/v8kr/recharge/models"
	"reflect"
	"regexp"
	"sort"
	"strings"
)

type Trades interface {
	Trade(user *models.User, product *models.FlowProduct) (models.FlowOrder, error)
}

var SignFields NSort

func init() {
	t := reflect.TypeOf(ApiBaseParams{})
	for i := 0; i < t.NumField(); i++ {
		tagName := t.Field(i).Tag.Get("form")
		if tagName == "-" || tagName == "sign" {
			continue
		}
		SignFields = append(SignFields, tagName)
	}
	SignFields = append(SignFields, "secret")
	sort.Sort(SignFields)
}

type ApiBaseParams struct {
	Uid       string `form:"uid" binding:"required,alphanum,max=32,min=32"`
	OrderId   string `form:"order_id" binding:"required,alphanum,max=32,min=1"`
	ProductId string `form:"product_id" binding:"required,alphanum"`
	Amount    uint16 `form:"amount" binding:"required,numeric"`
	Cellphone string `form:"cellphone" binding:"required,numeric,min=11,max=11"`
	Operator  string `form:"operator" binding:"required,alpha"`
	Time      string `form:"time" binding:"required"`
	NotifyUrl string `form:"notify_url" binding:"required,url"`
	Sign      string `form:"sign" binding:"required,hexadecimal,min=40,max=40"`

	Ip            string           `form:"-"` //提交的ip地址
	CellphoneInfo models.Cellphone `form:"-"`
}

type ApiFlowParams struct {
	ApiBaseParams
}

func (params ApiBaseParams) CheckSign(c *gin.Context, secret string) error {
	rawStr := ""
	for _, name := range SignFields {
		if name == "secret" {
			rawStr += name + "=" + secret + "&"
		} else {
			rawStr += name + "=" + c.PostForm(name) + "&"
		}
	}
	rawStr = strings.Trim(rawStr, "&")
	okSign := GetSha1(rawStr)
	if okSign != params.Sign {
		r := regexp.MustCompile(`(&secret=\w{5})\w+`)
		rawStr = r.ReplaceAllString(rawStr, "$1...")
		return errors.New(fmt.Sprintf("sign error. right sign: %s. raw str: %s", okSign, rawStr))
	} else {
		return nil
	}
}

func (params *ApiBaseParams) Trade(user *models.User, product *models.FlowProduct) (models.FlowOrder, error) {

	//db.Set("gorm:query_option", "FOR UPDATE").First(&user, 10)
	tx := models.DB.Begin()

	tx.Set("gorm:query_option", "FOR UPDATE").Model(&user).Related(&user.SaleAccount)

	afterBalance := user.SaleAccount.Balance - product.Price
	if user.SaleAccount.UserId != user.ID || (afterBalance+user.SaleAccount.Credit) < 0 {
		return models.FlowOrder{}, errors.New("余额不足")
	}

	log := models.SaleAccountLog{
		UserId:    user.ID,
		AccountId: user.SaleAccount.ID,
		Payment:   product.Price,
		Before:    user.SaleAccount.Balance,
		Type:      "flow",
	}

	if err := tx.Model(&user.SaleAccount).Update("balance", afterBalance).Error; err != nil {
		tx.Rollback()
		return models.FlowOrder{}, err
	}

	log.After = afterBalance

	order := models.FlowOrder{
		OrderId:       MakeOrderId(32),
		UserOrderId:   params.OrderId,
		UserId:        user.ID,
		AccountId:     user.SaleAccount.ID,
		ProductId:     product.Product.ID,
		SaleProductId: product.SaleProduct.ID,
		Tel:           params.Cellphone,
		ProductValue:  product.ProductValue,
		PayPrice:      product.SaleProduct.Price,
		NotifyUrl:     params.NotifyUrl,
		Ip:            params.Ip,
		Operator:      params.CellphoneInfo.Operator,
		ProvinceId:    params.CellphoneInfo.ProvinceId,
		CityId:        params.CellphoneInfo.CityId,
		Source:        "api",
		Status:        "wait_handle", //已支付，等待选择上游
		PayType:       0,
	}

	err := models.DB.Create(&order).Error
	if err != nil {
		tx.Rollback()
		return order, errors.New("订单保存失败")
	}

	log.OrderId = order.ID

	err = models.DB.Create(&log).Error
	if err != nil {
		tx.Rollback()
		return order, errors.New("账户资金日志保存失败")
	}

	err = tx.Commit().Error
	if err != nil {
		logrus.Error(err)
	}

	return order, nil
}

func (params *ApiFlowParams) UserOrderExists(uid uint) (models.FlowOrder, bool) {
	o := models.FlowOrder{
		UserOrderId: params.OrderId,
		UserId:      uid,
	}
	models.DB.Where(&o).First(&o)

	return o, o.ID > 0
}

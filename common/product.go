package common

import (
	"fmt"
	"github.com/v8kr/recharge/models"
)

type FlowProduct struct {
	models.Product
	models.SaleProduct
}

func LoadProduct(productId string, userId uint) FlowProduct {

	var product FlowProduct

	db := models.DB.Debug().Table("products").Select("products.*,sale_products.*")
	db = db.Joins("left join sale_products on products.id = sale_products.product_id")
	db = db.Where("products.product_id = ?", productId).Where("sale_products.user_id = ?", userId)

	err := db.First(&product).Error
	if err != nil {
		fmt.Println(err)
	}

	return product
}

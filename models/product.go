package models

import "fmt"

type Product struct {
	Model
	ProductId    string  // '自定义产品ID',
	Main         string  // '厂商FCM FCT TCU Viqiyi',
	Name         string  //
	ProductValue int     // '流量MB话费元其他面值',
	ProductType  string  // '定向包,提速包等直冲,卡密等',
	GuidePrice   float32 // '官方价格',
	ProvinceId   uint8
	CityId       uint16
	UseArea      uint8  // '使用范围0全国1省2市3区 ',
	ValidDate    uint8  // '有效期 流量-1跨月0当月其他值天数 话费0',
	Detail       string // '详细描述',
	SoftDelete
}

type FlowProduct struct {
	Product
	SaleProduct
}

func LoadProduct(productId string, userId uint) FlowProduct {

	var product FlowProduct

	db := DB.Table("products").Select("products.*,sale_products.*")
	db = db.Joins("left join sale_products on products.id = sale_products.product_id")
	db = db.Where("products.product_id = ?", productId).Where("sale_products.user_id = ?", userId)

	err := db.First(&product).Error
	if err != nil {
		fmt.Println(err)
	}

	return product
}

package models

type SaleProduct struct {
	Model
	UserId       int
	ProductId    int
	Main         string
	Price        float32
	IsSale       uint8
	FreLimit     string
	Strict       uint8
	SupplierList string
	SmsTemplate  int
	Remark       string
	SoftDelete
}

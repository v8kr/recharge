package models

type SupplierProduct struct {
	Model
	SupplierId        string
	SupplierProductId string
	ProductId         int
	Main              string
	Price             float32
	IsSale            uint8
	FreLimit          string
	Remark            string
	SoftDelete
}

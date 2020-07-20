package models

type SupplierCallback struct {
	Model
	SupplierId      string
	SupplierOrderId string
	OrderId         string
	ClientIp        string
	Reply           string
	RequestMethod   string
	RequestUri      string
	RequestHeader   string
	RequestParams   string
	SoftDelete
}

func (c SupplierCallback) TableName() string {
	return "supplier_callback"
}

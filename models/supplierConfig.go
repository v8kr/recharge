package models

type SupplierConfig struct {
	Model
	Title       string
	Config      string
	SyncApi     uint8
	QueryApi    uint8
	CallbackApi uint8
	BankId      int
	Balance     float32
	Status      string // '供应商状态active disable stay',
	SoftDelete
}

const (
	SUPPLIER_STATUS_ACTIVE  = "active"
	SUPPLIER_STATUS_DISABLE = "disable"
	SUPPLIER_STATUS_STAY    = "stay"
)

func (c SupplierConfig) TableName() string {
	return "supplier_config"
}

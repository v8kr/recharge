package models

type SaleAccount struct {
	Model
	UserId  uint
	Balance float32 // '余额',
	Credit  float32 // '可用授信额度',
}

func (s SaleAccount) TableName() string {
	return "sale_account"
}

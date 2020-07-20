package models

type SaleAccount struct {
	Model
	UserId  int
	Balance float32 // '余额',
	Credit  float32 // '可用授信额度',
	SoftDelete
}

func (s SaleAccount) TableName() string {
	return "sale_account"
}

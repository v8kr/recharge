package models

type Cellphone struct {
	Model
	Operator string // CM CT CU UN
	Province string // 省名
	City     string //市名
}

func (c Cellphone) TableName() string {
	return "cellphone"
}

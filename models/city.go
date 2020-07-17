package models

type City struct {
	Model
	Name       string
	ProvinceId uint8
	Spelling   string
}

func (u City) TableName() string {
	return "city"
}

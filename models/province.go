package models

type Province struct {
	Model
	Name     string
	Spelling string
}

func (u Province) TableName() string {
	return "province"
}

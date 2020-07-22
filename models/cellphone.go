package models

import (
	"errors"
	"strings"
)

type Cellphone struct {
	Model
	Operator   string // CM CT CU UN
	Province   string // 省名
	City       string //市名
	ProvinceId uint8
	CityId     uint16
}

func (c Cellphone) TableName() string {
	return "cellphone"
}

//获取号码归属
func GetCellphone(cellphone string) (Cellphone, error) {
	var c Cellphone

	if len(cellphone) < 7 {
		return c, errors.New("cellphone error")
	}

	id := strings.Split(cellphone, "")[:6]
	err := DB.Where("id = ?", id).First(&c).Error
	if err != nil || c.ProvinceId == 0 || c.CityId == 0 {
		return c, errors.New("不支持的号段")
	}

	return c, nil
}

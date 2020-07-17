package models

import (
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/v8kr/recharge/config"
	"time"
)

var (
	DB    *gorm.DB
	DBErr error
)

type Model struct {
	ID        uint `gorm:"primary_key"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

type SoftDelete struct {
	DeletedAt *time.Time
}

func init() {
	DB, DBErr = gorm.Open("mysql", config.GetDNS())
	if DBErr != nil {
		fmt.Println(DBErr)
		panic("connect mysql error")
	}
}

package models

import (
	"database/sql"
	"errors"
	"strings"
)

type User struct {
	Model
	UserName    string
	Email       string
	Password    string
	Name        string
	Tel         string
	Status      string
	Remark      string
	Company     string
	ApiToken    string
	ApiId       string
	Secret      string
	AllowIp     sql.NullString
	NotifyUrl   string
	PriceLimit  uint8
	HiddenError uint8
	SoftDelete

	SaleAccount SaleAccount `gorm:"foreignkey:UserId"`
}

const (
	USER_STATUS_ACTIVE     = "active"
	USER_STATUS_WAIT_CHECK = "wait_check"
	USER_STATUS_FORBIDDEN  = "forbidden"
)

func (u User) IsActive() bool {
	return u.Status == USER_STATUS_ACTIVE
}

func (u User) IsAllowIP(ip string) bool {
	if u.AllowIp.Valid == false {
		return true
	} else {
		return strings.Index(u.AllowIp.String, ip) > -1
	}
}

// api_id (uid) find user
// check status and allow ip
func ApiLoadUser(apiId string, ip string) (User, error) {
	var user User
	if err := DB.Where("api_id = ?", apiId).First(&user).Error; err != nil {
		return user, errors.New("not found user")
	}

	if !user.IsActive() {
		return User{}, errors.New("account is forbidden")
	}

	if !user.IsAllowIP(ip) {
		return User{}, errors.New("ip deny")
	}

	return user, nil
}

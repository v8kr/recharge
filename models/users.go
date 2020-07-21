package models

import (
	"database/sql"
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
	return u.AllowIp.Valid == true && strings.Index(u.AllowIp.String, ip) > -1
}

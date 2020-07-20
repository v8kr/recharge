package models

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
	AllowIp     string
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

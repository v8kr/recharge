package models

type SaleAccountLog struct {
	Model
	UserId     int
	AccountId  int
	OrderId    int
	Payment    float32 // '交易额',
	Before     float32 // '交易前余额',
	After      float32 // '交易后余额',
	Type       string  // '自助充值 后台充值 流量消费 话费 虚拟卡消费',
	ActionUser int     //'操作人 0系统自动',
	BankId     int     //'分销商加款打入的银行账户',
	Img        string  // '上传的截图',
	Remark     string
}

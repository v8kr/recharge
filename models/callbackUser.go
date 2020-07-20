package models

type CallbackUser struct {
	Model
	UserId      int    //'回调用户的ID',
	FlowOrderId int    //'flow_order id',
	OrderId     string // '平台订单号',
	UserOrderId string // '分销商订单号',
	Tel         string // '号码',
	NotifyUrl   string // '回调地址',
	PostData    string // '回调数据',
	NotifyNum   uint8  // '已回调次数',
	Status      string // '状态',
	ReplyStatus string // '响应的http状态码',
	ReplyBody   string // '响应内容body',
}

func (c CallbackUser) TableName() string {
	return "callback_user"
}

const (
	CALLBACK_USER_STATUS_FAILED        = "failed"
	CALLBACK_USER_STATUS_SUCCESSFULLY  = "successfully"
	CALLBACK_USER_STATUS_WAIT_CALLBACK = "wait_callback"
	CALLBACK_USER_STATUS_IN_HAND       = "in_hand"
)

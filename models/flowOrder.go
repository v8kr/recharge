package models

type FlowOrder struct {
	Model
	OrderId           string // '平台订单号，给上下游',
	UserOrderId       string // '分销商的订单号',
	SupplierOrderId   string // '上游的订单号',
	SupplierId        string // '使用上游的标识符',
	UserId            int
	AccountId         int
	ProductId         int     // 'products id',
	SaleProductId     int     // 'sale_products id',
	SupplierProductId int     // 'supplier_product id',
	Tel               string  // '充值的手机号',
	ProductValue      int     // '充值的流量值 M',
	PayPrice          float32 // '用户支付的价格',
	SupplierPrice     float32 // '交易时上游给的价格',
	NotifyUrl         string  // '下游提供的回调URL',
	Status            string  // '订单状态',
	SupplierError     string  // '上游错误代码和描述',
	CallbackError     string  // '回调下游错误描述',
	ErrorCode         string  // '平台错误代码',
	ErrorString       string  // '平台错误描述',
	PayType           uint8   // '支付类型0account 1第三方支付',
	PayId             int     //'支付ID sale_account_logs id  pay_order id',
	Operator          string  // '运营商CM CT CU',
	ProvinceId        int     // '号码归属省',
	CityId            int     // '号码归属市',
	Source            string  //'订单来源',
}

const (
	OPERATOR_CM = "CM"
	OPERATOR_CT = "CT"
	OPERATOR_CU = "CU"

	ORDER_STATUS_WAIT_PAY      = "wait_pay"
	ORDER_STATUS_WAIT_HANDLE   = "wait_handle"
	ORDER_STATUS_RECHARGING    = "recharging"
	ORDER_STATUS_WAIT_CALLBACK = "wait_callback"
	ORDER_STATUS_FAILED        = "failed"
	ORDER_STATUS_SUCCESSFULLY  = "successfully"
	ORDER_STATUS_UNKNOWN_ERROR = "unknown_error"
	ORDER_STATUS_CACHED        = "cached"
)

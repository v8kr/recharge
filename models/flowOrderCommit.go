package models

type FlowOrderCommit struct {
	Model
	FlowOrderId     int    // 'flow_orders id',
	OrderId         string //'平台订单号',
	SupplierId      string //'供应商标识ID',
	Tel             string //'号码',
	SupplierOrderId string // '上游的订单号',
	Status          string // '供应商状态',
	ErrorCode       string //'供应商错误码',
	ErrorString     string // '供应商错误描述',
}

func (f FlowOrderCommit) TableName() string {
	return "flow_order_commit"
}

const (
	COMMIT_STATUS_WAIT_COMMIT   = "wait_commit"
	COMMIT_STATUS_IN_HAND       = "in_hand"
	COMMIT_STATUS_WAIT_CALLBACK = "wait_callback"
	COMMIT_STATUS_FAILED        = "failed"
	COMMIT_STATUS_SUCCESSFULLY  = "successfully"
	COMMIT_STATUS_UNKNOWN_ERROR = "unknown_error"
)

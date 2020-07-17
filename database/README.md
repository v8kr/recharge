# 使用方法

使用 [migrate](https://github.com/golang-migrate/migrate)

```shell
//创建迁移文件
migrate create -ext sql -dir database/migrates/ -seq base_data

//执行迁移
migrate -path database/migrates/ --database "mysql://root:xxx@tcp(127.0.0.1:3306)/recharge" up

//回退 要指定版本号 不然全部回退
migrate -path database/migrates/ --database "mysql://root:xxx@tcp(127.0.0.1:3306)/recharge" down 2
```

# 字段说明

## 表：flow_orders

### 字段：status

| 值            | 说明                     |
| ------------- | ------------------------ |
| wait_pay      | 默认值，等待支付         |
| wait_handle   | 已支付，等待选择上游     |
| recharging    | 已选中上游，等待提交     |
| wait_callback | 已提交上游，等待上游回调 |
| failed        | 订单失败                 |
| successfully  | 订单成功                 |
| unknown_error | 未知错误                 |
| cached        | 缓存                     |

## 表：flow_order_commit

## 字段：status

| 值            | 说明                     |
| ------------- | ------------------------ |
| wait_commit   | 默认值，等待提交         |
| in_hand | 提交中         |
| wait_callback | 已提交上游，等待上游回调 |
| failed        | 订单失败                 |
| successfully  | 订单成功                 |
| unknown_error | 未知错误                 |


## 表：callback_user

## 字段：status

| 值            | 说明                     |
| ------------- | ------------------------ |
| wait_callback   | 默认值，等待回调        |
| in_hand | 回调中         |
| failed        | 回调失败                 |
| successfully  | 回调成功                 |


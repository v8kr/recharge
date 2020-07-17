/*!40101 SET character_set_client = utf8 */;
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`
(
    `id`           int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `username`     varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL,
    `email`        varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
    `password`     varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `name`         varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '姓名',
    `tel`          char(11) COLLATE utf8mb4_unicode_ci     NOT NULL DEFAULT '电话',
    `status`       varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT 'wait_check' comment 'wait_check,active,forbidden',
    `remark`       varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' comment '备注',
    `company`      varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '公司名',
    `api_token`    char(32) COLLATE utf8mb4_unicode_ci              DEFAULT '' comment 'web后台token',
    `api_id`       char(32) COLLATE utf8mb4_unicode_ci     NOT NULL COMMENT 'api身份标识',
    `secret`       char(32) COLLATE utf8mb4_unicode_ci     NOT NULL COMMENT 'api密钥',
    `allow_ip`     varchar(255) COLLATE utf8mb4_unicode_ci          DEFAULT null COMMENT 'api允许ip地址逗号分隔null关闭',
    `notify_url`   varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '回调地址',
    `price_limit`  tinyint(1) unsigned                              DEFAULT 1 COMMENT '分销商价格止损开关（默认关闭）',
    `hidden_error` tinyint(1) unsigned                     not null default 1 comment '是否隐藏订单错误信息',
    `deleted_at`   timestamp                               NULL     DEFAULT NULL,
    `created_at`   timestamp                               NULL     DEFAULT NULL,
    `updated_at`   timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `users_username_unique` (`username`),
    UNIQUE KEY `users_api_token_unique` (`api_token`),
    UNIQUE KEY `users_api_id_unique` (`api_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 2000
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `sale_account`;
CREATE TABLE `sale_account`
(
    `id`         int(10) unsigned        NOT NULL AUTO_INCREMENT,
    `user_id`    int(10) unsigned        NOT NULL,
    `balance`    decimal(12, 4)          NOT NULL DEFAULT 0.0000 COMMENT '余额',
    `credit`     decimal(12, 4) unsigned NOT NULL DEFAULT 0.0000 COMMENT '可用授信额度',
    `created_at` timestamp               NULL     DEFAULT NULL,
    `updated_at` timestamp               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `sale_account_user_id_foreign` (`user_id`),
    CONSTRAINT `user_account_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `sale_account_logs`;
CREATE TABLE `sale_account_logs`
(
    `id`          int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `user_id`     int(10) unsigned                        NOT NULL,
    `account_id`  int(10) unsigned                        NOT NULL,
    `order_id`    int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '关联订单ID',
    `payment`     decimal(12, 4)                          NOT NULL DEFAULT 0.0000 COMMENT '交易额',
    `before`      decimal(12, 4)                          NOT NULL DEFAULT 0.0000 COMMENT '交易前余额',
    `after`       decimal(12, 4)                          NOT NULL DEFAULT 0.0000 COMMENT '交易后余额',
    `type`        varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '自助充值 后台充值 流量消费 话费 虚拟卡消费',
    `action_user` int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '操作人 0系统自动',
    `bank_id`     int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '分销商加款打入的银行账户',
    `img`         varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上传的截图',
    `remark`      varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
    `created_at`  timestamp                               NULL     DEFAULT NULL,
    `updated_at`  timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `sale_account_log_user_id_created_at_type_sign_index` (`user_id`, `created_at`, `type`, `payment`),
    KEY `sale_account_log_created_at_type_index` (`created_at`, `type`),
    KEY `sale_account_log_order_id_index` (`order_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `province`;
CREATE TABLE `province`
(
    `id`         tinyint(3) unsigned                    NOT NULL AUTO_INCREMENT COMMENT '省编号',
    `name`       varchar(3) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '省名',
    `spelling`   varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '全拼',
    `created_at` timestamp                              NULL     DEFAULT NULL,
    `updated_at` timestamp                              NULL     DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `city`;
CREATE TABLE `city`
(
    `id`          mediumint(8) unsigned                  NOT NULL AUTO_INCREMENT COMMENT '市编号',
    `name`        varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '市名',
    `province_id` tinyint(3) unsigned                    NOT NULL COMMENT '省编号',
    `spelling`    varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '全拼',
    `created_at`  timestamp                              NULL     DEFAULT NULL,
    `updated_at`  timestamp                              NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `city_province_id_foreign` (`province_id`),
    CONSTRAINT `city_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`
(
    `id`            int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `product_id`    varchar(24) COLLATE utf8mb4_unicode_ci  NOT NULL comment '自定义产品ID',
    #{F 流量 T话费 V会员} {CM移动 CT电信 CU联通 iqiyi爱奇艺} : FCM 移动流量 FCT 电信流量 TCM 移动话费  Viqiyi 爱奇艺
    `main`          varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '厂商FCM FCT TCU Viqiyi',
    `name`          varchar(64) COLLATE utf8mb4_unicode_ci  NOT NULL,
    `product_value` int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '流量MB话费元其他面值',
    `product_type`  varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT 'default' COMMENT '定向包,提速包等直冲,卡密等',
    `guide_price`   decimal(6, 2) unsigned                  NOT NULL DEFAULT 0.0000 COMMENT '官方价格',
    `province_id`   tinyint(3) unsigned                     NOT NULL DEFAULT 1,
    `city_id`       mediumint(8) unsigned                   NOT NULL DEFAULT 1,
    `use_area`      tinyint(1) unsigned                     NOT NULL DEFAULT 0 COMMENT '使用范围0全国1省2市3区 ',
    `valid_date`    tinyint(1)                              NOT NULL DEFAULT 0 COMMENT '有效期 流量-1跨月0当月其他值天数 话费0',
    `detail`        varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL default '' COMMENT '详细描述',
    `created_at`    timestamp                               NULL     DEFAULT NULL,
    `updated_at`    timestamp                               NULL     DEFAULT NULL,
    `deleted_at`    timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    unique key `products_product_id` (`product_id`),
    KEY `products_product_value` (`product_value`, `province_id`, `main`),
    KEY `products_product_main` (`main`, `product_value`, `province_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `sale_products`;
create table `sale_products`
(
    `id`            int(10) unsigned,
    `user_id`       int(10) unsigned,
    `product_id`    int(10) unsigned                        not null COMMENT 'product table id',
    `main`          varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT 'products table main',
    `price`         decimal(8, 4) unsigned                  NOT NULL DEFAULT 0.0000 COMMENT '售价',
    `is_sale`       tinyint(1) unsigned                     NOT NULL default 0 comment '0下架1上架',
    `fre_limit`     varchar(12)                             not null default '' comment '频率限制',
    `strict`        tinyint(1)                              NOT NULL DEFAULT 1 COMMENT '是否严格模式匹配',
    `supplier_list` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '指定走供应商，逗号分隔',
    `sms_template`  int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '短信通知模板',
    `remark`        varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备注',
    `created_at`    timestamp                               NULL     DEFAULT NULL,
    `updated_at`    timestamp                               NULL     DEFAULT NULL,
    `deleted_at`    timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    unique key `sale_products_user_id_mtu_id` (`user_id`, `product_id`),
    key `sale_products_main_user_id` (`main`, `user_id`, `updated_at`)
) engine = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `supplier_products`;
CREATE TABLE `supplier_products`
(
    `id`                  int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `supplier_id`         varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '供应商标识符',
    `supplier_product_id` varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '供应商的产品ID',
    `product_id`          int(10) unsigned                        not null COMMENT 'product table id',
    `main`                varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT 'products table main',
    `price`               decimal(8, 4) unsigned                  NOT NULL DEFAULT 0.0000 COMMENT '进价',
    `is_sale`             tinyint(1) unsigned                     NOT NULL default 0 comment '0下架1上架',
    `fre_limit`           varchar(12)                             not null default '' comment '频率限制',
    `remark`              varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '备注',
    `created_at`          timestamp                               NULL     DEFAULT NULL,
    `updated_at`          timestamp                               NULL     DEFAULT NULL,
    `deleted_at`          timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    unique key `supplier_products_supplier_id_mtu_id` (`supplier_id`, `product_id`),
    key `sale_products_main_user_id` (`main`, `supplier_id`, `updated_at`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `supplier_config`;
CREATE TABLE `supplier_config`
(
    `id`            varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'supplier_id',
    `title`         varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '显示供应商名称',
    `config`        text COLLATE utf8mb4_unicode_ci        NOT NULL COMMENT '接口配置信息json',
    `sync_api`      tinyint(1)                             NOT NULL DEFAULT 0 COMMENT '下单接口是否同步模式',
    `query_api`     tinyint(1)                             NOT NULL DEFAULT 1 COMMENT '是否有查询接口',
    `callback_api`  tinyint(1)                             NOT NULL DEFAULT 1 COMMENT '是否有回调接口',
    `title_account` varchar(32) COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT '账户名称',
    `bank_account`  varchar(32) COLLATE utf8mb4_unicode_ci          DEFAULT NULL COMMENT '银行账户号',
    `bank_id`       int(10) unsigned                       not null DEFAULT 0 COMMENT '开户行',
    `balance`       decimal(12, 4)                         NOT NULL COMMENT '余额',
    `status`        varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT '供应商状态active disable stay',
    `created_at`    timestamp                              NULL     DEFAULT NULL,
    `updated_at`    timestamp                              NULL     DEFAULT NULL,
    `deleted_at`    timestamp                              NULL     DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `flow_orders`;
CREATE TABLE `flow_orders`
(
    `id`                  int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `order_id`            varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '平台订单号，给上下游',
    `user_order_id`       varchar(64) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '分销商的订单号',
    `supplier_order_id`   varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上游的订单号',
    `supplier_id`         varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '使用上游的标识符',
    `user_id`             int(10) unsigned                        NOT NULL,
    `account_id`          int(10) unsigned                        NOT NULL,
    `product_id`          int(10) unsigned                        NOT NULL COMMENT 'products id',
    `sale_product_id`     int(10) unsigned                        NOT NULL COMMENT 'sale_products id',
    `supplier_product_id` int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT 'supplier_product id',
    `tel`                 char(11) COLLATE utf8mb4_unicode_ci     NOT NULL COMMENT '充值的手机号',
    `product_value`       int(10) unsigned                        NOT NULL COMMENT '充值的流量值 M',
    `pay_price`           decimal(8, 4) unsigned                  NOT NULL DEFAULT 0.0000 COMMENT '用户支付的价格',
    `supplier_price`      decimal(8, 4) unsigned                  NOT NULL DEFAULT 0.0000 COMMENT '交易时上游给的价格',
    `notify_url`          varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '下游提供的回调URL',
    `status`              varchar(24) COLLATE utf8mb4_unicode_ci  not null default 'wait_pay' comment '订单状态',
    `created_at`          timestamp                               NULL     DEFAULT NULL,
    `updated_at`          timestamp                               NULL     DEFAULT NULL,
    `supplier_error`      varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上游错误代码和描述',
    `callback_error`      varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '回调下游错误描述',
    `error_code`          varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '平台错误代码',
    `error_string`        varchar(64) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '平台错误描述',
    `pay_type`            tinyint(1) unsigned                     NOT NULL DEFAULT '0' COMMENT '支付类型0account 1第三方支付',
    `pay_id`              int(10) unsigned                        NOT NULL DEFAULT 0 COMMENT '支付ID sale_account_logs id  pay_order id',
    `operator`            char(2) COLLATE utf8mb4_unicode_ci      NOT NULL COMMENT '运营商CM CT CU',
    `province_id`         tinyint(3) unsigned                     NOT NULL DEFAULT 0 COMMENT '号码归属省',
    `city_id`             smallint(5) unsigned                    NOT NULL DEFAULT 0 COMMENT '号码归属市',
    `source`              varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT 'api' COMMENT '订单来源',
    PRIMARY KEY (`id`),
    UNIQUE KEY `flow_orders_user_order_id_user_id_unique` (`user_order_id`, `user_id`),
    unique KEY `flow_orders_order_id_unique` (`order_id`),
    KEY `idx_tel_created_at` (`tel`, `created_at`),
    KEY `idx_created_at_order_status` (`created_at`, `status`),
    KEY `idx_supplier_created_order_status` (`supplier_id`, `created_at`, `status`),
    KEY `idx_user_created_order_status` (`user_id`, `created_at`, `status`),
    KEY `idx_updated_order_status` (`updated_at`, `supplier_id`, `status`),
    KEY `idx_order_operator` (`operator`, `created_at`, `status`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `flow_order_commit`;
CREATE TABLE `flow_order_commit`
(
    `id`                int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `flow_order_id`     int(10) unsigned                        NOT NULL COMMENT 'flow_orders id',
    `order_id`          varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '平台订单号',
    `supplier_id`       varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '供应商标识ID',
    `tel`               char(11) COLLATE utf8mb4_unicode_ci     NOT NULL DEFAULT '' COMMENT '号码',
    `supplier_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '上游的订单号',
    `status`            varchar(24) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT 'wait_commit' COMMENT '供应商状态',
    `error_code`        varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '供应商错误码',
    `error_string`      varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '供应商错误描述',
    `created_at`        timestamp                               NULL     DEFAULT NULL,
    `updated_at`        timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `flow_order_commit_flow_order_id` (`flow_order_id`),
    KEY `flow_order_commit_created_at_status` (`created_at`, `status`),
    KEY `flow_order_commit_tel_created_at` (`tel`, `created_at`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `supplier_callback`;
CREATE TABLE `supplier_callback`
(
    `id`                int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `supplier_id`       varchar(12) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '上游标识符',
    `supplier_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上游供应商的订单号',
    `order_id`          varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '我们给上游的订单号',
    `client_ip`         varchar(16) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '访问者IP',
    `reply`             varchar(64) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '我们的响应内容',
    `request_method`    varchar(6) COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT 'get post',
    `request_uri`       varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求uri',
    `request_header`    text COLLATE utf8mb4_unicode_ci         NOT NULL COMMENT 'http头json',
    `request_params`    text COLLATE utf8mb4_unicode_ci         NOT NULL COMMENT '请求所有参数json',
    `created_at`        timestamp                               NULL     DEFAULT NULL,
    `updated_at`        timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `supplier_callback_created_at_supplier_id` (`created_at`, `supplier_id`),
    KEY `supplier_callback_order_id` (`order_id`),
    KEY `supplier_callback_supplier_order_id` (`supplier_order_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `callback_user`;
CREATE TABLE `callback_user`
(
    `id`            int(10) unsigned                        NOT NULL AUTO_INCREMENT,
    `user_id`       int(10) unsigned                        NOT NULL COMMENT '回调用户的ID',
    `flow_order_id` int(10)                                 NOT NULL COMMENT 'flow_order id',
    `order_id`      varchar(32) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '平台订单号',
    `user_order_id` varchar(64) COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '分销商订单号',
    `tel`           char(11) COLLATE utf8mb4_unicode_ci     NOT NULL DEFAULT '' COMMENT '号码',
    `notify_url`    varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '回调地址',
    `post_data`     varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '回调数据',
    `notify_num`    tinyint(3) unsigned                     NOT NULL DEFAULT 0 COMMENT '已回调次数',
    `status`        varchar(24) COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT 'wait_callback' COMMENT '状态',
    `reply_status`  char(3) COLLATE utf8mb4_unicode_ci      NOT NULL DEFAULT '' COMMENT '响应的http状态码',
    `reply_body`    varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '响应内容body',
    `created_at`    timestamp                               NULL     DEFAULT NULL,
    `updated_at`    timestamp                               NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `callback_user_user_order_id` (`user_order_id`),
    KEY `callback_user_flow_order_id` (`flow_order_id`),
    KEY `callback_user_order_id` (`order_id`),
    KEY `callback_user_created_at_status` (`created_at`, `status`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;



alter table `flow_orders`
    add `ip` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '下单IP' after `status`;
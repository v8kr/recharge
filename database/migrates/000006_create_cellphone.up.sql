CREATE TABLE `cellphone`
(
    `id`         char(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci     NOT NULL COMMENT '手机号码前七位',
    # CM CT CU UN
    `operator`   char(2) CHARACTER SET utf8 COLLATE utf8_unicode_ci     NOT NULL COMMENT '运营商',
    `province`   varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '省名',
    `city`       varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '市名 由于归属地与行政区划无法统一所以这里直接用名字',
    `created_at` timestamp                                              NULL DEFAULT NULL,
    `updated_at` timestamp                                              NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
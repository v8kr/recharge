alter table supplier_config
    add title_account varchar(32) null comment '账户名称' after `callback_api`;

alter table supplier_config
    add bank_account varchar(32) null comment '银行账户号' after `title_account`;
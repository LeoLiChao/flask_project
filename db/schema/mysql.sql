DROP DATABASE IF EXISTS `flask`;
CREATE DATABASE `flask` /*!40100 DEFAULT CHARACTER SET utf8 */;


use flask;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nickname` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '用户名称',
  `avatar_url` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '用户头像',
  `email` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '电子邮箱',
  `area_code` VARCHAR(4) NOT NULL DEFAULT '' COMMENT '国家区号',
  `phone` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '手机号码',
  `birthday` DATE NOT NULL DEFAULT '0000-00-00' COMMENT '生日',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `last_ip` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '最后一次登录IP',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';


DROP TABLE IF EXISTS `user_auth`;
CREATE TABLE `user_auth` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `auth_type` TINYINT NOT NULL DEFAULT '0' COMMENT '认证类型（0未知，1邮箱，2手机，3qq，4微信，5微博）',
  `auth_key` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '授权账号（如果是手机，国家区号+手机号码;第三方登陆，这里是openid）',
  `auth_secret` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '密码凭证（密码;token）',
  `status_verified` TINYINT NOT NULL DEFAULT '0' COMMENT '认证状态（0未认证，1已认证）',
  `status_lock` TINYINT NOT NULL DEFAULT '0' COMMENT '锁定状态（0未锁定，1已锁定）',
  `status_delete` TINYINT NOT NULL DEFAULT '0' COMMENT '删除状态（0未删除，1已删除）',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户认证表';


DROP TABLE IF EXISTS `user_bank`;
CREATE TABLE `user_bank` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户ID',
  `id_card` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '身份证号',
  `account_name` VARCHAR(60) NOT NULL DEFAULT '0' COMMENT '开户人姓名',
  `bank_name` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '开户银行',
  `bank_address` VARCHAR(60) NOT NULL DEFAULT '' COMMENT '开户网点',
  `bank_account` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '银行账号',
  `status_verified` TINYINT NOT NULL DEFAULT '0' COMMENT '认证状态（0未认证，1已认证）',
  `status_delete` TINYINT NOT NULL DEFAULT '0' COMMENT '删除状态（0未删除，1已删除）',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户银行账号信息';


DROP TABLE IF EXISTS `wallet`;
CREATE TABLE `wallet` (
  `user_id` INT NOT NULL COMMENT '用户Id',
  `amount` DECIMAL(10, 2) NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包总表';


DROP TABLE IF EXISTS `wallet_item`;
CREATE TABLE `wallet_item` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '钱包明细id',
  `user_id` INT NOT NULL COMMENT '用户Id',
  `type` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '钱包类型（1：收、2：支）',
  `money` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `sc_id` INT NOT NULL DEFAULT '0' COMMENT '关联id',
  `status` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '状态:0:待生效，1:已生效，2:作废',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `ind_user_id` (`user_id`),
  KEY `ind_sc_id` (`sc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='钱包明细表';


DROP TABLE IF EXISTS `apply_put`;
CREATE TABLE `apply_put` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户Id',
  `type_apply` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '申请类型:0:自主添加，1:后台添加',
  `money_apply` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '申请金额',
  `money_order` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `status_apply` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '申请状态:0:待生效，1:已生效，2:作废',
  `status_order` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '订单状态:0:待匹配，1:部分匹配，2:完全匹配',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `ind_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='提供申请表';


DROP TABLE IF EXISTS `apply_get`;
CREATE TABLE `apply_get` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL COMMENT '用户Id',
  `type_apply` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '申请类型:0:自主添加，1:后台添加',
  `money_apply` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '申请金额',
  `money_order` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `status_apply` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '申请状态:0:待生效，1:生效，2:取消',
  `status_order` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '匹配状态:0:待匹配，1:部分匹配，2:完全匹配',
  `status_delete` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '删除状态:0:未删除，1:已删除',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_time` TIMESTAMP COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `ind_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='需求申请表';


DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `apply_put_id` INT NOT NULL COMMENT '申请提供Id',
  `apply_get_id` INT NOT NULL COMMENT '申请需求Id',
  `apply_put_uid` INT NOT NULL COMMENT '申请提供用户Id',
  `apply_get_uid` INT NOT NULL COMMENT '申请需求用户Id',
  `type` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '订单类型',
  `money` DECIMAL(8, 2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `status_audit` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '审核状态:0:待审核，1:审核通过，2:审核失败',
  `status_pay` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '支付状态:0:待支付，1:支付成功，2:支付失败',
  `status_rec` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '收款状态:0:待收款，1:已收款，2:未收款',
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `pay_time` TIMESTAMP COMMENT '支付时间',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `ind_apply_put_id` (`apply_put_id`),
  KEY `ind_apply_get_id` (`apply_get_id`),
  KEY `ind_apply_put_uid` (`apply_put_uid`),
  KEY `ind_apply_get_uid` (`apply_get_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单总表';



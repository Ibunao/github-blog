/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50714
Source Host           : localhost:3306
Source Database       : purchase_2018_07

Target Server Type    : MYSQL
Target Server Version : 50714
File Encoding         : 65001

Date: 2018-11-09 13:28:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for meet_level
-- ----------------------------
DROP TABLE IF EXISTS `meet_level`;
CREATE TABLE `meet_level` (
  `level_id` mediumint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键，自增，类型id',
  `level_name` varchar(100) NOT NULL COMMENT '等级名称',
  `p_order` mediumint(8) unsigned NOT NULL DEFAULT '99' COMMENT '排序',
  PRIMARY KEY (`level_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of meet_level
-- ----------------------------
INSERT INTO `meet_level` VALUES ('3', '小S广告款', '99');
INSERT INTO `meet_level` VALUES ('4', '基本款', '99');
INSERT INTO `meet_level` VALUES ('5', '形象款', '99');
INSERT INTO `meet_level` VALUES ('6', '主力款', '99');
INSERT INTO `meet_level` VALUES ('7', '其他', '99');
INSERT INTO `meet_level` VALUES ('8', '未定义', '99');
INSERT INTO `meet_level` VALUES ('9', '渠道款', '99');

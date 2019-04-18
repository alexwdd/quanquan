/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : baishiwu

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2019-04-18 17:24:19
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `pm_chat`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat`;
CREATE TABLE `pm_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cityID` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `nickname` varchar(200) NOT NULL,
  `face` varchar(200) NOT NULL,
  `title` varchar(300) NOT NULL,
  `tag` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `images` text,
  `thumb` text,
  `like` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `hit` int(11) NOT NULL,
  `isTop` tinyint(4) NOT NULL,
  `createTime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat
-- ----------------------------
INSERT INTO `pm_chat` VALUES ('4', '9', '153', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '哥们的婚宴上，他两个壮得像小牛犊子似的小舅子是这样对他说的：你要是敢欺负我姐，我们哥俩可饶不了你！哥…', '萝莉控', '哥们的婚宴上，他两个壮得像小牛犊子似的小舅子是这样对他说的：你要是敢欺负我姐，我们哥俩可饶不了你！哥们连忙赔笑：把心放肚子里吧，我绝对不会欺负她！第三天新姑爷回门，新娘子一回到家就把俩小舅子给揍了……他不欺负我，你们让他欺负谁去？俩小舅子：姐夫，救我！', '/uploads/20190417/5cb718a3174c2.png', '/uploads/20190417/s_5cb718a3174c2.png', '0', '1', '2', '0', '1555503267');
INSERT INTO `pm_chat` VALUES ('5', '9', '156', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '超级直男', '人生就是这样，忍耐吧', '/uploads/20190417/5cb718d39d6bf.jpeg|/uploads/20190417/5cb718d3a2f5b.jpeg|/uploads/20190417/5cb718d3a8ef7.jpeg', '/uploads/20190417/s_5cb718d39d6bf.jpeg|/uploads/20190417/s_5cb718d3a2f5b.jpeg|/uploads/20190417/s_5cb718d3a8ef7.jpeg', '0', '1', '132', '0', '1555503315');
INSERT INTO `pm_chat` VALUES ('6', '9', '154', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '现代版《孔乙已》老包鲁镇的酒店格局，和别处不同：都是当街一个曲尺形的大柜台，柜里面放着硕大的啤酒桶，…', '萝莉控', '现代版《孔乙已》\n老包\n\n鲁镇的酒店格局，和别处不同：都是当街一个曲尺形的大柜台，柜里面放着硕大的啤酒桶，桶上装有水龙头，可以随时倒啤酒。\n\n做工的人，晌午傍晚散了工，三三俩俩地聚一桌，每每花上百来块，一条鱼，一盘肉，再加上几碟小菜，热热地吃了休息。\n\n倘若肯花上五块钱，买一大碗酒，就着饭菜喝下去，打个饱嗝，空气中都有麦芽的香味，甭提有多满足。\n\n现在的小工一天两百块，大师傅能拿到三五百，许多人每顿都要喝上两大碗酒。\n\n我从十二岁起，便在镇口的咸亨酒店里当伙计，老板娘说我样子太傻，就在外面做点跑腿的事罢。\n\n虽然没什么失职，但总觉得有点单调和无聊。老板娘一股泼辣劲，主顾也没有好声气，教人活泼不得。只有老包到店，才可以笑几声。\n\n老包是个老师，身材高大，神色疲倦，鼻子上的眼镜片每年都要厚一圈，牛仔裤洗得发白，脚上的运动鞋大约是五六年前的款式，破旧的公文包鼓鼓囊囊，装的都是作业和试卷。\n\n听人背地里谈论，老包曾经是村里唯一的大学生，不知道怎生沦落到这般光景。旁人问起名字，他一概不应答。\n\n据说除了教书，他还要下乡扶贫、控缀保学、入户走访、信息录入、防艾宣传、文明创建、双高双普、秸秆焚烧、防止溺水、关注App、做各种调查、造各种档案、填各种资料，迎各种检查……仿佛无所不能无所不包，我们便把他唤作“老包”。\n\n做工的人对老包有点敬畏，因为他是读过大学的人。但又对他有些轻视，他们的收入是老包两倍。\n\n倘若有长舌妇说什么“老师一天上两节课，红包收到手软，补课一年买套房”，他们照例是要哄笑一番的。\n\n老包是戴着眼镜喝酒不点荤菜的唯一的人。\n\n老包一到店，所有人都看着他笑。有的叫道，“老包，听说你又犯事了！”他不回答，对柜里说，“一碗酒，一盘青椒豆腐”。\n\n有人故意高声嚷道，“你一定又体罚学生了！”老包睁大眼睛说，“你怎么这样凭空污人清白……”\n\n“什么清白？', '', null, '0', '1', '42', '0', '1555503538');
INSERT INTO `pm_chat` VALUES ('7', '9', '154', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '好想回家', '玩游戏', '好想回家', '', null, '0', '1', '4', '0', '1555559884');
INSERT INTO `pm_chat` VALUES ('12', '9', '154', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '你敢', '喵星人', '你敢', '/uploads/20190418/5cb826428b4ae.jpeg', '/uploads/20190418/s_5cb826428b4ae.jpeg', '0', '1', '0', '0', '1555572290');
INSERT INTO `pm_chat` VALUES ('13', '9', '154', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '尖叫鸡', '喵星人', '尖叫鸡', '/uploads/20190418/5cb82fe1cf580.jpeg|/uploads/20190418/5cb82fe1dcf92.png', '/uploads/20190418/s_5cb82fe1cf580.jpeg|/uploads/20190418/s_5cb82fe1dcf92.png', '0', '1', '0', '0', '1555574754');
INSERT INTO `pm_chat` VALUES ('14', '9', '154', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '1231', '喵星人', '1231', '/uploads/chat/20190418/5cb84137bd3cb.png', '/uploads/chat/20190418/s_5cb84137bd3cb.png', '0', '1', '0', '0', '1555579191');

-- ----------------------------
-- Table structure for `pm_chat_comment`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_comment`;
CREATE TABLE `pm_chat_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chatID` int(11) NOT NULL,
  `userID` int(11) NOT NULL COMMENT '话题发起人ID',
  `memberID` int(11) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `headimg` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `digg` int(11) NOT NULL,
  `open` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `createTime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pm_chat_comment
-- ----------------------------
INSERT INTO `pm_chat_comment` VALUES ('1', '5', '0', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '1', '1', '1', '1555516363');
INSERT INTO `pm_chat_comment` VALUES ('2', '5', '0', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '1', '0', '1', '1555516372');
INSERT INTO `pm_chat_comment` VALUES ('3', '5', '0', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '1', '0', '1', '1555517953');
INSERT INTO `pm_chat_comment` VALUES ('4', '5', '0', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', 'asdfasdf', '2', '1', '1', '1555518011');
INSERT INTO `pm_chat_comment` VALUES ('5', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '小黑说的不错', '0', '1', '1', '1555555623');
INSERT INTO `pm_chat_comment` VALUES ('6', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '其实真心不错', '0', '1', '1', '1555555951');
INSERT INTO `pm_chat_comment` VALUES ('7', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '123123', '0', '1', '1', '1555555967');
INSERT INTO `pm_chat_comment` VALUES ('8', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '3123123', '0', '1', '1', '1555555973');
INSERT INTO `pm_chat_comment` VALUES ('9', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', 'AA', '0', '1', '1', '1555555996');
INSERT INTO `pm_chat_comment` VALUES ('10', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '2222', '0', '1', '1', '1555556092');
INSERT INTO `pm_chat_comment` VALUES ('11', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '啛啛喳喳错错错', '1', '1', '1', '1555556101');
INSERT INTO `pm_chat_comment` VALUES ('12', '5', '0', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '是的发生', '1', '1', '1', '1555556106');
INSERT INTO `pm_chat_comment` VALUES ('13', '5', '1', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '啊啊啊啊啊啊啊啊啊啊', '0', '0', '1', '1555556679');
INSERT INTO `pm_chat_comment` VALUES ('14', '6', '1', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '我来了', '0', '1', '1', '1555559929');
INSERT INTO `pm_chat_comment` VALUES ('15', '4', '1', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '有点意思，哈哈', '0', '1', '1', '1555559978');
INSERT INTO `pm_chat_comment` VALUES ('16', '7', '1', '2', '张飞', 'http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png', '尖叫鸡', '0', '1', '1', '1555572008');

-- ----------------------------
-- Table structure for `pm_chat_digg`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_digg`;
CREATE TABLE `pm_chat_digg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commentID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `createTime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pm_chat_digg
-- ----------------------------
INSERT INTO `pm_chat_digg` VALUES ('1', '4', '1', '1555555516');
INSERT INTO `pm_chat_digg` VALUES ('2', '3', '1', '1555555522');
INSERT INTO `pm_chat_digg` VALUES ('3', '2', '1', '1555555537');
INSERT INTO `pm_chat_digg` VALUES ('4', '1', '1', '1555555541');
INSERT INTO `pm_chat_digg` VALUES ('5', '4', '2', '1555555613');
INSERT INTO `pm_chat_digg` VALUES ('6', '12', '2', '1555556131');
INSERT INTO `pm_chat_digg` VALUES ('7', '11', '2', '1555556133');

-- ----------------------------
-- Table structure for `pm_chat_focus`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_focus`;
CREATE TABLE `pm_chat_focus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat_focus
-- ----------------------------
INSERT INTO `pm_chat_focus` VALUES ('6', '1', '2');

-- ----------------------------
-- Table structure for `pm_chat_like`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_like`;
CREATE TABLE `pm_chat_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chatID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat_like
-- ----------------------------
INSERT INTO `pm_chat_like` VALUES ('8', '5', '1');
INSERT INTO `pm_chat_like` VALUES ('5', '6', '1');
INSERT INTO `pm_chat_like` VALUES ('6', '4', '1');
INSERT INTO `pm_chat_like` VALUES ('10', '5', '2');

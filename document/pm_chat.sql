/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : baishiwu

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2019-04-18 00:38:58
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
  `createTime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat
-- ----------------------------
INSERT INTO `pm_chat` VALUES ('4', '9', '153', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '哥们的婚宴上，他两个壮得像小牛犊子似的小舅子是这样对他说的：你要是敢欺负我姐，我们哥俩可饶不了你！哥…', '萝莉控', '哥们的婚宴上，他两个壮得像小牛犊子似的小舅子是这样对他说的：你要是敢欺负我姐，我们哥俩可饶不了你！哥们连忙赔笑：把心放肚子里吧，我绝对不会欺负她！第三天新姑爷回门，新娘子一回到家就把俩小舅子给揍了……他不欺负我，你们让他欺负谁去？俩小舅子：姐夫，救我！', '/uploads/20190417/5cb718a3174c2.png', '/uploads/20190417/s_5cb718a3174c2.png', '0', '1', '0', '1555503267');
INSERT INTO `pm_chat` VALUES ('5', '9', '156', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '超级直男', '人生就是这样，忍耐吧', '/uploads/20190417/5cb718d39d6bf.jpeg|/uploads/20190417/5cb718d3a2f5b.jpeg|/uploads/20190417/5cb718d3a8ef7.jpeg', '/uploads/20190417/s_5cb718d39d6bf.jpeg|/uploads/20190417/s_5cb718d3a2f5b.jpeg|/uploads/20190417/s_5cb718d3a8ef7.jpeg', '0', '1', '84', '1555503315');
INSERT INTO `pm_chat` VALUES ('6', '9', '154', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '现代版《孔乙已》老包鲁镇的酒店格局，和别处不同：都是当街一个曲尺形的大柜台，柜里面放着硕大的啤酒桶，…', '萝莉控', '现代版《孔乙已》\n老包\n\n鲁镇的酒店格局，和别处不同：都是当街一个曲尺形的大柜台，柜里面放着硕大的啤酒桶，桶上装有水龙头，可以随时倒啤酒。\n\n做工的人，晌午傍晚散了工，三三俩俩地聚一桌，每每花上百来块，一条鱼，一盘肉，再加上几碟小菜，热热地吃了休息。\n\n倘若肯花上五块钱，买一大碗酒，就着饭菜喝下去，打个饱嗝，空气中都有麦芽的香味，甭提有多满足。\n\n现在的小工一天两百块，大师傅能拿到三五百，许多人每顿都要喝上两大碗酒。\n\n我从十二岁起，便在镇口的咸亨酒店里当伙计，老板娘说我样子太傻，就在外面做点跑腿的事罢。\n\n虽然没什么失职，但总觉得有点单调和无聊。老板娘一股泼辣劲，主顾也没有好声气，教人活泼不得。只有老包到店，才可以笑几声。\n\n老包是个老师，身材高大，神色疲倦，鼻子上的眼镜片每年都要厚一圈，牛仔裤洗得发白，脚上的运动鞋大约是五六年前的款式，破旧的公文包鼓鼓囊囊，装的都是作业和试卷。\n\n听人背地里谈论，老包曾经是村里唯一的大学生，不知道怎生沦落到这般光景。旁人问起名字，他一概不应答。\n\n据说除了教书，他还要下乡扶贫、控缀保学、入户走访、信息录入、防艾宣传、文明创建、双高双普、秸秆焚烧、防止溺水、关注App、做各种调查、造各种档案、填各种资料，迎各种检查……仿佛无所不能无所不包，我们便把他唤作“老包”。\n\n做工的人对老包有点敬畏，因为他是读过大学的人。但又对他有些轻视，他们的收入是老包两倍。\n\n倘若有长舌妇说什么“老师一天上两节课，红包收到手软，补课一年买套房”，他们照例是要哄笑一番的。\n\n老包是戴着眼镜喝酒不点荤菜的唯一的人。\n\n老包一到店，所有人都看着他笑。有的叫道，“老包，听说你又犯事了！”他不回答，对柜里说，“一碗酒，一盘青椒豆腐”。\n\n有人故意高声嚷道，“你一定又体罚学生了！”老包睁大眼睛说，“你怎么这样凭空污人清白……”\n\n“什么清白？', '', null, '0', '1', '30', '1555503538');

-- ----------------------------
-- Table structure for `pm_chat_comment`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_comment`;
CREATE TABLE `pm_chat_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chatID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  `nickname` varchar(100) NOT NULL,
  `headimg` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `open` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `createTime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pm_chat_comment
-- ----------------------------
INSERT INTO `pm_chat_comment` VALUES ('1', '5', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '1', '1', '1555516363');
INSERT INTO `pm_chat_comment` VALUES ('2', '5', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '0', '1', '1555516372');
INSERT INTO `pm_chat_comment` VALUES ('3', '5', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', '人生就是这样，忍耐吧', '1', '1', '1555517953');
INSERT INTO `pm_chat_comment` VALUES ('4', '5', '1', '张小黑', 'http://www.worldmedia.top/uploads/2018-04-24/5adf05658be30.png', 'asdfasdf', '1', '1', '1555518011');

-- ----------------------------
-- Table structure for `pm_chat_focus`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_focus`;
CREATE TABLE `pm_chat_focus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat_focus
-- ----------------------------

-- ----------------------------
-- Table structure for `pm_chat_like`
-- ----------------------------
DROP TABLE IF EXISTS `pm_chat_like`;
CREATE TABLE `pm_chat_like` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chatID` int(11) NOT NULL,
  `memberID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pm_chat_like
-- ----------------------------
INSERT INTO `pm_chat_like` VALUES ('7', '5', '1');
INSERT INTO `pm_chat_like` VALUES ('5', '6', '1');
INSERT INTO `pm_chat_like` VALUES ('6', '4', '1');

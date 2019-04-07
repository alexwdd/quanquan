<template>
    <div class="wrap">
        <div class="top">
            <div class="left" @click="onClickLeft"><img src="../assets/image/left.png"></div>
            <div class="right"><div class="btn" @click="openApp">打开APP</div></div>
        </div>

        <div class="box">
            <div class="title">{{info.title}}</div>
            <div class="date">{{info.time}}</div>
            <!-- <div class="content" v-html="info.content"></div> -->

            <template v-if="isHide">
                <!-- 只显示摘要的画面 -->
                <div class="hideBg">
                    <div class="content" v-html="info.content"></div>
                    <div class="showBtn">
                        <!-- 绑定点击事件onShow，点击展开全文 -->
                        <a href="#" @click.stop.prevent="onShow">展开阅读全文&nbsp;
                            <!-- 向下的角箭头符号，用css画 -->
                            <span class="downArrow"></span>
                        </a>
                    </div>
                </div>
            </template>

            <template v-else>
                <!-- 显示完整内容的画面 -->
                <div class="showBg">
                    <div class="content" v-html="info.content"></div>
                    <div class="hideBtn">
                        <!-- 绑定点击事件onHide，点击收起内容 -->
                        <a href="#" @click.stop.prevent="onHide">收起&nbsp;
                            <!-- 向上的角箭头符号 -->
                            <span class="upArrow"></span>
                        </a>
                    </div>
                </div>
            </template>

            <div class="cateTitle">
                <p>{{config.APP_NAME}}更多精彩内容</p>
            </div>
            
            <van-swipe style="background:#fff" @change="onChange">
                <van-swipe-item v-for="(vo,index) in quick" :key="index">
                    <div class="quick">
                        <li v-for="(f,i) in vo" :key="i" @click="goLink(f)"><a :href="vo.url"><img :src="f.image"><p>{{f.name}}</p></a></li>
                    </div>
                </van-swipe-item>
                <div class="custom-indicator" slot="indicator">
                    <li v-for="(vo,index) in quick" :key="index">
                        <span v-if="index==current" class="active"></span>
                        <span  v-else=""></span>
                    </li>
                </div>
            </van-swipe>

            <van-swipe :autoplay="3000" indicator-color="white">
                <van-swipe-item v-for="vo in ad1" :key="vo.name"><div class="ad"><img :src="vo.image" @click="goLink(vo)"/></div></van-swipe-item>
            </van-swipe>
   

            <div class="cateTitle">
                <router-link :to="'/news/'+info.cid">
                <p>相关推荐</p>
                <span>查看全部</span>
                </router-link>
            </div>

            <van-row class="news" v-for="vo in about" :key="vo.id">
                <van-col span="8"><div class="img" @click="detail(vo.id)"><img v-lazy="vo.picname"></div></van-col>
                <van-col span="16">
                    <div class="info" @click="detail(vo.id)">
                        <div class="title">
                        <h1>{{vo.title}}</h1>
                        </div>
                        <div class="bottom">{{vo.createTime}}</div>
                    </div>
                </van-col>
            </van-row>

            <van-swipe :autoplay="3000" indicator-color="white">
                <van-swipe-item v-for="vo in ad2" :key="vo.name"><div class="ad"><img :src="vo.image" @click="goLink(vo)"/></div></van-swipe-item>
            </van-swipe>

            <div class="cateTitle">
                <router-link to="/commend">
                <p>{{config.APP_NAME}}推荐</p>
                <span>查看全部</span>
                </router-link>
            </div>

            <div class="container-water-fall">
                <waterfall
                    :col=2
                    :width="itemWidth"
                    :gutterWidth=0
                    :data="fallData"
                >
                    <template>
                        <div class="cell-item" v-for="item in fallData"  @click="commInfo(item)" :key="item.id">
                            <img :src="item.image">
                            <div class="item-body">
                                <div class="item-desc">{{item.title}}</div>
                                <div class="item-footer">
                                    <div class="avatar" v-if="item.user.headimg==''"><img src="../assets/image/logo.jpg"></div>
                                    <div class="avatar" v-else=""><img :src="item.user.headimg"></div>
                                    <div class="name" v-if="item.user.nickname==''">{{config.APP_NAME}}</div>
                                    <div class="name" v-else="">{{item.user.nickname}}</div>
                                    <div class="like">
                                        <van-icon name="like-o" />
                                        <div class="like-total">{{item.hit}}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </waterfall>
            </div>
        </div>

        <div class="footer">
            <div class="logo"><img src="../assets/image/logo.jpg"></div>
            <div class="info">
                <p>阿德莱德同城生活掌上宝</p>
                <p>
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                </p>
            </div>
            <div class="download" @click="download">下载APP</div>
        </div>

        <van-popup position="top" v-model="show">
            <div class="alert">
                <img src="../assets/image/alert.jpg">
            </div>
        </van-popup>

        <van-popup v-model="downShow" class="my-van-popup">
            <div class="down">
                <div class="hd"><img src="../assets/image/down.png"></div>
                <div class="bd">
                    <li><a :href="config.ANDROIDS"><img src="../assets/image/googleplay.png"></a></li>
                    <li><a :href="config.IOS"><img src="../assets/image/appstore.png"></a></li>
                </div>
            </div>
        </van-popup>
    </div>
</template>

<script>
import Vue from 'vue';
import waterfall from "vue-waterfall2";
import wx from 'weixin-js-sdk';
Vue.use(waterfall);

export default {
    data(){
		return {
            show:false,
            downShow:false,
            id:'',
            info:{},
            ad1:[],
            ad2:[],
            quick:{},
            about:[],
            fallData:[],
            isHide: true,    //初始值为true，显示为折叠画面
            back:false,
            current:0
		}
	},
	watch: {
        $route(to) {
            if (to.name == "view") {
                this.back = true;
                this.isHide = true;
                this.init();
            }
        }
    },
    computed: {
        itemWidth() {
            //return 138 * 0.5 * (document.documentElement.clientWidth / 375); //rem布局 计算宽度
            return document.documentElement.clientWidth / 2;
        },
        gutterWidth() {
            //return 9 * 0.5 * (document.documentElement.clientWidth / 375); //rem布局 计算x轴方向margin(y轴方向的margin自定义在css中即可)
            return 10;
        }
    },
	created(){
        this.init();
        this.getData();
	},
    methods: {
        onClickLeft() {
            if(this.back){
                this.$router.go(-1);
            }else{
                this.$router.push('/')
            }            
        },
        openApp(){
            if(this.config.isWeiXin()){
                this.show = true
            }else{
                var url = '';
                if(this.config.isIOS()){
                    url = this.config.IOS;
                }else{
                    url = this.config.ANDROIDS
                }
                if (this.open_app(this.config.SCHEME)) {
                    this.open_app(this.config.SCHEME);
                } else {
                    var delay = setInterval(function() {
                        var d = new Date();
                        var t1 = d.getTime();
                        var t0 = 0;
                        if (t1 - t0 < 3000 && t1 - t0 > 2000) {
                            //alert('检测到未安装，请下载APP');
                            window.location.href = url
                        }
                        if (t1 - t0 >= 3000) {
                            clearInterval(delay);
                        }
                    }, 1000);
                }
            }
        },
        open_app(src){
            // 通过iframe的方式试图打开APP，如果能正常打开，会直接切换到APP，并自动阻止a标签的默认行为
            // 否则打开a标签的href链接
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            if (userAgent.indexOf("Safari") > -1) {
                window.location.href = src;
            } else {
                var ifr = document.createElement('iframe');
                ifr.src = src;
                ifr.style.display = 'none';
                document.body.appendChild(ifr);
                window.setTimeout(function() {
                    document.body.removeChild(ifr);
                }, 2000);
            }
        },
        download(){
            this.downShow = true;  
        },
        goLink(value){
            if(value.url!=''){
                window.location.href = value.url;
            }else{
                if(value.articleid>0){
                    this.$router.push({name:'detail',params:{type: value.type,id:vaule.articleid}})
                }
            }
        },
        onChange(index) {
            this.current = index;
        },
        onShow: function(){
            this.isHide = false;    //点击onShow切换为false，显示为展开画面
        },
        onHide: function(){
            this.isHide = true;    //点击onHide切换为true，显示为折叠画面
        },
        detail(infoid){
            this.$router.push({name:'view',params:{id:infoid}})
        },
        commInfo(info){
            if(info.type=='article'){
                this.$router.push({name:'view',params:{id:info.articleid}})
            }else{
                this.$router.push({name:'detail',params:{type: info.type,id:info.articleid}})
            }            
        },
        init(){
            var that = this;
            that.id = that.$route.params.id;
			if (that.id>0 && that.id!=''){
                let data = {
                    id : that.id,
                    cityID:that.config.CITYID
                };
				that.$http.post("/V3/weixin/view",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        // 加载状态结束
                        that.info = res.body.data;
                        that.ad1 = res.body.ad1;
                        that.ad2 = res.body.ad2;
                        that.quick = res.body.quick;
                        that.about = res.body.about;
                        document.title = res.body.data.title
                        that.share(that.info);
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }          
        },
        share(info){
            var that = this;
            var url = that.config.DOMAIN+'view/'+info.id;
            that.$http.post("/V3/weixin/wxsdk",{ reqUrl: window.location.href }).then(result => {
                let res = result.data;
                wx.config({ 
                    beta: true,
                    debug: false, //生产环境需要关闭debug模式 
                    appId: res.appID, //appId通过微信服务号后台查看 
                    timestamp: res.timestamp, //生成签名的时间戳 
                    nonceStr: res.noncestr, //生成签名的随机字符串 
                    signature: res.signature, //签名 
                    jsApiList: [ //需要调用的JS接口列表 
                        'onMenuShareTimeline', //分享给好友 
                        'onMenuShareAppMessage', //分享到朋友圈 
                    ] 
                });
                wx.ready(function () {
                    //检测js接口
                    wx.checkJsApi({
                        jsApiList: [
                            'onMenuShareTimeline', //检测客户微信版本是否支持该接口
                            'onMenuShareAppMessage'
                        ],
                        success: function (res) {
                            //alert(JSON.stringify(res));
                        }
                    });

                    wx.onMenuShareTimeline({
                        title: info.title, // 分享标题
                        link: url, // 分享链接
                        imgUrl:that.config.LOGO, // 分享图标
                    });

                    wx.onMenuShareAppMessage({
                        title: info.title, // 分享标题
                        desc: that.config.APP_NAME, // 分享描述
                        link: url, // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
                        imgUrl: that.config.LOGO, // 分享图标
                        type: '', // 分享类型,music、video或link，不填默认为link
                        dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                    });
                })
                
            });
        },
        getData() {
            var that = this;
            that.type = that.$route.params.type;
            let data = {
                cityID : that.config.CITYID
            };                
            that.$http.post("/V3/weixin/topcomm",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    this.fallData = res.body;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>

<style scoped>
.top{clear: both; overflow: hidden; height: 46px; position: fixed; left: 0; width: 100%; z-index: 999; background: #fff; border-bottom: 1px #f1f1f1 solid}
.top img{display: block; height: 46px;}
.top .left{float: left;}
.top .right{float: right;}
.top .right .btn{float:right; height: 30px; line-height: 30px; background: #05c1af; border-radius: 5px; color: #fff; margin-right: 10px; margin-top: 10px; font-size: 14px; padding: 0 10px}

.cateTitle{background: #fff; clear: both; overflow: hidden; margin-top: 3px; height: 40px; line-height: 40px; padding-right:5px; font-size: 14px;margin-bottom: 1px;}
.cateTitle p{float: left; border-left: 2px #05c1af solid; padding-left: 5px; font-weight: bold}
.cateTitle span{display: block; float: right; font-size: 12px; color: #999}
.ad{margin-top: 3px; clear: both; overflow: hidden; padding: 0 5px;}
.ad img{border-radius: 5px; display: block;}

.quick{background: #fff; clear: both;overflow: hidden; padding-top: 10px; padding-bottom: 10px}
.quick li{float: left;width: 20%; text-align: center;font-size: 12px; margin-bottom: 10px}
.quick li img{display: block; width: 12vw; height: 12vw; margin:auto; }

.news{clear: both; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed;background: #fff}
.news .img{width: 110px; margin-right: 10px; float: left;}
.news .img img{width: 100%; height:80px}

.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .bottom{font-size: 12px; text-align: right; color: #999; line-height: 20px;}


.cell-item{ padding:5px;}
.cell-item>img{width: 100%; border-radius: 5px; display: block}
.item-body{background: #fff}
.item-desc{font-size: 14px; padding: 5px;clear: both}
.item-footer{clear: both;background: #fff; overflow: hidden; padding: 5px;}
.item-footer .avatar{float: left; margin-right: 5px}
.item-footer .avatar img{display: block; width: 30px; height: 30px; border-radius: 50%}
.item-footer .name{line-height: 30px;float: left;font-size: 12px}
.item-footer .like{float: right; line-height: 30px; color: #999}
.item-footer .like i{float: left; margin-top: 7px; margin-right: 3px}
.item-footer .like .like-total{float: left; font-size: 12px}

.footer{background: rgba(0,0,0,0.8); width:100%; height: 50px; border-radius: 5px; margin: auto; position: fixed; left: 0;bottom: 0px; z-index: 999;}
.footer .logo{float: left; height: 40px; margin-top: 5px; margin-left: 5px; margin-right: 10px}
.footer .logo img{height: 40px; display: block;border-radius: 5px}
.footer .info{float: left; font-size: 14px; color: #fff; padding-top: 5px}
.footer .info p{line-height: 20px;}
.footer .info p i{color:#f60 }
.footer .download{float:right; height: 30px; line-height: 30px; background: #05c1af; border-radius: 5px; color: #fff; margin-right: 10px; margin-top: 10px; font-size: 14px; padding: 0 10px}

.box{padding-top: 46px; padding-bottom: 60px; clear: both; overflow: hidden; background: #fff}

.title{font-size: 18px; padding: 10px;background:#fff}
.date{font-size: 12px; color:#999; padding: 10px; border-bottom: 1px #dbdbdb solid;background:#fff}

.content{padding: 10px;background:#fff; z-index: 0;}

.hideBg {
    width: 100%;
    padding-bottom: 0;    /* 方便渐变层遮挡 */
    height: 500px;
    overflow: hidden;
    position: relative;
    margin-bottom: 50px
}
/* 全文背景板，基本与摘要相同 */
.showBg { clear: both; overflow: hidden;}
/* 展开按钮 */
.showBtn {
    position: absolute;
    width: 100%;    /* 与背景宽度一致 */
    bottom: 0;    /* 刚好遮挡在最后两行 */
    left: 0;
    z-index: 1;    /* 正序堆叠，覆盖在p元素上方 */
    text-align: center;
    background: linear-gradient(rgba(255,255,255,0), white);    /* 背景色半透明到白色的渐变层 */
    padding-top: 5rem;
}
/* 收起按钮 */
.hideBtn {
    text-align: right; padding-right: 10px;
}
/* 向下角箭头 */
.downArrow {
    display: inline-block;
    width: 8px;    /* 尺寸不超过字号的一半为宜 */
    height: 8px;
    border-right: 1px solid;    /* 画两条相邻边框 */
    border-bottom: 1px solid;
    transform: rotate(45deg);    /* 顺时针旋转45° */
    margin-bottom: 3px;
}
/* 向上角箭头，原理与下箭头相同 */
.upArrow {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-left: 1px solid;
    border-top: 1px solid;
    transform: rotate(45deg);
    margin-top: 3px;
}

.alert{width: 100%;}
.alert img{width: 100%}
.my-van-popup {background-color:transparent; width: 80%;}
.down{clear: both; overflow: hidden;}
.down img{display: block}
.down .hd{clear: both;}
.down .bd{background: #fff; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; padding: 20px; overflow: hidden; padding-right: 0}
.down .bd li{float: left; width: 50%; padding-right: 20px; box-sizing: border-box}
.custom-indicator {
    position: absolute;
    left: 0px;
    bottom: 0px;
    width: 100%;
    height: 20px;
    text-align: center
}

.custom-indicator li{display: inline-block; padding: 0 3px}
.custom-indicator li span{display: block; width: 6px; height: 6px; border-radius:3px; background: #ccc}
.custom-indicator li span.active{background: #f60; width: 14px}
</style>

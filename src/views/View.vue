<template>
    <div class="wrap">
        <div class="top">
            <div class="left" @click="onClickLeft"><img src="../assets/image/left.png"></div>
            <div class="right"><div class="btn" @click="download">下载APP</div></div>
        </div>

        <div class="box">
            <van-loading type="spinner" class="loadding" v-show="loadingShow"/>
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

        <van-popup v-model="show">
            <div class="down">
                <div class="hd">APP下载</div>
                <div class="bd">
                    <li><a :href="config.IOS"><img src="../assets/image/appstore.png"></a></li>
                    <li><a :href="config.ANDROIDS"><img src="../assets/image/googleplay.png"></a></li>
                </div>
            </div>
        </van-popup>
    </div>
</template>

<script>
export default {
    data(){
		return {
            loadingShow:true,
            show:false,
			id:'',
            info:{},
            isHide: true,    //初始值为true，显示为折叠画面
            back:false
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
	created(){
		this.init();
	},
    methods: {
        onClickLeft() {
            if(this.back){
                this.$router.go(-1);
            }else{
                this.$router.push('/')
            }            
        },
        download(){
            this.show = true
        },
        onShow: function(){
            this.isHide = false;    //点击onShow切换为false，显示为展开画面
        },
        onHide: function(){
            this.isHide = true;    //点击onHide切换为true，显示为折叠画面
        },
        init(){
            var that = this;
            that.id = that.$route.params.id;
			if (that.id>0 && that.id!=''){
                let data = {
                    id : that.id
                };
				that.$http.post("/V3/weixin/view",data).then(result => {
                    this.loadingShow=false;
                    let res = result.data;
                    if (res.code == 0) {
                        // 加载状态结束
                        that.info = res.body.data;
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
			}
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
</style>

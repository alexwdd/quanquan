<template>
    <div class="wrap">

        <div class="bg">
            <van-swipe :autoplay="3000" indicator-color="white">
                <van-swipe-item v-for="vo in info.photo" :key="vo.imageID"><div @click="showImagePreview" class="banner" :style="{backgroundImage:'url('+vo.image+')'}"></div></van-swipe-item>
            </van-swipe>

            <div class="top">{{info.nickname}}</div>
            <div class="arrow"><van-icon name="arrow-left" @click="onClickLeft"/></div>
            <div class="edit" v-show="info.edit"><van-icon name="edit" @click="onClickRight"/></div>
            <div class="face"><img :src="info.headimg"></div>
        </div>

        <div class="base">
            <div class="name">
                <h1>{{info.nickname}}</h1>
                <div class="focus" @click="doFocus" v-if="info.focus==0">关注</div>
                <div class="focus focused" @click="doFocus" v-else="">已关注</div>
            </div>
            <div class="tab">
                <van-tabs v-model="active" color="#7507c2" @click="onClickTab">
                <van-tab title="资料"></van-tab>
                <van-tab title="相册"></van-tab>
                </van-tabs>
            </div>
        </div>

        <div class="baseInfo" v-show="infoShow">
            <div class="info">
                <li>
                    <i class="icon icon-id color1"></i>
                    <p>{{info.userid}}</p>
                </li>
                <li>
                    <i class="icon icon-weixin color2"></i>
                    <p>{{info.wechat}}</p>
                </li>
                <li>
                    <i class="icon icon-shouji color3"></i>
                    <p>{{info.phone}}</p>
                </li>
                <li>
                    <i class="icon icon-xingbie color4"></i>
                    <p>{{info.gender}} {{info.age}} {{info.work}}</p>
                </li>
                <li>
                    <i class="icon icon-qian color5"></i>
                    <p>{{info.sign}}</p>
                </li>
            </div>

            <div class="visitor">
                <div class="hd">最近访客</div>
                <div class="bd">
                    <li @click="gotoUser(vo.userid)" v-for="vo in info.visitor" :key="vo.userid"><img :src="vo.headimg"></li>
                </div>
            </div>
        </div>

        <div class="photo" v-show="ablumShow">
            <div class="container-water-fall">
                <waterfall
                    :col=2
                    :width="itemWidth"
                    :gutterWidth=0
                    :data="ablum"
                >
                    <template>
                        <div class="cell-item" v-for="item in ablum"  @click="gotoComment(item)" :key="item.image">
                            <img :src="item.image">
                        </div>
                    </template>
                </waterfall>
            </div> 
        </div>
    </div>
</template>

<script>
import Vue from 'vue';
import user from './auth'
import waterfall from "vue-waterfall2";
import { ImagePreview } from 'vant';

Vue.use(waterfall);

export default {
    data() {
        return {
            active:0,
            token:'',
            info:[],
            infoShow:true,
            ablumShow:false,
            ablum:[]
        };
    },
    watch: {
        $route(to) {
            if (to.name == "user") {
                this.userinfo();
            }
        },

        active(newVal,oldVal){
            if(newVal==0){
                this.infoShow = true;
                this.ablumShow = false;
            }else{
                this.infoShow = false;
                this.ablumShow = true;
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
    created() {        
        if(user.status==true){ 
            this.token = user.token;
        }
        this.userinfo();
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        onClickRight() {
            window.location.href = "app://userEdit";
        },
        gotoUser(id){
            this.$router.push({'path':'/chat/user',query:{userid:id,token:this.token}});
        },
        showImagePreview(position, timer) {
            var that = this,images=[];
            for(var i in that.info.photo){
                images.push(that.info.photo[i].image);
            }
            const instance = ImagePreview({
                images,
                asyncClose: !!timer,
                startPosition: typeof position === 'number' ? position : 0
            });
            if (timer) {
                setTimeout(() => {
                    instance.close();
                }, timer);
            }
        },
        userinfo(){
            var that = this;  
            var data = {
                userid:that.$route.query.userid,
                token:user.token,
            };                
            that.$http.post("/V1/account/userDetail",data).then(result => {
                let res = result.data;
                this.info = res.body;
            });
        },
        getPhoto(){
            var that = this; 
            that.ablum = [];
            this.$toast.loading({duration:0});             
            var data = {
                userid:that.$route.query.userid,
            };                
            that.$http.post("/V1/account/album",data).then(result => {
                this.$toast.clear();
                let res = result.data;
                var dd = res.body.chat;
                for(var i in dd){
                    for(var j in dd[i]['images']){
                        that.ablum.push({id:dd[i]['id'],image:dd[i]['images'][j]['url']});
                    }
                }  
            });
        },
        onClickTab(index){
            if(index==1){
                this.getPhoto();
            }
        },
        gotoComment(info){
            this.$router.push({'path':'/chat/comment',query:{id:info.id,token:this.token}});
        },
        doFocus(){//关注
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    userID:that.info.userid
                };                
                that.$http.post("/V1/chat/focus",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已关注'){
                            that.info.focus = true;
                        }else{
                            that.info.focus = false;
                        }                         
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
    }
};
</script>
<style scoped>
.wrap{background: #fff}
.bg{background: #333; width: 100%; height:40vh; position: relative;}
.bg .top{color: #fff; line-height: 40px; position: absolute; left: 0; top: 0;text-align: center; z-index: 88; width: 100%;}
.bg .arrow{position: absolute; left: 10px; top: 10px; color: #fff;z-index: 99;}
.bg .edit{position: absolute; right: 10px; top: 10px; color: #fff;z-index: 99;}
.bg .face{position: absolute; left: 40px; bottom: -35px; width:70px; height:70px; border-radius: 5px; background: #fff; box-shadow: 0 0 5px #666}
.bg .face img{width: 66px; height: 66px; border-radius: 5px; display: block; margin: auto; margin-top: 2px;}
.banner{height: 40vh; background-size: cover}

.base{margin-top: 40px; padding: 10px}
.base .name{float: left;}
.base .name h1{font-size: 18px}
.base .name .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #7507c2; width: 60px; text-align: center; color: #fff; margin-top: 10px; margin-right: 10px;}
.base .name .focused{border: 1px #dbdbdb solid; background: #fff; color: #999; margin-right: 0}
.base .tab{float: right; width: 100px}

.baseInfo{clear: both;}
.baseInfo .info{clear: both; padding:10px}
.baseInfo .info li{clear: both; padding:5px; font-size: 14px}
.baseInfo .info li i{float: left; width: 18px; height: 18px; border-radius: 50%; font-size: 12px; line-height: 18px; text-align: center; color: #fff; margin-right: 5px}
.color1{background: #63b9b0}
.color2{background: #55c375}
.color3{background: #4b8dee}
.color4{background: #ec954a}
.color5{background: #e66ba8}

.visitor{clear: both; padding: 10px; overflow: hidden;}
.visitor .hd{font-weight:bold; font-size: 14px}
.visitor .bd{clear: both; margin-top: 10px}
.visitor .bd li{float: left; padding: 5px;}
.visitor .bd li img{width: 40px; height: 40px; border-radius: 5px}

.photo{clear: both; overflow: hidden; background: #fff}
.cell-item{ padding:5px;}
.cell-item>img{width: 100%; display: block}
</style>

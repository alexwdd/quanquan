<template>
    <div class="wrap">
        <van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft" v-show="barShow">
            <van-icon name="search" slot="right" />
        </van-nav-bar>

        <div style="height:44px;" v-show="barShow"></div>

        <div class="list">
            <li v-for="vo in info" :key="vo.id" @click="goto(vo)"><img :src="vo.picname"></li>
        </div>
        
        <div class="cateTitle">
            <router-link to="/commend">
            <p>{{config.APP_NAME}}推荐</p>
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
</template>

<script>
import Vue from 'vue';
import waterfall from "vue-waterfall2";
Vue.use(waterfall);

import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:'../static/image/default_320.jpg'
});
export default {
    data() {
        return {
            barShow:true,
            cateName:'',
            info:[],
            fallData:[]
        };
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
    watch: {
        $route(to) {
            if (to.name == "cate") {
                this.init();
                this.getData();
            }
        }
    },
    created() {
        this.init();
        this.getData();
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        init() {
            var that = this;
            if(this.config.isApp()){
                that.barShow = false;
            }
            that.canPost = false;
            let data = {
                cityID : that.config.CITYID,
                cid : that.$route.params.cid
            };
            that.$http.post("V3/weixin/newscate",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.cateName = res.body.cateName;
                    that.info = res.body.data;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        goto(value){
            if(this.config.isApp()){
                window.location.href = 'app://news?id='+value.id+"&title="+value.name;
            }else{
                this.$router.push({name:'news',params:{cid:value.id}});
            }
        },
        commInfo(info){
            if(this.config.isApp()){
                let url = '';
                if(info.type=='article'){
                    if (info.url!=''){
                        url = 'app://html?url='+info.url+'&type=article&articleid='+info.articleid+'&title='+info.title;
                    }else{
                        url = 'app://html?url='+info.html+'&type=article&articleid='+info.articleid+'&title='+info.title;
                    }
                }else{
                    if (info.html==''){
                        url = 'app://articledetail?articleid='+info.articleid+'&type='+info.type;
                    }else{
                        url = 'app://html?url='+info.html+'&type='+info.type+'&articleid='+info.articleid+'&title='+info.title;
                    }
                }
                window.location.href = url;
            }else{
                if(info.type=='article'){
                    this.$router.push({name:'view',params:{id:info.articleid}})
                }else{
                    this.$router.push({name:'detail',params:{type: info.type,id:info.articleid}})
                }
            }         
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
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.list{clear: both; overflow: hidden; padding-left: 10px;}
.list li{float: left; width: 50%; padding-right: 10px; box-sizing: border-box; margin-top: 10px}
.list li img{display: block}
.cateTitle{text-align: center; padding: 20px 0; background: url(../assets/image/bg.png)}
.cateTitle p{display: inline-block; background: #f1f1f1; padding: 0 10px}
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
</style>

<template>
    <div class="wrap">
        <van-nav-bar class="myTop" fixed z-index="999" :title="cateName" left-arrow @click-left="onClickLeft" v-show="barShow"/>

        <div class="topCate" :style="'top:'+top+'px'">
            <div class="cateTab">
                <van-tabs color="#05c1af" v-model="cateActive">
                    <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                        <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="cateBar" @click="show"><van-icon name="bars"></van-icon></div>
        </div>

        <div class="cateList" :style="'top:'+top+'px'" v-show="cateShow">
            <div class="hd">全部分类 <van-icon name="cross" @click="show"></van-icon></div>
            <swipe class="my-swipe" :auto="0">
				<swipe-item v-for="vo in quick">
                    <div class="quick">
                        <li v-for="f in vo" :key="f.id" @click="changeCate1(f)"><img :src="f.icon"><p>{{f.title}}</p></li>
                    </div>
                </swipe-item>
			</swipe>               
        </div>

        <div :style="'height:'+height+'px'"></div>
        
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <template v-if="showType=='big'">
            <infoDetail v-for="vo in info" :info="vo" :type="type" :padding="true" :key="vo.id"></infoDetail>
            </template>

            <template v-if="showType=='small'">
            <van-row class="news" v-for="vo in info" :key="vo.articleid">
                <van-col span="8"><div class="img" @click="detail(vo)"><img v-lazy="vo.thumb_s"></div></van-col>
                <van-col span="16">
                    <div class="info" @click="detail(vo)">
                        <div class="title">
                        <h1>{{vo.title}}</h1>
                        </div>
                        <div class="address"><van-icon class-prefix="icon" name="weizhi" /> {{vo.address|empty}}</div>
                        <div class="bottom">
                            <div class="price"><van-icon class-prefix="icon" name="meiyuan" /> {{vo.price}}</div>
                            <div class="date">
                            {{vo.createTime}}
                            </div>
                        </div>
                    </div>
                </van-col>
            </van-row>
            </template>
        </van-list>
    </div>
</template>

<script>
import Vue from 'vue';
import def from '../assets/image/default_320.jpg';
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:def
});

import { Swipe, SwipeItem } from 'vue-swipe';
import 'vue-swipe/dist/vue-swipe.css';
//注册轮播图
Vue.component('swipe', Swipe);
Vue.component('swipe-item', SwipeItem);

import infoDetail from "../components/infoDetail";

export default {
    data() {
        return {
            top:46,
            height:92,
            barShow:true,
            cateShow:true,
            cateName:'',
            sort:0,
            cate:[{title:'全部',id:0,checked:true}],
            quick:[],
            current:0,
            cateActive:1,
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            showType:'small',//展示模式small小图,big大图模式
            type:'',
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "list") {
                this.info = [];
                this.cate = [{title:'全部',id:0,checked:true}],
                this.quick = [];
                this.cateShow=false;
                this.page = 1;
                this.sort = 0;
                this.onLoad();
            }
        }
    },
    components:{infoDetail},
    created() {
        if(this.config.isApp()){
            if(this.$route.query.showType=='big'){
                this.showType = "big";
            }
            this.type = this.$route.params.type;
            this.info = [];
            this.cate = [{title:'全部',id:0,checked:true}],
            this.quick = [];
            this.cateShow=false;
            this.page = 1;
            this.sort = 0;
            this.show();
            this.onLoad();
        }
    },
    methods: {
        onClickLeft() {
            //this.$router.go(-1);
            this.$router.push({path:'/'})
        },
        show(){
            this.cateShow = !this.cateShow;
        },
        detail(info){
            let type = this.$route.params.type;
            if(this.config.isApp()){
                let url = '';
                if (info.html==''){
                    url = 'app://articledetail?articleid='+info.articleid+'&type='+type;
                }else{
                    url = 'app://html?url='+info.html+'&type='+type+'&articleid='+info.articleid+'&title='+info.title;
                }
                window.location.href = url;
            }else{
                this.$router.push({name:'detail',params:{type: type,id:info.articleid}})
            }            
        },
        changeCate(sort){
            this.sort = sort;
            this.info = [];
            //this.cate = [{title:'全部',id:0,checked:true}],
            this.page = 1;
            this.onLoad();
        },
        changeCate1(value){
            this.cateShow = false;
            this.cateActive = value.index;
            this.sort = value.id;
            this.info = [];
            //this.cate = [{title:'全部',id:0,checked:true}],
            this.page = 1;
            this.onLoad();
        },
        onLoad() {
            var that = this;
            this.type = that.$route.params.type;
            if(this.config.isApp()){
                that.barShow = false;
                that.top = 0;
                that.height = 46;
            }

            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                sort : that.sort,
                cityID : that.config.CITYID,
                type : that.$route.params.type,
                page : that.page,
            };
            if(that.$route.query.keyword){
                data.keyword = that.$route.query.keyword
            }
            that.$http.post("V3/weixin/infolist",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);  
                    if(that.cate.length==1){
                        that.cate = that.cate.concat(res.body.cate);
                    }
                    that.cateName = res.body.cateName;
                    that.quick = res.body.quick;
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    },
    mounted:function(){
        this.show();
    },
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.topCate{position: fixed; width: 100%; display: flex;background: #fff; z-index: 999;}
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:46px; width: 100%; z-index: 999; background: #fff}
.cateList .hd{height: 44px; line-height: 44px; text-align: center; position: relative; background: #05c1af; color: #fff}
.cateList i{position: absolute;right: 5px; top: 15px}
.my-swipe{height: 250px;width: 100vw; border-bottom: 1px #f1f1f1 solid}
.wrap >>> .mint-swipe-indicator.is-active {background: #f00;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; width:20%; text-align: center;font-size: 12px; padding: 10px 0}
.quick li img{display: block; margin: auto; height: 40px}
.custom-indicator {position: absolute;left: 0px;bottom:10px;width: 100%;height: 20px;text-align: center}
.custom-indicator li{display: inline-block; padding: 0 3px}
.custom-indicator li span{display: block; width: 6px; height: 6px; border-radius:3px; background: #ccc}
.custom-indicator li span.active{background: #f60; width: 14px}


.news{clear: both; background:#fff; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed}
.news .img{width: 110px; margin-right: 10px; float: left;}
.news .img img{width: 100%; height:80px}

.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .address{ overflow:hidden;  text-overflow:ellipsis; white-space:nowrap; width: 100%; font-size: 14px;color: #999}
.news .info .bottom .price{float: left; font-size: 14px;color: #05c1af}
.news .info .bottom .date{font-size: 12px; text-align: right; color: #999; line-height: 20px; float: right;}
.news .info i{color: #05c1af}


</style>

<template>
    <div class="wrap">
        <van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft"/>

        <div class="topCate">
            <div class="cateTab">
                <van-tabs color="#7507c2" v-model="cateActive">
                    <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                        <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="cateBar" @click="show"><van-icon name="bars"></van-icon></div>
        </div>

        <div class="cateList" v-show="cateShow">
            <div class="hd">全部分类 <van-icon name="cross" @click="show"></van-icon></div>
            <div class="bd">
                <li v-for="(vo,index) in cate" :key="vo.id" @click="changeCate1(vo.id,index)">{{vo.title}}</li>
            </div>
        </div>

        <div style="height:92px"></div>
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <van-row class="news" v-for="vo in info" :key="vo.articleid">
                <van-col span="8"><div class="img" @click="detail(vo.articleid)"><img v-lazy="vo.thumb_s"></div></van-col>
                <van-col span="16">
                    <div class="info" @click="detail(vo.articleid)">
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
        </van-list>
    </div>
</template>

<script>
import Vue from 'vue';
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:'../static/image/default_320.jpg'
});
export default {
    data() {
        return {
            cateShow:false,
            cateName:'',
            sort:0,
            cate:[{title:'全部',id:0,checked:true}],
            cateActive:1,
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "list") {
                this.info = [];
                this.cate = [{title:'全部',id:0,checked:true}],
                this.page = 1;
                this.sort = 0;
                this.onLoad();
            }
        }
    },
    created() {},
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        show(){
            this.cateShow = !this.cateShow;
        },
        detail(infoid){
            let type = this.$route.params.type;
            this.$router.push({name:'detail',params:{type: type,id:infoid}})
        },
        changeCate(sort){
            this.sort = sort;
            this.info = [];
            //this.cate = [{title:'全部',id:0,checked:true}],
            this.page = 1;
            this.onLoad();
        },
        changeCate1(sort,index){
            this.cateShow = false;
            this.cateActive = index;
            this.sort = sort;
            this.info = [];
            this.page = 1;
            this.onLoad();
        },
        onLoad() {
            var that = this;            
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
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #7507c2;}

.topCate{position: fixed; top: 46px; width: 100%; display: flex;background: #fff}
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #7507c2;}
.cateList{position: fixed; top:46px; width: 100%; z-index: 999; background: #fff}
.cateList .hd{height: 44px; line-height: 44px; text-align: center; position: relative; background: #7507c2; color: #fff}
.cateList i{position: absolute;right: 5px; top: 15px}
.cateList .bd{background: #fff; clear: both; overflow: hidden;border-bottom:1px #f1f1f1 solid}
.cateList .bd li{float: left; width: 25%; text-align: center;font-size: 12px; padding: 10px 0}
.news{clear: both; background:#fff; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed}
.news .img{width: 110px; margin-right: 10px; float: left;}
.news .img img{width: 100%; height:80px}

.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .address{ overflow:hidden;  text-overflow:ellipsis; white-space:nowrap; width: 100%; font-size: 14px;color: #999}
.news .info .bottom .price{float: left; font-size: 14px;color: #7507c2}
.news .info .bottom .date{font-size: 12px; text-align: right; color: #999; line-height: 20px; float: right;}
.news .info i{color: #7507c2}
</style>

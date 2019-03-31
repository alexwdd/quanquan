<template>
    <div class="wrap">
        <van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft"/>

        <div class="topCate">
            <van-tabs color="#05c1af" v-model="cateActive">
                <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                    <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                </van-tab>
            </van-tabs>
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
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("V3/weixin/infolist",data).then(result => {
                this.$toast.clear();
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
<style>
.van-nav-bar .van-icon {color: #05c1af;}
</style>

<style scoped>
.topCate{position: fixed; top: 46px; width: 100%;}
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

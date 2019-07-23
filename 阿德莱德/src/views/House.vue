<template>
    <div class="wrap">
        <van-nav-bar fixed z-index="999" :title="cateName" left-arrow @click-left="onClickLeft" v-show="barShow"/>

        <div class="topCate" :style="'top:'+top+'px'">
            <van-tabs color="#05c1af">
                <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                    <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                </van-tab>
            </van-tabs>
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
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:'../static/image/default_320.jpg'
});
import infoDetail from "../components/infoDetail";
export default {
    data() {
        return {
            top:46,
            height:92,
            barShow:true,
            cateName:'',
            sort:0,
            cate:[{title:'租房',id:0,checked:true},{title:'卖房',id:1,checked:true}],
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            houseType:0,
            showType:'small',//展示模式small小图,big大图模式
            type:'zf',
            page:1
        };
    },
    components:{infoDetail},
    watch: {
        $route(to) {
            if (to.name == "house") {
                this.loading = true;
                this.info = [];
                this.page = 1;
                this.sort = 0;
                this.onLoad();
            }
        }
    },
    created() {
        if(this.config.isApp()){
            if(this.$route.query.showType=='big'){
                this.showType = "big";
            }
            this.loading = true;
            this.info = [];
            this.page = 1;
            this.sort = 0;
            this.onLoad();
        }
    },
    methods: {
        onClickLeft() {
            //this.$router.go(-1);
            this.$router.push({path:'/'})
        },
        detail(info){
            let type = this.type;
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
            this.loading = true;
            this.houseType = sort;
            this.info = [];
            this.page = 1;
            this.onLoad();
        },
        onLoad() {
            var that = this;    
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
                type : that.type,
                houseType : that.houseType,
                page : that.page,
            };
            that.$http.post("V3/weixin/infolist",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);  
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
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.topCate{position: fixed; top: 46px; width: 100%; z-index: 999;}
.news{clear: both; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed;background:#fff}
.news .info{padding-left:5px}
.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .address{ overflow:hidden;  text-overflow:ellipsis; white-space:nowrap; width: 100%; font-size: 14px;color: #999}
.news .info .bottom .price{float: left; font-size: 14px;color: #05c1af}
.news .info .bottom .date{font-size: 12px; text-align: right; color: #999; line-height: 20px; float: right;}
.news .info i{color: #05c1af}
</style>
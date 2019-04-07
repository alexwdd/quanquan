<template>
    <div class="wrap">
        <van-nav-bar fixed :title="title" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
        <div class="container-water-fall">
            <waterfall
                :col=2
                :width="itemWidth"
                :gutterWidth=0
                :data="info"
            >
                <template>
                    <div class="cell-item" v-for="item in info" @click="commInfo(item)" :key="item.id">
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
        </van-list>
    </div>
</template>

<script>
import Vue from 'vue';
import { Lazyload } from 'vant';
import infoCell from "../components/infoCell";
import waterfall from "vue-waterfall2";
Vue.use(Lazyload,{
    loading:'/static/image/default_320.jpg'
});
Vue.use(waterfall);
export default {
    data(){
		return {
            title:this.config.APP_NAME+'推荐',
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
		}
    },
    components:{infoCell},
	watch: {
        $route(to) {
            if (to.name == "commend") {
                this.info = [];
                this.page = 1;
                this.onLoad();
            }
        }
    },
    computed: {
        itemWidth() {
            return document.documentElement.clientWidth / 2;
        },
        gutterWidth() {
            return 10;
        }
    },
	created(){},
    methods: {
        commInfo(info){
            if(info.type=='article'){
                this.$router.push({name:'view',params:{id:info.articleid}})
            }else{
                this.$router.push({name:'detail',params:{type: info.type,id:info.articleid}})
            }            
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        onLoad() {
            var that = this;            
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V3/weixin/getcomm",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);      
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
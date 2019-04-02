<template>
    <div class="wrap">
        <van-nav-bar fixed title="时事热点" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>

        <van-loading type="spinner" class="loadding" v-show="loadingShow"/>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="news" v-for="vo in info" :key="vo.id" @click="detail(vo.id)">
                <div class="img"><img :src="vo.picname|emptyImg"></div>
                <div class="info">
                    <div class="title">
                    <h1>{{vo.title}}</h1>
                    </div>
                    <div class="date">{{vo.createTime}}</div>
                </div>
            </div>
        </van-list>
    </div>
</template>

<script>
export default {
    data() {
        return {
            loadingShow:true,
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    created() {},
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        detail(infoid){
            this.$router.push({name: 'view',params:{ id:infoid }})
        },
        onLoad() {
            var that = this;            
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                cityID : that.config.CITYID,
                page : that.page
            };
            that.$http.post("V3/weixin/news",data).then(result => {
                this.loadingShow=false;
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
.news{clear: both; background: #fff; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed}
.news .img{width: 110px; margin-right: 10px}
.news .img img{width: 100%; height:80px}
.news .info{flex: 1}
.news .info h1{font-size: 16px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical; margin-bottom: 10px}
.news .info .title{height: 60px;}
.news .info .date{font-size: 12px; text-align: right; color: #999; line-height: 20px;}
</style>

<template>
    <div class="wrap">
        <van-swipe :autoplay="3000" indicator-color="white">
			<van-swipe-item v-for="vo in ad" :key="vo.name"><div class="banner"><img :src="vo.image"/></div></van-swipe-item>
		</van-swipe>

        <div class="indexMenu">
            <li v-for="item in cate" :key="item.type"><router-link :to="'/list/'+item.type"><img src=""><p>{{item.name}}</p></router-link></li>
        </div>

        <div class="indexList">
            <div class="hd">时事热点 <span>查看更多</span></div>
            <div class="db">
                <van-swipe :show-indicators=false>
                    <van-swipe-item v-for="vo in news" :key="vo.name">
                        <div class="news">
                            <img :src="vo.thumb"/>                            
                            <p>{{vo.title}}</p>
                        </div>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>

        <div class="indexList">
            <div class="hd">同城活动 <span>查看更多</span></div>
            <div class="db">
                <van-swipe :show-indicators=false>
                    <van-swipe-item v-for="vo in tongcheng" :key="vo.name">                        
                    <infoDetail :info="vo"></infoDetail>
                    </van-swipe-item>
                </van-swipe>
            </div>
        </div>
    </div>
</template>

<script>
import infoDetail from "../components/infoDetail";
export default {
    data() {
        return {
            ad :'',
            cate:'',
            news:'',
            tongcheng:''
        };
    },
    components:{infoDetail},
    watch: {
        $route(to) {
            if (to.path == "/") {
                this.init();
            }
        }
    },
    created() {
        this.init();
    },
    methods: {        
        init() {
            var that = this;
            this.$toast.loading({mask: true,duration:0});
            let data = {
                cityID : that.config.CITYID
            }
            that.$http.post("V1/article/getads",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
					that.ad = res.body.ads;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
            that.$http.post("V3/article/getmodels",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {
					that.cate = res.body;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
            that.$http.post("V3/article/getmain",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {
					that.news = res.body[0]['news'];
					that.tongcheng = res.body[1]['tc'];
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap {min-height: 100vh;}
.banner{height: 30vh;}
.banner img{width: 100%; height: 100%;}
.indexMenu{clear: both; overflow: hidden;}
.indexMenu li{float: left; width: 33.33%; text-align: center}

.indexList{clear: both; border-top: 1px #dbdbdb dashed; padding: 0 10px; padding-bottom: 10px}
.indexList .hd{height: 40px; line-height: 40px;}
.indexList .hd span{float: right; font-size: 12px; color: #05c1af}
.news img{height: 200px; width: 100%;}


</style>

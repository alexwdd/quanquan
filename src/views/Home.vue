<template>
    <div class="wrap">
        <van-swipe :autoplay="3000" indicator-color="white">
			<van-swipe-item v-for="vo in ad" :key="vo.name"><div class="banner"><img :src="vo.image"/></div></van-swipe-item>
		</van-swipe>

        <div class="indexMenu">
            <li v-for="item in cate" :key="item.type" @click="goto(item.type)"><img :src="item.icon"/><p>{{item.name}}</p></li>
        </div>

        <div class="indexList" v-for="item in cate" :key="item.type">
            <div class="hd" @click="goto(item.type)">{{item.name}} <span>查看更多</span></div>
            <div class="db">
                <van-swipe :show-indicators=false>
                    <van-swipe-item v-for="vo in item.child" :key="vo.name">                        
                    <infoDetail :info="vo" :type="item.type"></infoDetail>
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
        init(){
            var that = this;
            this.$toast.loading({mask: true,duration:0});
            let data = {
                cityID : that.config.CITYID
            }
            that.$http.post("V3/weixin/getmain",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    that.ad = res.body.ads;
                    for(var i in res.body.cate){
                        if(res.body.cate[i]['type']=='mall'){
                            res.body.cate[i]['icon'] = res.body.cate[i]['image'];
                        }else{
                            res.body.cate[i]['icon'] = '../static/image/'+res.body.cate[i]['type']+'_icon@2x.png';
                        }                        
                    }
                    that.cate = res.body.cate;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        goto(type){
            if(type=='news'){
                this.$router.push({path:'/news'});
            }else{
                this.$router.push({path:'/list/'+type});
            }
        }
    }
};
</script>
<style scoped>
.wrap {min-height: 100vh;}
.banner{height: 30vh;}
.banner img{width: 100%; height: 100%;}
.indexMenu{clear: both; overflow: hidden; padding: 15px 0}
.indexMenu li{float: left; width: 33.33%; text-align: center; padding: 10px; box-sizing: border-box; font-size: 14px}
.indexMenu li img{ height: 40px; display: block; margin: auto; margin-bottom: 10px}

.indexList{clear: both; border-top: 1px #dbdbdb dashed; padding: 0 10px; padding-bottom: 10px}
.indexList .hd{height: 40px; line-height: 40px;}
.indexList .hd span{float: right; font-size: 12px; color: #05c1af}
</style>

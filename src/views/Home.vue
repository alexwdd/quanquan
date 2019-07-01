<template>
    <div class="wrap">        
        <van-swipe :autoplay="3000" indicator-color="white">
			<van-swipe-item v-for="vo in ad" :key="vo.name"><div class="banner"><img :src="vo.image" @click="goLink(vo)"/></div></van-swipe-item>
		</van-swipe>

        <div class="indexMenu">
            <van-loading class="loadding" v-show="loadShow" size="20px"/>
            <template v-for="item in cate">
            <li :key="item.type" @click="goto(item)"><img :src="item.icon"/><p>{{item.name}}</p></li>
            </template> 
        </div>

        <template v-for="item in cate">
            <div class="indexList" :key="item.type" v-if="item.type!='chat'">
                <div class="hd" @click="goto(item)">{{item.name}} <span>查看更多</span></div>
                <div class="db">
                    <van-swipe :show-indicators=false :width="width">
                        <van-swipe-item v-for="vo in item.child" :key="vo.name">
                        <infoDetail :info="vo" :type="item.type" :padding="false"></infoDetail>
                        </van-swipe-item>
                    </van-swipe>
                </div>
            </div>
        </template>        
    </div>
</template>

<script>
import infoDetail from "../components/infoDetail";
import phoneIcon from '@/assets/image/phone.jpg'
export default {
    data() {
        return {
            width: document.body.clientWidth - 30,
            loadShow:true,
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
            let data = {
                cityID : that.config.CITYID,
                adID:92,
            }
            that.$http.post("V3/weixin/getmain",data).then(result => {
                let res = result.data;
                this.loadShow = false;
                if (res.code == 0) {              
                    that.ad = res.body.ads;
                    /* for(var i in res.body.cate){                        
                        if(res.body.cate[i]['type']=='mall'){
                            res.body.cate[i]['icon'] = res.body.cate[i]['image'];
                        }else{
                            res.body.cate[i]['name'] = that.config.getModelName(res.body.cate[i]['type']);
                            res.body.cate[i]['icon'] = '/adelaide/static/image/'+res.body.cate[i]['type']+'_icon@2x.png';
                        }                        
                    } */
                    that.cate = [{
                        type:'phone',
                        icon:phoneIcon,
                        name:'话费充值',
                        id:0
                    }];
                    //that.cate = res.body.cate;
                    that.cate = that.cate.concat(res.body.cate);
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        chongzhi(){
            window.location.href="http://chongzhi.worldmedia.top"
        },
        goLink(value){
            if(value.url!=''){
                window.location.href = value.url;
            }else{
                if(value.articleid>0){
                    this.$router.push({name:'detail',params:{type: value.type,id:vaule.articleid}})
                }
            }
        },
        goto(value){
            if(value.type=='article'){
                if(value.flag==0){
                    this.$router.push({name:'news',params:{cid:value.cid}});
                }else{
                    this.$router.push({name:'cate',params:{cid:value.cid}});
                }
            }else if(value.type=='chat'){
                this.$router.push({path:'/chat'});
            }else if(value.type=='zp'){
                this.$router.push({path:'/job'});
            }else if(value.type=='zf'){
                this.$router.push({path:'/house'});
            }else if(value.type=='mall'){
                window.location.href=value.url;
            }else if(value.type=='phone'){
                window.location.href="http://chongzhi.worldmedia.top";
            }else{
                this.$router.push({path:'/list/'+value.type});
            }
        }
    }
};
</script>
<style scoped>
.wrap {min-height: 100vh;}
.banner{height: 30vh;}
.banner img{width: 100%; height: 100%;}
.indexMenu{clear: both; overflow: hidden; padding: 15px 0;background: #fff}
.indexMenu li{float: left; width: 33.33%; text-align: center; padding: 10px; box-sizing: border-box; font-size: 14px}
.indexMenu li img{ height: 40px; display: block; margin: auto; margin-bottom: 10px}

.indexList{clear: both; border-top: 1px #dbdbdb dashed; padding: 0 10px; padding-bottom: 10px;background: #fff}
.indexList .hd{height: 40px; line-height: 40px;}
.indexList .hd span{float: right; font-size: 12px; color: #7507c2}
</style>

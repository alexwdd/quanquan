<template>
    <div class="wrap">
        <van-nav-bar title="快递查询" left-arrow @click-left="onClickLeft" v-show="!config.isApp()"/>
        <van-steps direction="vertical" :active="active">
            <van-step v-for="vo in info.TrackList">
            <div class="info">
                <h3>{{vo.StatusDetail}}</h3>
                <p>{{vo.StatusTime}}</p>
            </div>
            </van-step>
        </van-steps>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            info:[],
            active:0
        };
    },
    watch:{
    	$route(to,from){
		    if (to.name=='storeOrderProgress') { 
                this.info=[];
		    	this.init();
		    }
        },
    },
    created() {
        this.init();
    },
    methods: {        
        onClickLeft() {
            this.$router.go(-1);
        },
        init() {            
            var that = this;    
            let data = {
                token : user.token,
                No : that.$route.params.No
            };
            if(!that.config.isApp()){
                this.$toast.loading({duration:0});
            }
            that.$http.post("/V1/order/progress",data).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    that.info = res.body.data; 
                    if(that.info.TrackList){
                        that.active = that.info.TrackList.length-1;
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
.wrap >>> .van-nav-bar .van-icon {color: #000;}
.wrap >>> .van-nav-bar__text{color: #000}
.content{padding: 10px; background: #fff; clear: both;}
.wrap >>> .content p{margin-bottom: 1em}
.info h3{font-weight: normal; font-size: 14px}
.info p{font-size: 12px; color: #999}
</style>

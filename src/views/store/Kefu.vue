<template>
    <div class="wrap">
        <van-nav-bar title="在线客服" left-arrow @click-left="onClickLeft"/>
        <div class="content" v-html="info.content"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            info:[]
        };
    },
    watch:{
    	$route(to,from){
		    if (to.path=='/store/kefu') { 
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
                agentid : that.$route.query.agentid
            };          
            this.$toast.loading({duration:0});           
            that.$http.post("/V1/store/kefu",data).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    that.info = res.body; 
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
</style>

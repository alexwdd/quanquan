<template>
    <div class="wrap">
        <van-nav-bar title="商品详情" left-arrow @click-left="onClickLeft"/>

        
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
        };
    },
    watch:{
    	$route(to,from){
		    if (to.name=='storeAddressEdit') {
                this.init();
		    }
		}
    },
    created() {
        this.init();
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        onClickKefu(){
            this.show = true;
        },        
        onClickCart(){
            this.show = false;
        },
        onClickAdd(){
          
        },
        onClickBuy(){
        
        },
     
        init(){
            return false;
            var that = this;
            var data = {
                token:user.token,
                id:that.$route.params.id
            };
            that.$http.post("/V1/store/addressInfo",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body;
                    that.formData.name = res.body['name'];
                    that.formData.mobile = res.body['mobile'];
                    that.formData.province = res.body['province'];
                    that.formData.city = res.body['city'];
                    that.formData.area = res.body['area'];
                    that.formData.address = res.body['address'];
                    that.formData.front = res.body['front'];
                    that.formData.back = res.body['back'];
                    that.area = res.body['province']+' '+res.body['city']+' '+res.body['area'];
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        onSave(content) {
            var that = this;
            if (that.formData.name == "") {
                that.$toast('请输入真实姓名');
                return false;
            }
            if (that.formData.mobile == "") {
                that.$toast('请输入手机号码');
                return false;
            }
            if(!that.config.checkCnMobile(that.formData.mobile)){
                that.$toast('手机号码格式错误');
                return false;
            }
            if (that.formData.province == "" || that.formData.city == "" || that.formData.area == "") {
                that.$toast('请选择地区');
                return false;
            }
            if (that.formData.address == "") {
                that.$toast('请输入详细地址');
                return false;
            }
            if(that.checked){
                that.formData.def = 1;
            }
            that.formData.token = user.token;
            that.formData.id = that.info.id;
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/v1/store/addressPub",that.formData).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    this.$dialog.alert({title:'提示',message:res.desc});
                    this.$router.push({path:'/store/address',query:{token:user.token}});
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.sn{clear: both; overflow: hidden;}
.sn li{float: left; width: 40%;padding: 20px; box-sizing: border-box}
.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
</style>

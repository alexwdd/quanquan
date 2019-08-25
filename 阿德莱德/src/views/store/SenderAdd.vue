<template>
    <div class="wrap">
        <van-nav-bar title="新增发件人" left-arrow @click-left="onClickLeft"/>

        <van-field
            v-model="formData.name"
            clearable
            label="姓名"
            placeholder="发件人姓名"
        />
        <van-field
            v-model="formData.mobile"
            clearable
            label="电话"
            placeholder="发件人手机号码"
        />

        <van-switch-cell v-model="checked" title="设为默认" />

        <div class="btn">
            <van-button size="large" class="my-btn" @click="onSave">保存</van-button>
        </div>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            formData:{
                name:'',
                mobile:''              
            },
            checked:false,
        };
    },
    watch:{
    	$route(to,from){
		    if (to.path=='/store/senderAdd') {
                this.formData = {
                    name:'',
                    mobile:''
                }
		    }
		}
    },
    created() {

    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
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
            if(that.checked){
                that.formData.def = 1;
            }
            that.formData.token = user.token;
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/v1/address/senderPub",that.formData).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    this.$dialog.alert({title:'提示',message:res.desc});
                    if(that.$route.query.agentid){
                        that.$store.commit('SET_SENDER',res.body);
                        that.$router.push({name:'storeCreate',query:{token:user.token,agentid:user.agentid}});
                    }else{
                        that.$router.push({path:'/store/sender',query:{token:user.token}});
                    }                    
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

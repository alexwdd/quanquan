<template>
    <div class="wrap">
        <van-nav-bar fixed title="商品详情" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <div class="banner"></div>

        <div class="goodsInfo">
            <div class="goodsName">【售罄】发送到发送到发送到发送到</div>
            <div class="intr">疗效阿斯蒂芬阿斯蒂芬阿萨德案发生的阿萨德</div>
            <div class="price">$12.5</div>
            <div class="desc">                
                <li>重量 1kg</li>  
                <li>参考保质期 2019-10-10</li>
            </div>
            <div class="number">
                <van-stepper v-model="value" style="font-size:12px"/>
            </div>
            <div class="serverBox">
                <div class="hd">套餐</div>
                <div class="fd">
                    <li>123123123</li>
                    <li>123123123</li>
                    <li>123123123</li>
                </div>  
            </div>
            <div class="serverBox">
                <div class="hd">贴心服务</div>
                <div class="bd">巧克力、软糖、胶囊类等易融化的产品，由于运输过程中温度变化导致的变形、粘连等不在理赔范围，所有液体膏体易碎品需加固打包泡泡纸或气柱，物流公司才能理赔。</div>
                <div class="fd">
                    <li>123123123</li>
                    <li>123123123</li>
                    <li>123123123</li>
                </div>
            </div>
        </div>

        <div class="goodsAction">
            <div class="cartInfo">
                <div class="cart" id="topCart">
                    <van-icon name="cart-o" />
                    <em id="cartNumber">0</em>
                </div>
            </div>
            <div class="btn">加入购物车</div>
            <div class="btnBuy">立即购买</div>
        </div>
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
.banner{height: 200px; background: #000; width: 100%;}
.goodsInfo{clear: both; overflow: hidden; margin-bottom: 45px; background: #fff}
.goodsInfo .goodsName{ padding: 10px; color: #000; background-color: #fff; margin-top: 1px; font-weight: bold }
.goodsInfo .intr{ padding:0 10px;background: #fff;color: #999; font-size: 14px}
.goodsInfo .price{color: #f00; padding: 10px; font-weight: bold}
.goodsInfo .desc{clear: both; overflow: hidden; font-size: 14px; padding:0 10px; color: #999; padding-bottom: 10px}
.goodsInfo .desc li{float: left; width: 50%}
.goodsInfo .number{padding: 10px; padding-top: 0}

.serverBox{border-top:1px #dbdbdb dotted; background: #fff; overflow: hidden; padding:10px; font-size: 14px; padding-top: 0}
.serverBox .hd{font-weight:700;line-height:30px}
.serverBox .bd{color:#999;padding:5px 0;margin-bottom:10px}
.serverBox .fd li{border:1px #ddd solid;padding:5px;float:left;margin-right:10px;white-space:nowrap;margin-bottom:5px;cursor:pointer; font-size: 12px}
.serverBox .fd li.active{color:red;border-color:red}
.goodsAction{position: fixed; width: 100%; height:46px; left: 0; bottom: 0; background: #fff; display: flex; border-top: 1px #f1f1f1 solid}
.goodsAction .cartInfo{height: 44px; line-height: 44px;flex:1;-webkit-box-flex: 1;text-align: left; padding-left: 10px}
.goodsAction .cartInfo .cart{width: 50px; height: 50px; float: left; position: relative; background: #f24378; border-radius: 50%; margin-top: -10px}
.goodsAction .cartInfo .cart i{font-size: 24px; display: block; width: 50px; height: 50px; position: absolute; left: 0; top: 0; color: #fff; text-align: center; line-height: 50px}
.goodsAction .cartInfo .cart em{font-style: normal; border-radius: 50%; width: 16px; height: 16px; background: #fff; display: block; line-height: 16px;font-size: 12px; text-align: center; position: absolute; color: #f24378; right: 8px; top: 5px}
.goodsAction .cartInfo em.none{background: #ccc;}
.goodsAction .btn{flex: 1; background-color: #15a093; color: #fff; line-height: 46px; text-align: center}
.goodsAction .btnBuy{flex: 1; background-color: #05c1af; color: #fff; line-height: 46px; text-align: center}
</style>

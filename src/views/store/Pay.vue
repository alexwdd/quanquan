<template>
    <div class="wrap">
        <van-nav-bar title="选择支付方式" left-arrow @click-left="onClickLeft"/>

        <div class="payPrice">
            <li>
                <label>支付手续费</label>
                <p>${{payInfo.shouxufei}} AUD</p>
            </li>
            <li>
                <label>实付金额</label>
                <p>${{payInfo.total}} AUD</p>
            </li>
            <li>
                <label>当前汇率</label>
                <p>{{payInfo.huilv}}</p>
            </li>
            <li>
                <label>折合人民币</label>
                <p class="m">￥{{payInfo.rmb}} RMB</p>
            </li>   
        </div>
        <div class="panel">
            <div class="bd">
                <van-cell title="订单号" :value="info.order_no" />
                <van-cell title="下单时间" :value="info.createTime" />
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>选择支付方式</p>
            </div>
            <div class="bd">
                <div class="intr">支付宝、微信支付手续费{{shouxufei}}%</div>
                <div class="payType">
                    <li @click="setPay(1)"><img src="../../assets/image/type1.png" :class="{'active':payType==1}"></li>
                    <li @click="setPay(2)"><img src="../../assets/image/type2.png" :class="{'active':payType==2}"></li>
                    <!-- <li @click="setPay(3)"><img src="../../assets/image/type3.png" :class="{'active':payType==3}"></li> -->
                </div>
            </div>
        </div>

        <div class="btn">
            <van-button size="large" class="my-btn" @click="onSubmit">确认支付</van-button>
        </div>
        <div style="height:60px"></div>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            info:[],
            payInfo:{
                shouxufei:0,
                total:0,
                huilv:0,
                rmb:0,
            },
            shouxufei:0,
            payType:'',
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storePay") {
                this.init();
            }
        }
    },
    created(){
        this.init();
    },
    methods: {    
        onClickLeft() {
            this.$router.go(-1);
        },    
        init(){
            var that = this;            
            var data = {
                token:user.token,
                //agentid:user.agentid,
                order_no:that.$route.params.order_no
            };
            that.$http.post("/V1/order/orderInfo",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body.data;
                    that.payInfo.huilv = res.body.huilv;
                    that.payInfo.rmb = that.info.rmb;
                    that.payInfo.total = that.info.total;
                    that.shouxufei = res.body.shouxufei;
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        setPay(value){
            this.payType = value;
            if(value=='3'){                
                this.payInfo.shouxufei = 0;
                this.payInfo.total = this.info.total;
                this.payInfo.rmb = this.info.rmb;
            }else{
                //console.log(value);
                let shouxufei = this.info.total * (this.shouxufei / 100);
                let total = parseFloat(this.info.total) + parseFloat(shouxufei);
                let rmb = total * parseFloat(this.payInfo.huilv);
                this.payInfo.shouxufei = shouxufei.toFixed(2);
                this.payInfo.total = total.toFixed(2);
                this.payInfo.rmb = rmb.toFixed(2);
            }
        },
        onSubmit(){
            var that = this;
            if(this.payType==''){
                this.$toast('请选择支付方式');
                return false;
            }
            let url = '';
            if (this.payType=='1'){
                url = 'app://DaigouPay?payType=1&order_no='+this.info.order_no;
                window.location.href=url;            
            }
            
            if (this.payType=='2'){
                url = 'app://DaigouPay?payType=2&order_no='+this.info.order_no;
                window.location.href=url;
            }

            if (this.payType=='3'){
                this.$router.push({name:'storeCardPay',params:{order_no:this.info.order_no},query:{token:user.token,agentid:user.agentid}});
            }
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}

.payPrice{ text-align: center; padding: 30px 0; background: #fff; margin-bottom: 5px}
.payPrice li{clear: both; overflow: hidden; font-size: 14px; padding:5px 0}
.payPrice li label{float: left; width:100px; text-align: right; margin-right: 10px; color: #999}
.payPrice li p{ float: left;}
.payPrice li p.m{color: #000; font-weight: bold}

.panel{background: #fff; clear: both; overflow: hidden; margin-bottom: 5px}
.panel .hd{padding: 10px; font-size: 14px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid}
.panel .hd p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold}
.panel .hd span{float: right; font-size: 14px; color: #999}
.panel .hd{clear: both; overflow: hidden;}

.intr{font-size: 12px; padding: 10px}
.payType{clear: both; padding: 0 10px; padding-bottom: 10px; overflow: hidden;}
.payType li {float: left; margin-right:20px;}
.payType li img{display: block; padding: 3px; border: 1px #fff solid; width: 40px}
.payType li img.active{border: 1px #05c1af solid; padding: 3px; border-radius: 2px}

.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
</style>

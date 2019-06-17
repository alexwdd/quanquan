<template>
    <div class="wrap">
        <van-nav-bar title="选择支付方式"/>

        <div class="payPrice">
            <li>
                <label>支付手续费</label>
                <p>$1.59 AUD</p>
            </li>
            <li>
                <label>实付金额</label>
                <p>$160.75 AUD</p>
            </li>
            <li>
                <label>当前汇率</label>
                <p>4.7710</p>
            </li>
            <li>
                <label>折合人民币</label>
                <p class="m">￥766.9 RMB</p>
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
                <van-radio-group v-model="payType">
                    <van-cell-group>
                        <van-cell title="支付宝" clickable @click="payType = '1'">
                        <van-radio name="1" />
                        </van-cell>
                        <van-cell title="微信支付" clickable @click="payType = '2'">
                        <van-radio name="2" />
                        </van-cell>
                        <van-cell title="银行转账(人工审核)" clickable @click="payType = '3'">
                        <van-radio name="3" />
                        </van-cell>
                    </van-cell-group>
                </van-radio-group>              
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
        init(){
            var that = this;            
            var data = {
                token:user.token,
                agentid:user.agentid,
                order_no:that.$route.params.order_no
            };
            that.$http.post("/V1/store/orderInfo",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body;
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
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

.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
</style>

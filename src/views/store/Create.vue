<template>
    <div class="wrap">
        <van-nav-bar title="结算中心" left-arrow @click-left="onClickLeft"/>

        <div class="panel">
            <div class="hd">
                <p>收件人</p>
                <span @click="onClickAddress">+选择</span>
            </div>
            <div class="bd">
                <div class="user">
                    <p>{{address.name}} {{address.mobile}}</p>
                    <p>{{address.province}}{{address.city}}{{address.county}}{{address.addressDetail}}</p>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>发件人</p>
                <span @click="onClickSender">+选择</span>
            </div>
            <div class="bd">
                <div class="user">
                    <p>{{sender.name}} {{sender.mobile}}</p>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>费用明细</p>
            </div>
            <div class="bd">
                <van-cell title="商品金额" :value="money.total" />
                <van-cell title="服务费" :value="money.serverMoney" />
                <van-cell title="运费" :value="baoguo.totalPrice" />
                <van-cell title="偏远地区附加费" :value="baoguo.totalExtend" />
            </div>
        </div>

        <div style="height:60px"></div>

        <van-submit-bar
        :price="total"
        currency="$"
        button-text="去支付"
        @submit="onSubmit"
        />

    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            info:[],
            heji:[],
            kdInfo:[],
            address:[],
            sender:[],
            money:[],
            baoguo:[],
            total:0,
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeCreate") {
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
        onClickSender(){
            this.$router.push({path:'/store/sender',query:{token:user.token,agentid:user.agentid}});
        },
        onClickAddress(){
            this.$router.push({path:'/store/address',query:{token:user.token,agentid:user.agentid}});
        },
        init(){
            var that = this;
            if(that.$store.state.order.address){
                that.address = that.$store.state.order.address;
            }
            if(that.$store.state.order.sender){
                that.sender = that.$store.state.order.sender;
            }
            
            var data = {
                token:user.token,
                agentid:user.agentid,
                kid:that.$store.state.order.wuliu.id
            };
            that.$http.post("/V1/store/create",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.address = res.body.address;
                    that.sender = res.body.sender;
                    that.total = res.body.total;
                    that.money = res.body.money;
                    that.baoguo = res.body.baoguo;
                    that.total = that.total*100;

                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });      
        },
        onSubmit(){
            
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}

.panel{background: #fff; clear: both; overflow: hidden; margin-bottom: 5px}
.panel .hd{padding: 10px; font-size: 14px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid}
.panel .hd p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold}
.panel .hd span{float: right; font-size: 14px; color: #999}
.panel .hd{clear: both; overflow: hidden;}
.user{padding: 10px 15px; font-size: 14px}
.user p{color: #666;}
</style>

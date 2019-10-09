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

        <div class="panel" v-show="show">
            <div class="hd">
                <p>签名</p>
            </div>
            <div class="bd">
                <van-field
                    v-model="sign"
                    clearable
                    placeholder="输入签名（必填，中文一个字，英文不超过1个单词）"
                />
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>费用明细</p>
            </div>
            <div class="bd">
                <van-cell title="商品金额" :value="'$'+money.total" />
                <van-cell title="服务费" :value="'$'+money.serverMoney" />
                <van-cell title="运费" :value="'$'+baoguo.totalPrice" />
                <van-cell title="偏远地区附加费" :value="'$'+baoguo.totalExtend" />
            </div>
        </div>

        <div style="height:100px"></div>
        <div class="footer">   
            <div class="info">
                <p>合计：$<i>{{total}}</i></p>
                <span>约：￥{{rmb}}</span>
            </div>
            <div class="btn" @click="onSubmit">去支付</div>
        </div>

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
            address:'',
            sender:'',
            sign:'',
            show:false,
            money:[],
            baoguo:[],
            total:0,
            rmb:0
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
            this.$router.push({name:'storeCart',query:{token:user.token,agentid:user.agentid}});
        },
        onClickSender(){
            this.$router.push({path:'/store/sender',query:{token:user.token,agentid:user.agentid}});
        },
        onClickAddress(){
            this.$router.push({path:'/store/address',query:{token:user.token,agentid:user.agentid}});
        },
        init(){
            var that = this;            
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
                    that.rmb = res.body.rmb;
                    that.money = res.body.money;
                    that.baoguo = res.body.baoguo;     
                    if(res.body.flag==1){
                        that.show = true;
                    }
                    if(that.$store.state.order.address){
                        that.address = that.$store.state.order.address;
                    }
                    if(that.$store.state.order.sender){
                        that.sender = that.$store.state.order.sender;
                    }
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });      
        },
        onSubmit(){
            var that = this;
            if(this.address==''){
                this.$toast('请选择收件人');
                return false;
            }
            if(this.sender==''){
                this.$toast('请选择发件人');
                return false;
            }
            if(this.show){
                if(this.sign==''){
                    this.$toast('请输入签名');
                    return false;
                }
                let checkVal = this.sign;
                var reg = /^[\u4E00-\u9FA5]{1,500}$/;
                if(reg.test(checkVal)){//中文 
                    if (checkVal.length>1){
                        this.$toast('中文只能1个汉字'); return false;
                    }
                }else{
                    if (checkVal.indexOf(' ') >= 0){
                        this.$toast('英文不能超过1个单词'); return false;
                    }
                }
            }
            let data = {
                token:user.token,
                agentid:user.agentid,
                kid:that.$store.state.order.wuliu.id,
                sender:that.sender['name']+','+that.sender['mobile'],

                province:that.address.province,
                city:that.address.city,
                area:that.address.area,
                address:that.address.address,
                name:that.address.name,
                mobile:that.address.mobile,
                front:that.address.front,
                back:that.address.back,
                addressID:that.address.id,
                sign:that.sign
            };
            that.$http.post("/V1/store/doSubmit",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    this.$router.push({name:'storePay',params:{order_no:res.body},query:{token:user.token,agentid:user.agentid}});
                }else if(res.code==999){
                    window.location.href='app://login';  
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

.panel{background: #fff; clear: both; overflow: hidden; margin-bottom: 5px}
.panel .hd{padding: 10px; font-size: 14px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid}
.panel .hd p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold}
.panel .hd span{float: right; font-size: 14px; color: #999}
.panel .hd{clear: both; overflow: hidden;}
.user{padding: 10px 15px; font-size: 14px}
.user p{color: #666;}

.footer{position: fixed; bottom: 50px; width: 100%; height: 50px; border-top: 1px #f1f1f1 solid; background: #fff}
.footer .info{float: left; padding-left: 10px; padding-top: 5px}
.footer .info p{color: #F2493C; font-size:12px;}
.footer .info p i{font-size: 18px; font-weight: bold; font-style: normal}
.footer .info span{display: block; font-size: 12px;}
.footer .btn{float: right; background: #F0454C; font-size: 18px; line-height:50px; width: 100px; height: 50px; color: #fff; text-align: center;}
</style>

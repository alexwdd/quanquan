<template>
    <div class="wrap">
        <van-nav-bar fixed :title="name" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad"> 
            <div class="orderList" v-for="(vo,index) in info" :key="vo.id">
                <div class="hd">{{vo.order_no}}
                    <font style="color:#f00" v-if="vo.payType!=1 && vo.upload==0">(未传身份证)</font>
                    <font style="color:green" v-else="">(已传身份证)</font>

                    <font style="color:blue" v-if="vo.image==1">配货图片已上传</font>  
                    <span>${{vo.total}}</span></div>
                <div class="bd">
                    <div class="orderDetail">
                        <li>
                            <p v-for="f in vo.goods" :key="f.id">{{f.name}} x {{f.goodsNumber}}</p>
                        </li>
                    </div>
                </div>
                <div class="fd">                    
                    <div style="float:left">
                        <template v-if="vo.payStatus==0"><van-tag type="danger">待付款</van-tag></template>
                        <template v-else-if="vo.payStatus==1"><van-tag type="primary">待审核</van-tag></template>
                        <template v-else-if="vo.payStatus==2"><van-tag type="primary">待配货</van-tag></template>
                        <template v-else-if="vo.payStatus==3"><van-tag color="#7232dd">配货中</van-tag></template>
                        <template v-else-if="vo.payStatus==4"><van-tag type="success">已发货</van-tag></template>
                        <template v-else-if="vo.payStatus==99"><van-tag>取消订单</van-tag></template>
                    </div> 

                    <van-button type="warning" size="mini" v-if="vo.payStatus==0" @click="onClickDel(vo,index)">取消</van-button>

                    <van-button type="default" size="mini" v-if="vo.payStatus==0" @click="onClickPay(vo)">去支付</van-button>

                    <van-button type="default" size="mini" @click="onClickDetail(vo)">详情</van-button>
                </div>
            </div>           
        </van-list>        
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            name:'',
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeOrder") {
                this.info = [];
                this.page = 1;
                this.loading = true;
                this.finished = false;
                this.canPost = true;
                this.onLoad();
                this.getCateName();
            }
        }
    },
    created(){
        this.onLoad();
    },
    methods: {
        onClickLeft() {
            window.location.href = 'app://goback';
        },
        onClickDetail(item){
            this.$router.push({name:'storeOrderInfo', params:{id: item.id}, query:{token:user.token,agentid:user.agentid}});
        },
        onClickPay(info){
            this.$router.push({name:'storePay',params:{order_no:info.order_no},query:{token:user.token,agentid:user.agentid}});
        },
        onClickDel(info,index){
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:info.id
                };                
                that.$http.post("/V1/order/del",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.info.splice(index, 1);
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        onLoad() {
            var that = this;
            if(!that.canPost){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                payStatus : that.$route.query.payStatus,
                page : that.page,
            };
            that.$http.post("v1/order/index",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;     
                    that.name = res.body.name;             
                    that.info = that.info.concat(res.body.data);  
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
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
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}

.orderList{background: #fff; clear: both; overflow: hidden; margin-bottom: 5px; border-top: 1px #dbdbdb solid; border-bottom: 1px #dbdbdb solid; font-size: 14px}
.orderList .hd{background: #f7f7f7; height: 36px; line-height: 36px; padding: 0 10px}
.orderList .hd span{float: right;}
.orderList .fd{background: #f7f7f7; text-align: right; padding:5px 10px; font-size: 12px}
.orderList .fd span{font-size: 12px}
.orderList .fd .mui-btn{font-size: 12px;padding:3px 8px;}
.cipt{position: absolute; top: -100px}
.orderList .fdImage img{max-width: 100%;display: block; margin: auto}
.orderDetail{clear: both; overflow: hidden; border-bottom: 1px #dbdbdb solid; padding: 5px;}
.orderDetail:last-child{border: 0;}
.orderDetail li{clear: both; overflow: hidden;}
.orderDetail li p{line-height:20px; margin: 0; color: #999}
</style>

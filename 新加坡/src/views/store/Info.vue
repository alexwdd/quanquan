<template>
    <div class="wrap">
        <van-nav-bar fixed title="订单详情" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>
        <van-card
            v-for="vo in goods"
            :thumb="vo.goods.picname"
        >
        <div slot="title"><template v-if="vo.goods.wuliu!=''">【{{vo.goods.wuliu}}】</template>{{vo.goods.name}}{{vo.extends}}</div>
        <div slot="desc">
            <p>{{vo.goods.weight}}kg</p>
            <p>${{vo.price}} X {{vo.goodsNumber}}</p>            
            <div class="serverLi" v-for="s in vo.server">{{s.name}}${{s.price}}/件，数量{{vo.num}}，合计${{s.price*vo.num}}</div>
        </div>
        </van-card>

        <van-cell title="单号" :value="order.order_no" />  
        <van-cell title="下单时间" :value="order.createTime" />  
        <van-cell title="商品金额" :value="'$'+order.goodsMoney" />  
        <van-cell title="运费" :value="'$'+order.payment" />
        <van-cell title="订单总金额" :value="'$'+order.total" />
        <van-cell title="支付方式" :value="order.payType" />
        <div class="status">
            <p>状态</p>
            <span><van-tag size="medium" type="danger" v-if="order.payStatus==0">待付款</van-tag></span>
            <span><van-tag size="medium" type="primary" v-if="order.payStatus==1">待审核</van-tag></span>
            <span><van-tag size="medium" type="primary" v-if="order.payStatus==2">待配货</van-tag></span>
            <span><van-tag size="medium" color="#7232dd" v-if="order.payStatus==3">配货中</van-tag></span>
            <span><van-tag size="medium" type="success" v-if="order.payStatus==4">已发货</van-tag></span>
            <span><van-tag size="medium" v-if="order.payStatus==99">取消订单</van-tag></span>
        </div>       
        <van-cell title="备注" :value="order.remark" v-if="order.cancel==1"/>


        <div class="card" v-for="vo in person">
            <div class="header">收件人：{{vo.name}}，{{vo.mobile}}</div>
            <div class="content">
                <div class="list">
                    <li>
                        <p>地址</p>
                        <span>{{vo.province}} {{vo.city}} {{vo.area}} {{vo.address}}</span>
                    </li>
                    <li>
                        <p>身份证号码</p>
                        <span>{{vo.sn}}</span>
                    </li>
                    <li>
                        <p>身份证照片</p>
                        <span class="personImg">
                            <template v-if="vo.front==''">
                            <a href="#">上传身份证</a>
                            </template>
                            <template v-else="">
                            <a href="#" target="_blank"><img :src="vo.front"></a>
                            <a href="#" target="_blank"><img :src="vo.back"></a>
                            </template>
                        </span>
                    </li>
                    <li>
                        <p>发件人</p>
                        <span>{{vo.sender}}，{{vo.senderMobile}}</span>
                    </li>             
                </div>
            </div>        
    
            <div class="baoguo" v-for="f in vo.baoguo">
                <div class="hd">
                    <p style="float: left;margin: 0">{{f.kuaidi}},运费${{f.payment}},重量{{f.weight}}kg</p>
                    <p style="float: right;;margin: 0">
                    <template v-if="f.kdNo!=''">
                        <a href="#" target="_blank" v-if="f.type==12 || f.type==13 || f.type==14">物流查询</a>
                    </template>
                    <template v-else="">
                    <a href="{:url('order/wuliu','kd='.$f['kdNo'])}">物流查询</a>
                    </template>               
                    </p>
                </div>
                <div class="list">
                    <li v-if="f.kdNo==''">
                        <p>快递单号</p>
                        <span>未生成</span>
                    </li>
                    <li v-for="kd in f.kdNo">
                        <p>快递单号</p>
                        <span class="copyBtn">{{kd}} 复制</span>
                    </li>       
                </div>     
                <div class="bd">
                    <p v-for="g in f.goods">{{g.short}} * {{g.trueNumber}}</p>
                </div>
                <div class="wimg">  
                    <a href="#" target="_blank" v-for="img in f.eimg"><img :src="img"></a>
                    <a href="#" target="_blank" v-for="img in f.image"><img src="img"></a>
                </div>
            </div> 
        </div>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            name:'',
            goods:[],
            order:[],
            person:[]
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeOrderInfo") {
                this.init();
            }
        }
    },
    created(){
        this.init();
    },
    methods: {
        onClickLeft() {
            this.$router.push({name:'storeOrder', query:{token:user.token,agentid:user.agentid}});
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
        init() {
            var that = this;
            var data = {
                token:user.token,
                id:that.$route.params.id
            };
            that.$http.post("/V1/order/detail",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.goods = res.body.goods;
                    that.order = res.body.order;
                    that.person = res.body.person;
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

.status{background: #fff; clear: both; font-size: 14px;padding: 10px 15px; overflow: hidden;}
.status p{float: left;}
.status span{float: right;}

.card{clear: both; overflow: hidden; background: #fff; margin-top: 5px; font-size: 14px}
.card .header{padding: 10px; border-bottom: 1px #f1f1f1 solid}
.card .content{padding: 10px; clear: both; overflow: hidden;}
.list{clear: both; overflow: hidden; background: #fff}
.list li{border-bottom: 1px #f1f1f1 solid; padding: 10px 0; clear: both; overflow: hidden;}
.list li p{float: left; color: #666; margin: 0;}
.list li span{float: right; color: #000}

.personImg{text-align: right;}
.personImg img{width: 80px;}

.baoguo{clear: both; margin: 10px; overflow: hidden; border:1px #dbdbdb solid;}
.baoguo .hd{background: #f7f7f7;height:40px; line-height: 40px; border-bottom: 1px #dbdbdb solid; padding:0 10px}
.baoguo .hd span{float: right; margin-top: 10px;}
.baoguo .bd{padding: 10px}
.baoguo .bd p{margin: 0}
.baoguo .list li{padding: 10px}

.wimg{clear: both; overflow: hidden; width: 100%}
.wimg a{display: block; overflow: hidden; text-align: center; padding: 5px 10px}
.wimg img{width:100%;display: block; margin: auto}
</style>

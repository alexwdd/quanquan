<template>
    <div class="wrap">
        <van-nav-bar fixed title="订单详情" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>
        <van-card
            v-for="vo in goods"
            :thumb="vo.goods.picname"
        >
        <div slot="title">{{vo.goods.name}}{{vo.extends}}</div>
        <div slot="desc">
            <p>{{vo.goods.weight}}kg</p>
            <p>${{vo.price}} X {{vo.goodsNumber}}</p>            
            <div class="serverLi" v-for="s in vo.server">{{s.name}}${{s.price}}/件，数量{{vo.num}}，合计${{Math.round(s.price*vo.num*100)/100}}</div>
        </div>
        </van-card>

        <van-cell title="单号" :value="order.order_no" />  
        <van-cell title="下单时间" :value="order.createTime" />  
        <van-cell title="商品金额" :value="'$'+order.goodsMoney" />  
        <van-cell title="运费" :value="'$'+order.payment" />
        <van-cell title="支付手续费" :value="'$'+order.shouxufei" />
        <van-cell title="订单总金额" :value="'$'+order.total" />
        <van-cell title="实付总金额" :value="'$'+order.trueMoney" />
        <van-cell title="折合人民币" :value="'￥'+order.rmb" />
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


        <div class="card" v-for="(vo,index) in person">
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
                            <span @click="showPersonCard(index)" style="color:#f00">上传身份证</span>
                            </template>
                            <template v-else="">      
                            <span @click="showPersonCard(index)">查看身份证</span>
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
                        <template v-if="f.url!=''">
                        <a :href="f.url" target="_blank">物流查询</a>
                        </template>
                        <template v-else>
                        <a href="javascript:void(0)" @click="onClickSearch(f.kdNo)">物流查询</a>
                        </template>
                    </template>                                
                    </p>
                </div>
                <div class="list">
                    <li v-if="f.kdNo==''">
                        <p>快递单号</p>
                        <span>未生成</span>
                    </li>
                    <li v-else>
                        <p>快递单号</p>
                        <span class="copyBtn" @click="copy" :data-clipboard-text="f.kdNo">{{f.kdNo}} 复制</span>
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

        <van-popup v-model="showCard" position="bottom" :style="{ height: '100%' }" style="background:#f1f1f1">
            <div class="close"><p>上传身份证</p><van-icon name="cross" @click="closeCard"/></div>
            <div class="cardPerson">
                <li>
                    <van-uploader
                        :after-read="onReadFront"
                        accept="image/gif, image/jpeg, image/png"
                        style="width:100%"
                        >
                        <div class="face" v-if="card.front!=''"><img :src="card.front" /></div>
                        <div class="face" v-else=""><img src="../../assets/image/sn1.png" /></div>
                    </van-uploader>  
                </li>                
                <li>
                    <van-uploader
                        :after-read="onReadBack"
                        accept="image/gif, image/jpeg, image/png">
                        <div class="face" v-if="card.back!=''"><img :src="card.back" /></div>
                        <div class="face" v-else=""><img src="../../assets/image/sn2.png" /></div>
                    </van-uploader>
                </li>
            </div>
        </van-popup>
    </div>
</template>

<script>
import user from '../chat/auth'
import Clipboard from 'clipboard'
export default {
    data() {
        return {
            name:'',
            goods:[],
            order:[],
            person:[],
            showCard:false,
            card:[{
                index:0,
                id:0,
                front:'',
                back:''
            }],
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
        onClickSearch(kdNo){
            this.$router.push({name:'storeOrderProgress',params:{No:kdNo},query:{token:user.token}});
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
        },
        copy() {
            var clipboard = new Clipboard(".copyBtn");
            clipboard.on("success", e => {
                this.$toast("复制成功");
                // 释放内存
                clipboard.destroy();
            });
            clipboard.on("error", e => {
                // 不支持复制
                this.$toast("该浏览器不支持自动复制");
                // 释放内存
                clipboard.destroy();
            });
        },
        showPersonCard(index){
            this.card.front = this.person[index].front;
            this.card.back = this.person[index].back;
            this.card.id = this.person[index].id;
            this.card.index = index;
            this.showCard = true;
        },
        closeCard(){
            this.showCard = false;
        },
        onReadFront(file){
            var that = this;
            that.compressImage(file,800,0,function(res){
                let data = {
                    token:user.token,
                    id : that.card.id,
                    front : res
                };
                that.$toast.loading({duration:0});
                that.$http.post("/V1/order/updatePersonCard",data).then(result => {
                    that.$toast.clear();
                    let res = result.data;
                    if (res.code == 0) {
                        that.person[that.card.index].front = res.body.front;
                        that.card.front = res.body.front;                        
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            });           
        },
        onReadBack(file){
            var that = this;
            that.compressImage(file,800,0,function(res){                    
                let data = {
                    token:user.token,
                    id : that.card.id,
                    back : res
                };
                that.$toast.loading({duration:0});
                that.$http.post("/V1/order/updatePersonCard",data).then(result => {
                    that.$toast.clear();
                    let res = result.data;
                    if (res.code == 0) {
                        that.person[that.card.index].back = res.body.back;
                        that.card.back = res.body.back;
                        console.log(that.card.back);
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });     
            });           
        },
        compressImage(file,width,height=0,callback){
            var img = new Image();
            img.src = file.content
            img.onload = function() {
                var that = this;
                if(height>0){
                    var w = width,h = height;
                }else{
                    //生成比例
                    var w = that.width,h = that.height,scale = w / h;
                    w = width || w;
                    h = w / scale;
                }
                //生成canvas
                let canvas = document.createElement('canvas');
                let ctx = canvas.getContext('2d');      
                canvas.width = w;
                canvas.height = h;
                ctx.drawImage(that, 0, 0, w, h);
                // 生成base64            
                let base64 =  canvas.toDataURL(file.file.type, 0.8);
                callback(base64)
            };
        },
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

.close{clear: both; overflow: hidden; padding: 10px; background: #fff}
.close p{float: left; padding-left: 10px;}
.close i{color: #dbdbdb; display: block; width: 20px; height: 20px; line-height: 20px; border:1px #dbdbdb solid; float: right; border-radius: 50%; text-align: center}
.cardPerson{clear: both; overflow: hidden;}
.cardPerson li{clear: both; text-align: center; padding: 20px 0; width: 60%; margin: auto}
.cardPerson li .face{margin: auto; text-align: center; width:60vw;}
.cardPerson li .face img{width: 100%; display: block}
</style>

<template>
    <div class="wrap">
        <van-nav-bar title="银行卡支付"/>

        <div class="payPrice">
            <h2><span>￥</span>{{info.rmb}}</h2>
            <p>应付RMB</p>
        </div>

        <div class="panel">
            <div class="bd">
                <van-cell title="澳币" :value="'$'+info.total" />
                <van-cell title="人民币" :value="'￥'+info.rmb" />
                <van-cell title="支付时请备注单号" :value="info.order_no+' 复制'" />
                <van-cell title="下单时间" :value="info.createTime" />
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>选择收款账户</p>
            </div>
            <div class="bd">
                <div class="card">
                    <li :class="{'active':thisCard.cardno==vo.cardno}" v-for="vo in card" :key="vo.id" @click="onClickCard(vo)">{{vo.name}}</li>
                </div>
                <div class="cardInfo" v-if="thisCard!=''">
                    <p>银行：{{thisCard.bank}}</p>
                    <p>账户：{{thisCard.account}}</p>
                    <p>BSB：{{thisCard.bsb}}</p>
                    <p>账号：{{thisCard.cardno}}</p>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="hd">
                <p>上传截图</p>
            </div>
            <div class="bd">
                <van-uploader
                    :after-read="getBase64"
                    accept="image/gif, image/jpeg, image/png"
                    style="width:100%">
                    <div class="face"><img :src="imgBase64" /></div>
                </van-uploader>
            </div>
        </div>

        <div class="btn">
            <van-button size="large" class="my-btn" @click="onSubmit">提交</van-button>
        </div>
        <div style="height:60px"></div>
    </div>
</template>

<script>
import user from '../chat/auth'
import payImage from '../../assets/image/pay.png'
export default {
    data() {
        return {
            info:[],
            imgBase64:payImage,
            doSet:false,
            card:[],
            thisCard:''
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeCardPay") {
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
            that.getCard();
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
        getCard(){
            var that = this;            
            var data = {
                token:user.token,
                agentid:user.agentid
            };
            that.$http.post("/V1/store/getCard",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.card = res.body;
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        getBase64(file) {
            var that = this;
            if(/\/(?:jpeg|png|gif)/i.test(file.file.type)&&file.file.size>1000000) {
                let res = this.compressImage(file,800,0,function(res){
                    that.imgBase64 = res;             
                }); 
            }else{
                that.imgBase64 = file.content;
            }            
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
        onClickCard(item){
            this.thisCard = item;
        },
        onSubmit(){
            var that = this;
            if(this.thisCard==''){
                this.$toast('请选择收款账户');
                return false;
            }

            if(payImage==this.imgBase64){
                this.$toast('请上传截图');
                return false;
            }
            
            let data = {
                token:user.token,
                agentid:user.agentid,
                image:that.imgBase64,
                cardID:that.thisCard.id,
                id:that.info.id
            }
            that.$http.post("/V1/store/cardPay",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    
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

.payPrice{ text-align: center; padding: 30px 0 }
.payPrice h2 span{font-size: 12px; font-weight: normal}
.payPrice p{margin-top: 10px; color: #999;}

.face{text-align: center}

.panel{background: #fff; clear: both; overflow: hidden; margin-bottom: 5px}
.panel .hd{padding: 10px; font-size: 14px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid}
.panel .hd p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold}
.panel .hd span{float: right; font-size: 14px; color: #999}
.panel .hd{clear: both; overflow: hidden;}

.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
.card{clear: both; overflow: hidden; padding: 10px; background: #fff}
.card li{float:left; text-align: center; text-align: center; height: 30px;line-height:30px; cursor: pointer; border: 1px #dbdbdb solid; padding:0 10px; font-size: 14px; margin-right: 10px}
.card li.active{background: #39c4da; color: #fff; border-color:#39c4da}
.cardInfo{border: 1px #f1f1f1 solid; padding: 10px; margin:10px; background: #f7f7f7; font-size:14px; margin-top: 0}
</style>

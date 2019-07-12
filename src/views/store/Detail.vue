<template>
    <div class="wrap">
        <van-nav-bar fixed title="商品详情" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <van-swipe :autoplay="3000" indicator-color="white">
			<van-swipe-item v-for="vo in info.image" :key="vo.name"><div class="banner"><img :src="vo"/></div></van-swipe-item>
		</van-swipe>

        <div class="goodsInfo">
            <div class="goodsName"><span v-if="info.empty==1">【售罄】</span>{{info.name}}</div>
            <div class="intr">{{info.say}}</div>
            <div class="price">${{price}}</div>
            <div class="desc">                
                <li>重量 {{info.weight}}kg</li>  
                <li>参考保质期 {{info.endDate}}</li>
            </div>
            <div class="number">
                <van-stepper v-model="num"/>
            </div>

            <div class="serverBox" v-if="spec!=''">
                <div class="hd">套餐</div>
                <div class="fd">
                    <li v-for="vo in spec" :key="vo.id" :class="{'active':vo.id==specid}" @click="onClickSpec(vo)"><template v-if="vo.wuliu!=''">【{{vo.wuliu}}】包邮</template>{{vo.name}} {{vo.weight}}kg ${{vo.price}}</li>
                </div>  
            </div>

            <div class="serverBox" v-if="info.extends!=''">
                <div class="hd">规格</div>
                <div class="fd">
                    <li v-for="vo in info.extends" :key="vo" :class="{'active':vo==exts}" @click="onClickExts(vo)">{{vo}}</li>
                </div>  
            </div>

            <div class="serverBox">
                <div class="hd">贴心服务</div>
                <div class="bd">巧克力、软糖、胶囊类等易融化的产品，由于运输过程中温度变化导致的变形、粘连等不在理赔范围，所有液体膏体易碎品需加固打包泡泡纸或气柱，物流公司才能理赔。</div>
                <div class="fd">
                    <li v-for="(vo,index) in server" :key="vo.id" @click="onClickServer(vo,index)" :class="{'active':vo.checked}">{{vo.name}}</li>
                </div>
            </div>

            <div class="more" v-show="!show">
                <p><van-button type="default" size="small" @click="showMore">查看更多介绍</van-button></p>
            </div>

            <div class="content" v-show="show">
                <div class="hd">商品介绍</div>                
                <div class="bd" v-html="info.content"></div>
            </div>
        </div>

        <div class="goodsAction">
            <div class="cartInfo">
                <div class="cart" id="topCart" @click="onClickCart">
                    <van-icon name="cart-o" />
                    <em id="cartNumber">{{cartNumber}}</em>
                </div>
            </div>
            <div class="btn" @click="onClickAdd">加入购物车</div>
            <div class="btnBuy" @click="onClickAdd('buy')">立即购买</div>
        </div>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            num:1,
            price:0,
            specid:0,
            serverid:'',
            exts:'',
            info:[],
            server:[],
            spec:[],
            thisSpec:[],
            cartNumber:0,
            show:false
        };
    },
    watch:{
    	$route(to,from){
		    if (to.name=='storeDetail') {
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
        showMore(){
            this.show = !this.show;
        },         
        onClickCart(){
            this.$router.push({name:'storeCart',query:{token:user.token,agentid:user.agentid}});
        },
        onClickAdd(type){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                goodsID : that.info.goodsID,
                typeID : that.info.typeID,
                specid : that.specid,
                server : that.serverid,
                number : that.num,
                exts : that.exts
            }
            that.$http.post("/v1/store/cartAdd",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    if(type=='buy'){
                        this.$router.push({name:'storeCart',query:{token:user.token,agentid:user.agentid}});
                    }else{
                        that.$dialog.alert({title:'提示',message:res.desc});
                        that.cartNumber = res.body;
                    }                    
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        onClickServer(item,index){
            this.server[index]['checked'] = !this.server[index]['checked'];
            this.serverid = '';
            for(var i in this.server){
                if(this.server[i]['checked']){
                    if(this.serverid==''){
                        this.serverid = this.server[i]['id'];
                    }else{
                        this.serverid += ','+this.server[i]['id'];
                    }
                }                
            }
        },  
        onClickExts(item){
            if(this.exts==item){
                this.exts = '';
            }else{
                this.exts = item;
            }            
        }, 
        onClickSpec(item){
            if(this.specid==item.id){
                this.price = this.info.price;
                this.specid = this.info.id;
            }else{
                this.price = item.price;
                this.specid = item.id;
            }            
        },        
        init(){
            var that = this;

            that.num = 1;
            that.price = 0;
            that.specid = 0;
            that.serverid = '';
            that.exts = '';
            that.info = [];
            that.server = [];
            that.spec = [];
            that.thisSpec = [];
            that.cartNumber = 0;
            that.show = false;
            that.getCartNumber();

            that.specid = that.$route.params.specid;
            var data = {
                token:user.token,
                agentid:user.agentid,
                id:that.$route.params.id,
                specid:that.$route.params.specid,
            };
            that.$http.post("/V1/store/detail",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body.goods;
                    that.server = res.body.server;
                    that.spec = res.body.spec;
                    that.thisSpec = res.body.thisSpec;
                    that.price = that.thisSpec.price;
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        getCartNumber() {  
            var that = this;          
            var data = {
                token:user.token,
                agentid:user.agentid
            };
            that.$http.post("/v1/store/cartNumber",data).then(result => {
                let res = result.data;
                if (res.code == 0) {              
                    that.cartNumber = res.body;
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

.content{padding: 10px; font-size: 14px}
.more{text-align: center; padding-bottom: 50px; color: #999}
.content .hd{background: #f1f1f1; text-align: center; line-height: 30px;}
.content .bd{padding: 10px 0}

.goodsAction{position: fixed; width: 100%; height:46px; left: 0; bottom: 0; background: #fff; display: flex; border-top: 1px #f1f1f1 solid}
.goodsAction .cartInfo{height: 44px; line-height: 44px;flex:1;-webkit-box-flex: 1;text-align: left; padding-left: 10px}
.goodsAction .cartInfo .cart{width: 50px; height: 50px; float: left; position: relative; background: #f24378; border-radius: 50%; margin-top: -10px}
.goodsAction .cartInfo .cart i{font-size: 24px; display: block; width: 50px; height: 50px; position: absolute; left: 0; top: 0; color: #fff; text-align: center; line-height: 50px}
.goodsAction .cartInfo .cart em{font-style: normal; border-radius: 50%; width: 16px; height: 16px; background: #fff; display: block; line-height: 16px;font-size: 12px; text-align: center; position: absolute; color: #f24378; right: 8px; top: 5px}
.goodsAction .cartInfo em.none{background: #ccc;}
.goodsAction .btn{flex: 1; background-color: #15a093; color: #fff; line-height: 46px; text-align: center}
.goodsAction .btnBuy{flex: 1; background-color: #05c1af; color: #fff; line-height: 46px; text-align: center}
</style>

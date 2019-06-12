<template>
    <div class="wrap">
        <div class="header">
            <div class="left">
                <van-icon name="arrow-left" @click="onClickLeft"/>
            </div>
            <div class="center">回国礼品店</div>
            <div class="right">
                <span><van-icon name="share" @click="onClickShare"/></span>
                <span><van-icon name="cart-o" @click="onClickCart"/><div class="dot" v-if="cartNumber>0">{{cartNumber}}</div></span>
            </div>
        </div>

        <div class="topSearch">
            
            <div class="search" @click="onClickSearch('')">   
                <van-icon name="search" />
                <span>商品名称</span>     
            </div>
            
            <div class="cateBtn" @click="onClickCate">分类</div>
        </div>

        <div class="hotKey">
            热门
            <span v-for="vo in hotkey" :key="vo" @click="onClickSearch(vo)">{{vo}}</span>
        </div>

        <div style="height:126px"></div>

        <van-notice-bar
        color="#05C1AF"
        background="#e6fffc"
        :text="notice"
        left-icon="volume-o"
        />
    
        <van-swipe :autoplay="3000" indicator-color="white">
			<van-swipe-item v-for="vo in ad" :key="vo.name"><div class="banner"><img :src="vo.image" @click="goLink(vo)"/></div></van-swipe-item>
		</van-swipe>

        <template v-for="(vo,index) in goods">
        <div class="title" :key="vo.path">
            <p>{{vo.name}}</p>
            <span>更多</span>
        </div>
        <div class="product" v-for="(f,idx) in vo.goods" :key="f.id">
            <div class="img"><img :src="f.picname" @click="goDetail(f)"></div>
            <div class="info">
                <h1 @click="goDetail(f)">{{f.name}}</h1>
                <h2 @click="goDetail(f)">{{f.say}}</h2>
                <div class="price">
                    <p>${{f.price}}</p>
                    <div class="numberAction">
                        <div class="set" @click="onClickNumber(index,idx,'dec')">-</div>
                        <div class="buyNumber">{{f.num}}</div>
                        <div class="set" @click="onClickNumber(index,idx,'inc')">+</div>
                    </div>
                </div>
            </div>
        </div>
        </template>
    </div>
</template>

<script>
import user from '../chat/auth'
import { ImagePreview } from 'vant';
export default {
    data() {
        return {
            ad : [],
            notice : '',
            hotkey : '',
            goods:[],
            cartNumber : 0
        };
    },
    watch: {
        $route(to) {
            if (to.name == "store") {                
                this.init();
            }
        }
    },
    created() {        
       this.init();
    },
    methods: {
        onClickLeft(){

        },
        onClickShare(){

        },
        onClickSearch(keyword){
            if(keyword!=''){
                this.$router.push({path:'/store/search',query:{keyword:keyword,token:user.token,agentid:user.agentid}});
            }else{
                this.$router.push({path:'/store/search',query:{token:user.token,agentid:user.agentid}});
            }            
        },
        onClickCart(){
            this.$router.push({path:'/store/cart',query:{token:user.token,agentid:user.agentid}});
        },
        onClickCate(){
            this.$router.push({path:'/store/cate',query:{token:user.token,agentid:user.agentid}});
        },
        goDetail(item){
            this.$router.push({name:'storeDetail', params:{ id: item.goodsID,specid:item.id },query:{token:user.token,agentid:user.agentid}});
        },
        init(){
            var that = this;
            that.ad = [];
            that.keyword = [],
            that.goods = [];
            that.cartNumber = 0;
            that.getCartNumber();

            var data = {
                token:user.token,
                agentid:user.agentid
            };
            that.$http.post("/V1/store/getMain",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.ad = res.body.ad;
                    that.notice = res.body.notice;
                    that.hotkey = res.body.hotkey;
                    that.goods = res.body.goods;
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }               
            });       
        },
        onClickNumber(index,idx,type){
            if(type=='inc'){
                this.goods[index]['goods'][idx]['num']++;
            }else{
                if(this.goods[index]['goods'][idx]['num']==0){
                    return false;
                }
                this.goods[index]['goods'][idx]['num']--;
            }
            this.setCartNumber(this.goods[index]['goods'][idx],type);
        },
        setCartNumber(info,type){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                act:type,
                goodsID : info.goodsID,
                typeID : info.typeID,
                specid : info.id, 
                number : 1,
            };
            that.$http.post("/v1/store/cartAdd",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    this.getCartNumber();
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
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
.header{height: 46px; width: 100%; position: fixed;top: 0; left: 0; background: #05c1af; color: #fff; padding: 0 10px; box-sizing: border-box; z-index: 999;}
.left{float: left; line-height: 46px;}
.center{position:absolute; width: 100%; text-align: center; line-height: 46px; left: 0; top: 0;}
.right{float: right; padding-top: 12px}
.right span{ padding:0 10px; font-size: 20px; position: relative;}
.right span .dot{position: absolute;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; text-align: center}

.topSearch{height: 40px; width: 100%; line-height: 40px; background: #fff; position: fixed; top: 46px; left: 0; z-index: 999; display: flex; overflow: hidden; font-size: 14px;}
.topSearch .search{flex:1; text-align: left; padding-left: 10px; color: #eee}
.topSearch .search a{color: #eee; display: block; height: 100%}
.topSearch .search i{display: block; float: left; line-height: 40px; font-size:18px; margin-right: 10px}
.topSearch .search span{display: block; float: left;}
.topSearch .cateBtn{color: #fff; display: block; height: 30px; line-height: 30px;background: #05C1AF; color: #fff; margin-top: 5px; border-radius: 5px; width: 40px; text-align: center; margin-right: 5px;;}
.hotKey{position: fixed; top: 86px; left: 0; width: 100%; background: #f7f7f7; height: 40px; line-height: 40px; color: #999; padding-left: 10px; box-sizing: border-box; font-size: 14px;z-index: 999;}
.hotKey span{color: #333; padding-left: 10px}
.title{background: #fff; padding: 10px; clear: both; overflow: hidden;}
.title p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px}
.title span{float: right; font-size: 14px; color: #999}

.van-card__price{line-height: 30px; font-size: 16px;}

.product{clear: both; overflow: hidden; background: #fff; display: flex; padding: 10px; border-bottom: 1px #f1f1f1 double}
.product .img{float: left; width: 100px; margin-right: 10px}
.product .info{flex: 1; font-size: 14px}
.product .info h1{font-size: 14px; margin-bottom: 5px}
.product .info h2{font-weight: normal; font-size: 12px; color: #999; margin-bottom: 5px}
.product .info .price{clear: both; overflow: hidden;}
.product .info .price p{float: left; color: #f00; line-height: 30px; font-weight: bold}
.numberAction{float: right;}
.numberAction div{display: block; float: left; min-width: 24px; height: 24px; line-height:24px ;text-align: center; border: 1px #dbdbdb solid; margin-left: 5px; font-size: 12px; cursor: pointer;}
</style>

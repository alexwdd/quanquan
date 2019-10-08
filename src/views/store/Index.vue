<template>
    <div class="wrap">
        <div class="header">
            <div class="left" @click="onClickLeft">
                <van-icon name="arrow-left"/>
            </div>
            <div class="center" v-text="shopName"></div>
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
        class="notice"
        color="#FFF"
        :text="notice"
        left-icon="volume-o"
        />

        <van-swipe :autoplay="3000" indicator-color="white">
            <van-swipe-item v-for="vo in banner" :key="vo.id"><div class="banner"><img :src="vo.image" @click="goLink(vo)"/></div></van-swipe-item>            
        </van-swipe>

        <div class="quick">
            <li v-for="vo in quick" :key="vo.id"><img :src="vo.image" @click="goLink(vo)"/></li>  
        </div>

        <div class="ad">
            <li v-for="vo in ad" :key="vo.id"><img :src="vo.image" @click="goLink(vo)"/></li>
        </div>
         
        <template v-for="(vo,index) in goods">
        <div class="title" :key="vo.path">
            <p>{{vo.name}}</p>
            <span @click="onClickMore(vo)">更多</span>
        </div>
        <div class="product" v-for="(f,idx) in vo.goods">
            <div class="img">
                <img v-lazy="f.picname" @click="goDetail(f)">
                <div class="tag" v-if="f.tag>0"><img :src="f.tagImg"/></div>
            </div>
           
            <div class="info">
                <h1 @click="goDetail(f)">{{f.name}}</h1>
                <h2 @click="goDetail(f)">{{f.say}}</h2>
                <div class="price">
                    <p>
                        <span class="m">${{f.price}} AUD</span>
                        <span>约￥{{f.rmb}}</span>
                    </p>
                    <template v-if="f.empty==0">
                    <dir class="cartIcon" v-show="f.cartShow"><van-icon name="cart-o" @click="onClickIcon(index,idx)"/></dir>
                    <div class="numberAction" v-show="!f.cartShow">
                        <div class="set" @click="onClickNumber(index,idx,'dec')">-</div>
                        <div class="buyNumber">{{f.num}}</div>
                        <div class="set" @click="onClickNumber(index,idx,'inc')">+</div>
                    </div>
                    </template>
                </div>
            </div>
        </div>
        </template>
    </div>
</template>

<script>
import user from '../chat/auth'

import Vue from 'vue';
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:'../static/image/default_320.jpg'
});

export default {
    data() {
        return {
            shopName:'',
            banner : [],
            quick:[],
            ad:[],
            notice : '',
            hotkey : '',
            goods:[],
            cartNumber : 0,
            shareUrl : ''
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
            window.location.href = 'app://goback';
        },
        goLink(value){
            if(value.url!=''){
                window.location.href = value.url+"&token="+user.token;
            }else{
                if(value.goodsId>0){
                    this.$router.push({name:'storeDetail', params:{ id: value.goodsId,specid:item.id },query:{token:user.token,agentid:user.agentid}});
                }
            }
        },
        onClickShare(){
            window.location.href = 'app://shareURL?url=http://wx.worldmedia.top/adelaide/store?agent='+user.agentid;
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
        onClickMore(info){
            this.$router.push({path:'/store/cateGoods',query:{cid:info.id,token:user.token,agentid:user.agentid}});
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
                    that.shopName = res.body.shopName;
                    that.banner = res.body.banner;
                    that.quick = res.body.quick;
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
        onClickIcon(index,idx){
            for (let i = 0; i < this.goods.length; i++) {
                for (let j = 0; j < this.goods[i]['goods'].length; j++) {
                    this.goods[i]['goods'][j]['cartShow'] = true;
                }
            }
            this.goods[index]['goods'][idx]['cartShow'] = false;
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
.left{float: left; line-height: 46px; z-index: 10;}
.center{position:absolute; width:80%; text-align: center; line-height: 46px; left: 10%; top: 0; z-index: 0;}
.right{float: right; padding-top: 12px}
.right span{ padding:0 10px; font-size: 20px; position: relative;}
.right span .dot{position: absolute;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; text-align: center}

.bannerBox{position: relative;}
.notice{position:fixed; top:126px; left: 0; width: 100%; z-index: 999; background: rgba(0, 0, 0, 0.5); box-sizing: border-box; height: auto;}

.quick{clear: both; overflow: hidden; background: #fff; margin-bottom: 1px}
.quick li{float: left; width: 20%; text-align: center}
.quick li img{display: block; width: 70%; margin: auto; padding: 10px 0;}

.ad{clear: both; overflow: hidden; padding-left: 10px;background: #fff;}
.ad li{float: left; width: 50%; margin-bottom: 10px; height: 100px;padding-right: 10px; box-sizing: border-box}
.ad li:first-child{height: 210px;}
.ad li img{ width: 100%; height: 100%; display: block}
.topSearch{height: 40px; width: 100%; line-height: 40px; background: #fff; position: fixed; top: 46px; left: 0; z-index: 999; display: flex; overflow: hidden; font-size: 14px;}
.topSearch .search{flex:1; text-align: left; padding-left: 10px; color: #666}
.topSearch .search a{color: #eee; display: block; height: 100%}
.topSearch .search i{display: block; float: left; line-height: 40px; font-size:18px; margin-right: 10px}
.topSearch .search span{display: block; float: left;}
.topSearch .cateBtn{color: #fff; display: block; height: 30px; line-height: 30px;background: #05C1AF; color: #fff; margin-top: 5px; border-radius: 5px; width: 40px; text-align: center; margin-right: 5px;;}
.hotKey{position: fixed; top: 86px; left: 0; width: 100%; background: #f7f7f7; height: 40px; line-height: 40px; color: #05C1AF; padding-left: 10px; box-sizing: border-box; font-size: 14px;z-index: 999;}
.hotKey span{color: #333; padding:3px 5px; background: #fff; border:1px #dbdbdb solid; margin-right: 5px; border-radius: 3px}
.title{background: #fff; padding: 10px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid;}
.title p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold; color: #05C1AF; }
.title span{float: right; font-size: 12px; color: #999;}

.van-card__price{line-height: 30px; font-size: 16px;}

.product{clear: both; overflow: hidden; background: #fff; display: flex; padding: 10px; border-bottom: 1px #f1f1f1 double}
.product .img{float: left; width: 100px; margin-right: 10px; position: relative;}
.product .img img{display: block;}
.product .img .tag{position: absolute; left: 0; top: 0; width:60%;
transform:rotate(-25deg);
-ms-transform:rotate(-25deg); 	/* IE 9 */
-moz-transform:rotate(-25deg); 	/* Firefox */
-webkit-transform:rotate(-25deg); /* Safari 和 Chrome */
-o-transform:rotate(-25deg); 	/* Opera */}
.product .info{flex: 1; font-size: 14px}
.product .info h1{font-size: 14px; margin-bottom: 5px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.product .info h2{font-weight: normal; font-size: 12px; color: #999; margin-bottom: 5px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 1;-webkit-box-orient: vertical;}
.product .info .price{clear: both; overflow: hidden;}
.product .info .price p{float: left}
.product .info .price p span{color: #999; display: block; font-size: 12px}
.product .info .price p span.m{color: #f00;font-weight: bold; font-size: 14px}
.product .cartIcon{ float: right;}
.product .cartIcon i{background: rgb(247, 65, 125); width: 26px; height: 26px; text-align: center; line-height: 26px; color: #fff; border-radius: 50%}
.numberAction{float: right;}
.numberAction div{display: block; float: left; min-width: 24px; height: 24px; line-height:24px ;text-align: center; border: 1px #dbdbdb solid; margin-left: 5px; font-size: 12px; cursor: pointer;}
</style>

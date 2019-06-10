<template>
    <div class="wrap">
        <div class="header">
            <div class="left">
                <van-icon name="arrow-left" @click="onClickLeft"/>
            </div>
            <div class="center">回国礼品店</div>
            <div class="right">
                <span><van-icon name="share" @click="onClickShare"/></span>
                <span><van-icon name="cart-o" @click="onClickCart"/><div class="dot" v-if="commentNumber>0">{{commentNumber}}</div></span>
            </div>
        </div>

        <div class="topSearch">
            <div class="search">        
                <div class="indexIpt" style="padding-left: 10px; color: #999">商品名称</div>
            </div>
            <div class="act" onclick="window.location.href='#'"><van-icon name="search" /></div>
            <div class="act cateBtn"><a href="#">分类</a></div>
        </div>

        <div class="hotKey">
            热门
            <span>贝拉米</span>
            <span>贝拉米</span>
            <span>贝拉米</span>
            <span>贝拉米</span>
        </div>

        <div style="height:126px"></div>

        <van-notice-bar
        color="#05C1AF"
        background="#e6fffc"
        text="通知内容通知内容通知内容通知内容通知内容通知内容通知内容通知内容"
        left-icon="volume-o"
        />
        <div class="banner"></div>
        <div class="title">
            <p>特价商品</p>
            <span>更多</span>
        </div>
        <van-card
            price="2.00"
            tag="包邮"
            currency="$"
            desc="本产品可以防止胶原和弹性蛋白的分解；刺激胶原蛋白的合成，并"  
            title="Anthogenol 月光宝盒 高浓度花青素葡萄籽精华 100粒"
            :thumb="'https://img.51go.com.au/img/200/0001856_bio-e-cherry-juice-500ml.jpeg'"
            onClick="detail"
        >
        <div slot="num">
            <van-stepper v-model="value" style="font-size:12px"/>
        </div>
        </van-card>
        <div class="product">
            <div class="img"><img src="https://img.51go.com.au/img/200/0000019_anthogenol-100-capsules.png"></div>
            <div class="info">
                <h1>Anthogenol 月光宝盒 高浓度花青素葡萄籽精华 100粒</h1>
                <h2>本产品可以防止胶原和弹性蛋白的分解；刺激胶原蛋白的合成，并</h2>
                <div class="price">
                    <p>$15.7</p>
                    <span><van-stepper v-model="value"/></span>
                </div>
            </div>
        </div>
        <div class="product">
            <div class="img"><img src="https://img.51go.com.au/img/200/0000019_anthogenol-100-capsules.png"></div>
            <div class="info">
                <h1>Anthogenol 月光宝盒 高浓度花青素葡萄籽精华 100粒</h1>
                <h2>本产品可以防止胶原和弹性蛋白的分解；刺激胶原蛋白的合成，并</h2>
                <div class="price">
                    <p>$15.7</p>
                    <span><van-icon name="cart-o"/></span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import user from '../chat/auth'
import { ImagePreview } from 'vant';
export default {
    data() {
        return {
            commentNumber : 1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "chat") {
              
            }
        }
    },
    created() {        
       
    },
    methods: {
        onClickLeft(){

        },
        onClickShare(){

        },
        onClickCart(){
            this.$router.push({path:'/store/cart',query:{token:user.token}});
        },
        detail(item){
            this.$router.push({name:'storeDetail', params:{ id: item.id },query:{token:user.token}});
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
.topSearch .search{flex:1;}
.topSearch .search input{border: 0; margin: 0;}
.topSearch .act{display: block; width: 44px; height: 40px; line-height: 40px; text-align: center;}
.topSearch .act a{color: #666}
.topSearch .cateBtn{margin-right: 5px;}
.topSearch .cateBtn a{color: #fff; display: block; height: 30px; line-height: 30px;background: #05C1AF; color: #fff; margin-top: 5px; border-radius: 5px;}
.hotKey{position: fixed; top: 86px; left: 0; width: 100%; background: #f7f7f7; height: 40px; line-height: 40px; color: #999; padding-left: 10px; box-sizing: border-box; font-size: 14px;z-index: 999;}
.hotKey span{color: #333; padding-left: 10px}
.banner{height: 200px;background: #000}
.title{background: #fff; padding: 10px; clear: both; overflow: hidden;}
.title p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px}
.title span{float: right; font-size: 14px; color: #999}

.van-card__price{line-height: 30px; font-size: 16px;}

.product{clear: both; overflow: hidden; background: #fff; display: flex; padding: 10px; border-bottom: 1px #f1f1f1 double}
.product .img{float: left; width: 100px; margin-right: 10px}
.product .info{flex: 1; font-size: 14px}
.product .info h1{font-weight: normal; font-size: 16px; margin-bottom: 5px}
.product .info h2{font-weight: normal; font-size: 14px; color: #999; margin-bottom: 5px}
.product .info .price{clear: both; overflow: hidden;}
.product .info .price p{float: left; color: #f00}
.product .info .price span{float: right; font-size: 20px}
</style>

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

        <div style="height:2000px;">1</div>
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
        
    }
};
</script>
<style scoped>
.header{height: 46px; width: 100%; position: fixed;top: 0; left: 0; background: #05c1af; color: #fff; padding: 0 10px; box-sizing: border-box}
.left{float: left; line-height: 46px;}
.center{position:absolute; width: 100%; text-align: center; line-height: 46px; left: 0; top: 0;}
.right{float: right; padding-top: 12px}
.right span{ padding:0 10px; font-size: 20px; position: relative;}
.right span .dot{position: absolute;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; text-align: center}

.topSearch{height: 40px; width: 100%; line-height: 40px; background: #fff; position: fixed; top: 44px; left: 0; z-index: 999; display: flex; border-bottom: 1px #dbdbdb solid; overflow: hidden; font-size: 14px;}
.topSearch .search{flex:1;}
.topSearch .search input{border: 0; margin: 0;}
.topSearch .act{display: block; width: 44px; height: 40px; line-height: 40px; text-align: center;}
.topSearch .act a{color: #666}
.topSearch .cateBtn{margin-right: 5px;}
.topSearch .cateBtn a{color: #fff; display: block; height: 30px; line-height: 30px;background: #05C1AF; color: #fff; margin-top: 5px; border-radius: 5px;}
</style>

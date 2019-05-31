<template>
    <div class="wrap">
        <van-nav-bar title="收货地址" left-arrow @click-left="onClickLeft" right-text="+新增" @click-right="onClickAdd"/>


    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return { 
        };
    },
    watch: {
        $route(to) {
            if (to.name == "job") {
            }
        }
    },
    created() {},
    methods: {
        onClickLeft() {
            window.location.href = 'app://goback'
        },
        onClickAdd(){
            this.$router.push({path:'/store/addressAdd'});
            this.$router.push({path:'/store/addressAdd',query:{token:user.token}});
        },
        onClickEdit(item){
            this.$router.push({name:'addressEdit', params: { id: item.id }});
        },      
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.topCate{position: fixed; top: 46px; width: 100%;}
.news{clear: both; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed;background:#fff}
.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .address{ overflow:hidden;  text-overflow:ellipsis; white-space:nowrap; width: 100%; font-size: 14px;color: #999}
.news .info .bottom .price{float: left; font-size: 14px;color: #05c1af}
.news .info .bottom .date{font-size: 12px; text-align: right; color: #999; line-height: 20px; float: right;}
.news .info i{color: #05c1af}
</style>

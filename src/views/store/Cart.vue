<template>
    <div class="wrap">
        <van-nav-bar title="购物车" left-arrow @click-left="onClickLeft" right-text="清空" @click-right="onClickClear"/>
        
        <div class="product">
            <div class="img"><img src="https://img.51go.com.au/img/200/0000019_anthogenol-100-capsules.png"></div>
            <div class="info">
                <h1>Anthogenol 月光宝盒 高浓度花青素葡萄籽精华 100粒</h1>
                <div class="price">$15.7</div>
                <div class="action">
                    <p><van-stepper v-model="value"/></p>
                    <span><van-icon name="delete"/></span>                
                </div>
            </div>            
        </div>
        <div class="product">
            <div class="img"><img src="https://img.51go.com.au/img/200/0000019_anthogenol-100-capsules.png"></div>
            <div class="info">
                <h1>Anthogenol 月光宝盒 高浓度花青素葡萄籽精华 100粒</h1>
                <div class="price">$15.7</div>
                <div class="action">
                    <p><van-stepper v-model="value"/></p>
                    <span><van-icon name="delete"/></span>                
                </div>
            </div>            
        </div>

        <div class="title">
            <p>选择快递公司</p>
        </div>

        <van-submit-bar
        :price="3050"
        currency="$"
        button-text="去结算"
        @submit="onSubmit"
        />
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            info:[]
        };
    },
    watch: {
        $route(to) {
            if (to.name == "address") {
                this.init();
            }
        }
    },
    created() {
        this.init();
    },
    methods: {
        onClickLeft() {
            window.location.href = 'app://goback'
        },
        onClickClear(){
            
        },
        onClickEdit(item){
            this.$router.push({name:'storeAddressEdit', params:{ id: item.id },query:{token:user.token}});
        }, 
        init(){
            var that = this;
            var data = {token:user.token};
            that.$http.post("/V1/store/address",data).then(result => {
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
        doDel(info,index){//删除
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:info.id
                };                
                that.$http.post("/V1/store/addressDel",data).then(result => {
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
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}

.title{background: #fff; padding: 10px; clear: both; overflow: hidden;}
.title p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px}
.title span{float: right; font-size: 14px; color: #999}

.product{clear: both; overflow: hidden; background: #fff; display: flex; padding: 10px; border-bottom: 1px #f1f1f1 double}
.product .img{float: left; width: 100px; margin-right: 10px}
.product .info{flex: 1; font-size: 14px}
.product .info h1{font-size: 14px; margin-bottom: 5px}
.product .info h2{font-weight: normal; font-size: 14px; color: #999; margin-bottom: 5px}
.product .info .price{clear: both; overflow: hidden; color: #f00; margin-bottom: 10px;}
.product .info .action{clear: both; overflow: hidden;}
.product .info .action p{float: left;}
.product .info .action span{float: right; font-size: 20px; line-height: 30px}
</style>

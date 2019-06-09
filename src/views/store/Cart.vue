<template>
    <div class="wrap">
        <van-nav-bar title="购物车" left-arrow @click-left="onClickLeft" right-text="清空" @click-right="onClickClear"/>
        
        <div class="product" v-for="vo in info" :key="vo.id">
            <div class="img"><img :src="vo.goods.picname"></div>
            <div class="info">
                <h1><template v-if="vo.goods.wuliu!=''">【{{vo.goods.wuliu}}】</template>{{vo.goods.name}}{{vo.extends}}</h1>
                <div class="price">${{vo.goods.price}}<span>{{vo.goods.weight}}kg</span></div>
                <div class="serverLi" v-for="s in vo.server" :key="s.name">
                {{s.name}} ${{s.price}}/件，数量{{vo.goodsNumber * vo.number}}，合计${{s.price * vo.goodsNumber * vo.number}}
                </div>
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
        :price="heji.total"
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
            info:[],
            heji:[],
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
            this.$router.go(-1);
        },
        onClickClear(){
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    agentid:user.agentid
                };                
                that.$http.post("/V1/store/cartClear",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.info=[];
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        onClickEdit(item){
            this.$router.push({name:'storeAddressEdit', params:{ id: item.id },query:{token:user.token}});
        }, 
        init(){
            var that = this;
            var data = {token:user.token,agentid:user.agentid};
            that.$http.post("/V1/store/cart",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body.goods;
                    that.heji = res.body.heji;
                    that.heji.total = that.heji.total*100;
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
                    agentid:user.agentid,
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
.product .info .price span{color: #999; padding-left: 10px}
.product .info .action{clear: both; overflow: hidden;}
.product .info .action p{float: left;}
.product .info .action span{float: right; font-size: 20px; line-height: 30px}
.serverLi{font-size: 12px; border: 1px #dbdbdb solid; padding: 5px; margin-bottom: 5px; background: #f7f7f7; color: #999}
</style>

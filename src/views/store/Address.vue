<template>
    <div class="wrap">
        <van-nav-bar title="收货地址" left-arrow @click-left="onClickLeft" right-text="+新增" @click-right="onClickAdd"/>
        <div class="address" v-for="(vo,index) in info" :key="vo.id">
            <div class="info">
                <p>{{vo.name}} {{vo.mobile}}</p>
                <span>{{vo.province}}{{vo.city}}{{vo.area}}{{vo.address}}</span>
            </div>
            <div class="action">
                <van-icon name="edit" @click="onClickEdit(vo)"/>
                <van-icon name="delete" @click="doDel(vo,index)"/>
            </div>
        </div>
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
        onClickAdd(){
            this.$router.push({path:'/store/addressAdd',query:{token:user.token}});
        },
        onClickEdit(item){
            this.$router.push({name:'storeAddressEdit', params:{ id: item.id },query:{token:user.token}});
        }, 
        init(){
            var that = this;
            var data = {token:user.token};
            that.$http.post("/V1/address/lists",data).then(result => {
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
                that.$http.post("/V1/address/addressDel",data).then(result => {
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
.address{clear: both; overflow: hidden; padding: 10px; background: #fff; display: flex; border-bottom: 1px #f1f1f1 solid}
.address .action{width: 60px; text-align: center}
.address .action i{text-align: right; display: block; line-height: 20px;}
.address .info{font-size: 14px; flex: 1}
.address .info span{color: #999}
</style>

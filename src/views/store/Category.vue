<template>
    <div class="wrap">
        <van-nav-bar>
            <van-icon name="home-o" slot="left" />
            <div class="tab" slot="title">
                <span class="active">按分类</span>
                <span>按品牌</span>
            </div>
            <van-icon name="search" slot="right" />
        </van-nav-bar>

        <div style="height:46px"></div>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">            
            <div class="product" v-for="(f,idx) in info" :key="f.id">
                <div class="img"><img :src="f.picname" @click="goDetail(f)"></div>
                <div class="info">
                    <h1 @click="goDetail(f)">{{f.name}}</h1>
                    <h2 @click="goDetail(f)">{{f.say}}</h2>
                    <div class="price">
                        <p>${{f.price}}</p>
                        <div class="numberAction">
                            <div class="set" @click="onClickNumber(idx,'dec')">-</div>
                            <div class="buyNumber">{{f.num}}</div>
                            <div class="set" @click="onClickNumber(idx,'inc')">+</div>
                        </div>
                    </div>
                </div>
            </div>
        </van-list>        
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            keyword:'',
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeSearch") {
                let keyword = this.$route.query.keyword;
                if(keyword!='' && keyword!=undefined){
                    this.keyword = keyword;
                }else{
                    this.keyword = '';
                    this.info = []
                }
                
            }
        },
        keyword(newVal, oldVal) {
            //普通的watch监听
            if (newVal != "") {
                this.info = [];
                this.page = 1;
                this.loading = true;
                this.finished = false;
                this.canPost = true;
                this.onLoad();
            }
        }
    },
    created() {        
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        goDetail(item){
            this.$router.push({name:'storeDetail', params:{ id: item.goodsID,specid:item.id },query:{token:user.token,agentid:user.agentid}});
        },
        onClickNumber(index,type){
            if(type=='inc'){
                this.info[index]['num']++;
            }else{
                if(this.info[index]['num']==0){
                    return false;
                }
                this.info[index]['num']--;
            }
            this.setCartNumber(this.info[index],type);
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

                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        onLoad() {
            var that = this;
            if(!that.canPost || that.keyword==''){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                agentid : user.agentid,
                keyword : that.keyword,
                page : that.page,
            };
            that.$http.post("v1/store/goods",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);  
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff; font-size: 18px}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.tab span{ padding: 8px 10px; font-size: 14px; border-radius: 4px}
.tab span.active{background: rgba(255, 255, 255, .3)}
</style>

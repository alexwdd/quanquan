<template>
    <div class="wrap">
        <van-nav-bar fixed :title="cate.name" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>

        <template v-if="child.length > 1">
        <div class="topCate">
            <div class="cateTab">
                <van-tabs color="#05c1af" v-model="cateActive" :ellipsis=false>
                    <van-tab v-for="vo in child" :title="vo.name" :key="vo.id">
                        <div class="tab-title" slot="title" @click="changeCate(vo)">{{vo.name}}</div>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="cateBar" @click="show"><van-icon name="bars"></van-icon></div>
        </div>

        <div class="cateList" v-show="cateShow">
            <div class="hd">全部分类 <van-icon name="cross" @click="show"></van-icon></div> 
            <div class="quick">
                <li v-for="vo in child" :key="vo.id" @click="changeCate1(vo)"><p>{{vo.name}}</p></li>
            </div>       
        </div>
        <div style="height:44px"></div>
        </template>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">            
            <div class="product" v-for="(f,idx) in info" :key="f.id">
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
                        <dir class="cartIcon" v-show="f.cartShow"><van-icon name="cart-o" @click="onClickIcon(idx)"/></dir>
                        <div class="numberAction" v-show="!f.cartShow">
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
            cateActive:0,
            cateShow:false,
            cid:'',
            cate:[],
            child:[],
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeGoods") {
                this.info = [];
                this.cid = '';
                this.cateActive = 0;
                this.child = [];
                this.page = 1;
                this.loading = true;
                this.finished = false;
                this.canPost = true;
                this.onLoad();
                this.getCateName();
            }
        }
    },
    created(){
        this.onLoad();
        this.getCateName();
    },
    methods: {
        onClickLeft() {
            this.$router.push({name:'store',query:{token:user.token,agentid:user.agentid}});
        },
        show(){
            this.cateShow = !this.cateShow;
        },
        changeCate(item){
            this.cid = item.id;
            this.info = [];
            this.page = 1;
            this.onLoad();
        },
        changeCate1(value){
            this.cateShow = false;
            this.cateActive = value.index;
            this.cid = value.id;
            this.info = [];
            this.page = 1;
            this.onLoad();
        },
        goDetail(item){
            this.$router.push({name:'storeDetail', params:{ id: item.goodsID,specid:item.id },query:{token:user.token,agentid:user.agentid}});
        },
        onClickIcon(index){
            for (let i = 0; i < this.info.length; i++) {
                this.info[i]['cartShow'] = true;
            }
            this.info[index]['cartShow'] = false;
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
        getCateName(){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,   
                path : that.$route.query.path
            };
            that.$http.post("/v1/store/getCateName",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.cate = res.body.cate;
                    that.child = [{id:'',index:0,name:'全部'}];
                    that.child = that.child.concat(res.body.child);
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
            if(!that.canPost){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                agentid : user.agentid,
                path : that.$route.query.path,
                cid : that.cid,
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
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.search{height: 46px; background: #fff; position: fixed; width: 100%;left: 0; top: 0; display: flex}
.search .ipt{flex: 1; padding:0 10px}
.search .ipt input{height: 30px; border-radius: 15px; padding: 0 10px; margin: 0; border: 0; background: #f1f1f1; width: 100%; box-sizing: border-box; margin-top: 8px; font-size: 14px}
.search .cancel{width: 40px; text-align: center; line-height: 46px; font-size: 14px}

.topCate{position: fixed; width: 100%; display: flex;background: #fff; z-index: 999; top: 46px}
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:46px; width: 100%; z-index: 999; background: #fff}
.cateList .hd{height: 40px; line-height: 40px; text-align: center; position: relative; text-align: left; font-size: 14px; padding-left: 10px;}
.cateList i{position: absolute;right: 5px; top: 13px;color: #05c1af;}
.my-swipe{height: 250px;width: 100vw; border-bottom: 1px #f1f1f1 solid}
.wrap >>> .mint-swipe-indicator.is-active {background: #f00;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; text-align: center;font-size: 12px; line-height: 28px; padding:0 5px; border: 1px #f1f1f1 solid; border-radius: 3px; margin-left: 10px; white-space: normal; margin-bottom: 10px}

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

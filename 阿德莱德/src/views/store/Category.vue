<template>
    <div class="wrap">
        <van-nav-bar fixed>
            <van-icon name="home-o" slot="left" @click="gotoHome"/>
            <div class="tab" slot="title">
                <span :class="{active:cateShow}" @click="onClickTab(1)">按分类</span>
                <span :class="{active:brandShow}" @click="onClickTab(2)">按品牌</span>
            </div>
            <van-icon name="search" slot="right" @click="gotoSearch"/>
        </van-nav-bar>

        <div style="height:46px"></div>

        <div class="cateBox" v-show="cateShow">
            <div class="left">
                <li v-for="(vo,index) in category" :key="vo.id" :class="{'active':activeIndex==index}" @click="onClickBigCate(index)">{{vo.name}}</li>                
            </div>
            <div class="right">
                <div class="category">
                    <li v-for="vo in small" :key="vo.id">
                        <img :src="vo.picname">
                        <p>{{vo.name}}</p>
                    </li>
                </div>
            </div>
        </div>  

        <div class="cateBox" v-show="brandShow">
            <div class="left">
                <li v-for="(vo,index) in brand" :key="vo.id" :class="{'active':brandIndex==index}" @click="onClickBrand(index)">{{vo.name}}</li>
            </div>
            <div class="right">
                <van-list v-model="loading" :finished="finished" finished-text="没有更多了">            
                    <div class="product" v-for="(f,idx) in goods" :key="f.id">
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
        </div>   
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            category:[],
            small:[],            
            activeIndex:0,

            brand:[],
            goods:[],
            brandIndex:0,
            loading: false,
            finished: false,
            canPost:true,
            page:1,

            cateShow:true,
            brandShow:false,
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeCate") {
                this.init();
            }
        }
    },
    created() {
        this.init();
    },
    methods: {
        gotoHome() {
            this.$router.push({name:'store',query:{token:user.token,agentid:user.agentid}});
        },
        gotoSearch() {
            this.$router.push({path:'/store/search',query:{token:user.token,agentid:user.agentid}});
        },
        onClickTab(index){
            if(index==1){
                this.cateShow = true;
                this.brandShow = false;
            }else{
                this.cateShow = false;
                this.brandShow = true;
            }
        },
        goDetail(item){
            this.$router.push({name:'storeDetail', params:{ id: item.goodsID,specid:item.id },query:{token:user.token,agentid:user.agentid}});
        },
        onClickNumber(index,type){
            if(type=='inc'){
                this.goods[index]['num']++;
            }else{
                if(this.goods[index]['num']==0){
                    return false;
                }
                this.goods[index]['num']--;
            }
            this.setCartNumber(this.goods[index],type);
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
        init() {
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                fid:0
            };
            that.$http.post("v1/store/category",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.category = res.body;
                    this.getCate(that.category[that.activeIndex]['id']);
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });

            that.$http.post("v1/store/brand",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.brand = res.body;
                    this.getBrandGoods(that.brand[that.brandIndex]['id']);
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        onClickBigCate(index){
            this.activeIndex = index;
            let fid = this.category[index]['id'];
            this.getCate(fid);
        },
        getCate(fid){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                fid:fid
            };
            that.$http.post("v1/store/category",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.small = res.body;  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        onClickBrand(index){
            this.brandIndex = index;
            let brandID = this.brand[index]['id'];
            this.goods = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.getBrandGoods(brandID);
        },
        getBrandGoods(brandID){
            var that = this;
            if(!that.canPost){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                agentid : user.agentid,
                brandID : brandID,
                page : that.page,
            };
            that.$http.post("v1/store/goods",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.goods = that.goods.concat(res.body.data);  
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

.cateBox{background: #fff; display: flex; position: fixed; width: 100%; top: 46px; left: 0}
.cateBox .left{width:80px;  background: #f7f7f7; height: calc(100vh - 46px); overflow: auto;}
.cateBox .left li{font-size: 14px; padding:10px 5px;}
.cateBox .left li.active{background: #fff; color: #05c1af; border-left: 2px #05c1af solid}
.cateBox .right{flex: 1; height: calc(100vh - 46px); overflow: auto}
.cateBox .right .category{clear: both; overflow: hidden;}
.cateBox .right .category li{float: left; width: 33.333%; text-align: center; font-size: 14px; margin-top: 10px;}
.cateBox .right .category li img{display: block; margin: auto; width: 50px; height: 50px;}

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

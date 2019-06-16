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
                <li v-for="vo in category" :key="vo.id" :class="{'active':params.path==vo.path}" @click="onClickBigCate(vo)">{{vo.name}}</li>                
            </div>
            <div class="right">
                <div class="cateFix" v-if="small!=''">
                    <div class="topCate">
                        <div class="cateTab">              
                            <van-tabs color="#05c1af" v-model="cateActive" :ellipsis=false>
                                <van-tab v-for="vo in small" :key="vo.id">
                                    <div class="tab-title" slot="title" @click="changeCate(vo)">{{vo.name}}</div>
                                </van-tab>
                            </van-tabs>
                        </div>
                        <div class="cateBar" @click="show"><van-icon name="arrow-down"></van-icon></div>
                    </div>
                </div>

                <div class="cateList" v-show="cateTabShow">
                    <div class="hd">全部分类 <van-icon name="arrow-up" @click="show"></van-icon></div>
                    <div class="quick">
                        <li v-for="vo in small" :key="vo.id" @click="changeCate1(vo)"><p>{{vo.name}}</p></li>
                    </div>                                   
                </div>

                <div style="height:50px;clear:both; width:100%" v-if="small!=''"></div>

                <van-list v-model="loading" :finished="finished" finished-text="没有了" @load="getCateGoods">            
                    <div class="product" v-for="(f,idx) in goods" :key="f.id">
                        <div class="img"><img v-lazy="f.picname" @click="goDetail(f)"></div>
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

        <div class="cateBox" v-show="brandShow">
            <div class="left">
                <li v-for="(vo) in brand" :key="vo.id" :class="{'active':params.brandID==vo.id}" @click="onClickBrand(vo)">{{vo.name}}</li>
            </div>
            <div class="right">
                <van-list v-model="loading" :finished="finished" finished-text="没有了" @load="getBrandGoods">            
                    <div class="product" v-for="(f,idx) in goods" :key="f.id">
                        <div class="img"><img v-lazy="f.picname" @click="goDetail(f)"></div>
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
            brand:[],
            goods:[],

            params:{
                fid:0,
                smallID:'',
                brandID:'',
                path:''
            },
  
            loading: false,
            finished: false,
            canPost:true,
            page:1,

            cateShow:true,
            brandShow:false,

            cateActive:0,
            cateTabShow:false
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
        show(){
            this.cateTabShow = !this.cateTabShow;
        },
        onClickTab(index){
            if(index==1){
                this.cateShow = true;
                this.brandShow = false;
                this.goods = [];
                this.page = 1;
                this.loading = true;
                this.finished = false;
                this.canPost = true;
                this.getCateGoods();
            }else{
                this.cateShow = false;
                this.brandShow = true;
                this.goods = [];
                this.page = 1;
                this.loading = true;
                this.finished = false;
                this.canPost = true;
                this.getBrandGoods();
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
            that.small = [];  
            that.brand = [];
            that.goods = []; 

            that.params = {
                fid:0,
                smallID:'',
                brandID:'',
                path:''
            };
         
            that.loading = false;
            that.finished = false;
            that.canPost = true;
            that.page = 1;

            that.cateShow = true;
            that.brandShow = false;

            let data = {
                token : user.token,
                agentid : user.agentid,
                fid:that.params.fid
            };
            that.$http.post("v1/store/category",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.category = res.body;
                    this.params.fid = that.category[0]['id'];
                    this.params.path = that.category[0]['path'];                  
                    this.getCate();
                    //this.getCateGoods();
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });

            that.$http.post("v1/store/brand",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.brand = res.body;
                    that.params.brandID = that.brand[0]['id'];
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        changeCate(item){
            this.params.smallID = item.id;
            this.goods = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.getCateGoods();
        },
        changeCate1(item){
            this.cateTabShow = false;
            this.cateActive = item.index;
            this.params.smallID = item.id;  

            this.goods = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.getCateGoods();
        },
        onClickBigCate(item){
            this.params.path = item.path;    
            this.params.fid = item.id;    
            this.params.smallID = '';    
            this.goods = [];
            this.small = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.cateTabShow = false;
            this.getCate();
            this.getCateGoods();
        },
        getCate(){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                fid:that.params.fid
            };
            that.$http.post("v1/store/category",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.small = [];
                    that.cateActive = 0;
                    if(res.body.length > 0){
                        that.small = [{id:'',index:0,name:'全部'}];
                        that.small = that.small.concat(res.body);
                    }              
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        getCateGoods(){
            var that = this; 
            if(!that.canPost){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                agentid : user.agentid,
                path : that.params.path,
                cid : that.params.smallID,
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
        },
        onClickBrand(item){
            this.params.brandID = item.id;
            this.goods = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.getBrandGoods();
        },
        getBrandGoods(){
            var that = this;
            if(!that.canPost){
                that.loading = false;
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                agentid : user.agentid,
                brandID : that.params.brandID,
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

.cateBox{background: #fff; display: flex; position: fixed; width: 100%; top: 46px; left: 0; z-index: 88;}
.cateBox .left{width:80px;  background: #f7f7f7; height: calc(100vh - 46px); overflow: auto; z-index: 999;}
.cateBox .left li{font-size: 12px; padding:10px 5px;}
.cateBox .left li.active{background: #fff; color: #05c1af; border-left: 2px #05c1af solid}
.cateBox .right{flex: 1; height: calc(100vh - 46px); overflow: auto}

.cateFix{position: fixed; left: 80px; top: 46px; width:calc(100% - 80px);}
.topCate{width: 100%; display: flex; background: #fff; z-index: 999; }
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:46px; width:calc(100% - 80px); z-index: 999; background: #fff}
.cateList .hd{height: 30px; line-height: 30px; text-align: center; position: relative; text-align: left; font-size: 14px; padding-left: 10px;}
.cateList i{position: absolute;right: 5px; top: 8px;color: #05c1af;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; text-align: center;font-size: 12px; line-height: 28px; padding:0 5px; border: 1px #f1f1f1 solid; border-radius: 3px; margin-left: 10px; white-space: normal; margin-bottom: 10px}


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

<template>
    <div class="wrap">
        <van-nav-bar fixed>
            <van-icon name="wap-home-o" slot="left" @click="gotoHome"/>
            <div class="tab" slot="title">
                <span :class="{active:cateShow}" @click="onClickTab(1)">按分类</span>
                <span :class="{active:brandShow}" @click="onClickTab(2)">按品牌</span>
            </div>
            <div slot="right" class="topRight">
                <span><van-icon name="search" @click="gotoSearch"/></span>
                <span><van-icon name="cart-o" @click="onClickCart"/><div class="dot" v-if="cartNumber>0">{{cartNumber}}</div></span>
            </div>            
        </van-nav-bar>

        <div style="height:46px"></div>

        <div class="cateBox" v-show="cateShow">            
            <div class="left">
                <li v-for="vo in category" :key="vo.id" :class="{'active':params.path==vo.path}" @click="onClickBigCate(vo)">{{vo.name}}</li>                
            </div>
            <div class="right" id="right">
                <div class="cateFix" v-if="small.length > 1">
                    <div class="topCate">
                        <div class="cateTab">              
                            <van-tabs color="#05c1af" v-model="cateActive" :ellipsis=false>
                                <van-tab v-for="(vo,index) in small" :key="vo.id">
                                    <div class="tab-title" slot="title" @click="changeCate(vo.id,index)">{{vo.name}}</div>
                                </van-tab>
                            </van-tabs>
                        </div>
                        <div class="cateBar" @click="show"><van-icon name="arrow-down"></van-icon></div>
                    </div>
                </div>

                <div class="cateList" v-show="cateTabShow">
                    <div class="hd">全部分类 <van-icon name="arrow-up" @click="show"></van-icon></div>
                    <div class="quick">
                        <li v-for="(vo,index) in small" :key="vo.id" @click="changeCate(vo.id,index)"><p>{{vo.name}}</p></li>
                    </div>                                   
                </div>

                <div style="height:50px;clear:both; width:100%" v-if="small.length > 1"></div>
                <div class="inner">
                <template v-for="(vo,index) in small">
                    <div v-if="small.length > 1" class="title" :key="vo.id" :id="'c'+vo.id"><p>{{vo.name}}</p></div>   
                    <div class="product" v-for="(f,idx) in vo.goods" :key="f.id">
                        <div class="img">
                            <img v-lazy="f.picname" @click="goDetail(f)">
                            <div class="tag" v-if="f.tag>0"><img :src="f.tagImg"/></div>
                        </div>
                        <div class="info">
                            <h1 @click="goDetail(f)">{{f.name}}</h1>
                            <h2 @click="goDetail(f)">{{f.say}}</h2>

                            <template v-if="f.empty==0">
                            <div class="price">
                                <p>
                                    <span class="m">${{f.price}} AUD</span>
                                    <span>约￥{{f.rmb}}</span>
                                </p>
                                <dir class="cartIcon" v-show="f.cartShow"><van-icon name="cart-o" @click="onClickIcon(index,idx)"/></dir>
                                <div class="numberAction" v-show="!f.cartShow">
                                    <div class="set" @click="onClickNumber(index,idx,'dec')">-</div>
                                    <div class="buyNumber">{{f.num}}</div>
                                    <div class="set" @click="onClickNumber(index,idx,'inc')">+</div>
                                </div>
                            </div>
                            </template>
                        </div>
                    </div>
                </template>
                </div>
            </div>
        </div>  

        <div class="cateBox" v-show="brandShow">
            <div class="left">
                <li v-for="(vo) in brand" :key="vo.id" :class="{'active':params.brandID==vo.id}" @click="onClickBrand(vo)">{{vo.name}}</li>
            </div>
            <div class="right">
                <div class="inner">
                <van-list v-model="loading" :finished="finished" finished-text="没有了" @load="getBrandGoods">            
                    <div class="product" v-for="(f,idx) in goods" :key="f.id">
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

                                <template v-if="f.empty==0">
                                <dir class="cartIcon" v-show="f.cartShow"><van-icon name="cart-o" @click="onClickIcon1(idx)"/></dir>
                                <div class="numberAction" v-show="!f.cartShow">
                                    <div class="set" @click="onClickNumber1(idx,'dec')">-</div>
                                    <div class="buyNumber">{{f.num}}</div>
                                    <div class="set" @click="onClickNumber1(idx,'inc')">+</div>
                                </div>
                                </template>
                            </div>
                        </div>
                    </div>
                </van-list>   
                </div>
            </div>
        </div>   

        <van-popup position="top" v-model="apkShow">
            <div class="alert">
                <img src="../../assets/image/alert.jpg">
            </div>
        </van-popup>
        <van-popup v-model="downShow" class="my-van-popup">
            <div class="down">
                <div class="hd"><img src="../../assets/image/down.png"></div>
                <div class="bd">
                    <li><a :href="config.ANDROIDS"><img src="../../assets/image/googleplay.png"></a></li>
                    <li><a :href="config.IOS"><img src="../../assets/image/appstore.png"></a></li>
                    <li class="long" @click="downApk"><img src="../../assets/image/button.png"></li>
                </div>
            </div>
        </van-popup>
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
            cateTabShow:false,

            cartNumber : 0,

            downShow:false,
            apkShow:false,
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
        onClickCart(){
            if(this.config.isWeiXin()){
                this.downShow = true;
                return false;
            } 
            this.$router.push({path:'/store/cart',query:{token:user.token,agentid:user.agentid}});
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
        downApk(){
            if(this.config.isWeiXin()){
                this.apkShow = true
            }else{
                window.location.href = this.config.DOWNLOAD;
            }
        },
        onClickIcon(index,idx){
            if(this.config.isWeiXin()){
                this.downShow = true;
                return false;
            } 
            for (let i = 0; i < this.small.length; i++) {
                for (let j = 0; j < this.small[i]['goods'].length; j++) {
                    this.small[i]['goods'][j]['cartShow'] = true;
                }
            }
            this.small[index]['goods'][idx]['cartShow'] = false;
        },
        onClickNumber(index,idx,type){
            if(type=='inc'){
                this.small[index]['goods'][idx]['num']++;
            }else{
                if(this.small[index]['goods'][idx]['num']==0){
                    return false;
                }
                this.small[index]['goods'][idx]['num']--;
            }
            this.setCartNumber(this.small[index]['goods'][idx],type);
        },
        onClickIcon1(index){
            for (let i = 0; i < this.goods.length; i++) {
                this.goods[i]['cartShow'] = true;
            }
            this.goods[index]['cartShow'] = false;
        },
        onClickNumber1(index,type){
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
                    this.getCartNumber();
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:res.desc});
                }
            });
        },
        init() {
            var that = this;
            that.small = [];  
            that.brand = [];
            that.goods = []; 
            that.cartNumber = 0;
            that.getCartNumber();

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
        getCartNumber() {  
            var that = this;          
            var data = {
                token:user.token,
                agentid:user.agentid
            };
            that.$http.post("/v1/store/cartNumber",data).then(result => {
                let res = result.data;
                if (res.code == 0) {              
                    that.cartNumber = res.body;
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        changeCate(id,index){
            /* this.params.smallID = item.id;
            this.goods = [];
            this.page = 1;
            this.loading = true;
            this.finished = false;
            this.canPost = true;
            this.getCateGoods(); */
            this.cateActive = index;
            this.cateTabShow = false;
            document.getElementById("c"+id).scrollIntoView();
            document.getElementById("right").scrollTop = document.getElementById("right").scrollTop-90;
            //document.documentElement.scrollTop = document.documentElement.scrollTop-90;
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
        },
        getCate(){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                cid:that.params.fid
            };
            that.$http.post("v1/store/cateGoods",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束      
                    that.small = [];
                    that.cateActive = 0;               
                    that.small = res.body.data;                  
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
.wrap >>> .van-nav-bar .van-icon {color: #fff; font-size:20px}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.tab span{ padding: 8px 10px; font-size: 14px; border-radius: 4px}
.tab span.active{background: rgba(255, 255, 255, .3)}
.topRight >>> .van-nav-bar .van-icon { font-size: 24px;}

.topRight{float: right; padding-top: 12px}
.topRight span{ padding:0 10px; position: relative;}
.topRight span .dot{position: absolute;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; text-align: center}

.cateBox{background: #fff; display: flex; position: fixed; width: 100%; top: 46px; left: 0; z-index: 88;}
.cateBox .left{width:80px;  background: #f7f7f7; height: calc(100vh - 46px); overflow: auto; z-index: 999; overflow-y: scroll;-webkit-overflow-scrolling: touch}
.cateBox .left li{font-size: 14px; padding:10px 5px; text-align: center}
.cateBox .left li.active{background: #fff; color: #05c1af; border-left: 2px #05c1af solid}
.cateBox .right{flex: 1; height: calc(100vh - 46px); overflow: auto}
.inner{overflow-y: scroll;-webkit-overflow-scrolling: touch; height:100vh}
.cateFix{position: fixed; left: 80px; top: 46px; width:calc(100% - 80px);z-index: 999;}
.topCate{width: 100%; display: flex; background: #fff; z-index: 999; }
.cateTab{width:calc(100% - 40px);}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:46px; width:calc(100% - 80px); z-index: 999; background: #fff}
.cateList .hd{height: 30px; line-height: 30px; text-align: center; position: relative; text-align: left; font-size: 14px; padding-left: 10px;}
.cateList i{position: absolute;right: 5px; top: 8px;color: #05c1af;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; text-align: center;font-size: 12px; line-height: 28px; padding:0 5px; border: 1px #f1f1f1 solid; border-radius: 3px; margin-left: 10px; white-space: normal; margin-bottom: 10px}


.product{clear: both; overflow: hidden; background: #fff; display: flex; padding: 10px; border-bottom: 1px #f1f1f1 double}
.product .img{float: left; width: 100px; margin-right: 10px; position: relative;}
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
.product .cartIcon i{background: rgb(247, 65, 125); width: 26px; height: 26px; text-align: center; line-height: 26px; color: #fff; border-radius: 50%;position:static}
.numberAction{float: right;}
.numberAction div{display: block; float: left; min-width: 20px; height: 20px; line-height:20px ;text-align: center; border: 1px #dbdbdb solid; margin-left: 5px; font-size: 12px; cursor: pointer;}

.title{background: #fff; padding: 10px; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid;}
.title p{float: left; border-left: 2px #05c1af solid; padding-left: 10px; font-size: 14px; font-weight: bold; color: #05C1AF; }

.alert{width: 100%;}
.alert img{width: 100%}
.my-van-popup {background-color:transparent; width: 80%;}
.down{clear: both; overflow: hidden;}
.down img{display: block}
.down .hd{clear: both;}
.down .bd{background: #fff; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; padding: 20px; overflow: hidden; padding-right: 0}
.down .bd li{float: left; width: 50%; padding-right: 20px; box-sizing: border-box}
.down .bd li.long{clear: both; width: 100%; margin-top: 10px;}
</style>

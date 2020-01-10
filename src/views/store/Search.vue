<template>
    <div class="wrap">
        <div class="search">
            <div class="ipt">
                <input type="text" v-model="keyword" placeholder="请输入关键词">
            </div>
            <div class="cancel" @click="onClickLeft">取消</div>
        </div>

        <div style="height:46px"></div>

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
            keyword:'',
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1,

            downShow:false,
            apkShow:false,
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
        let keyword = this.$route.query.keyword;  
        if(keyword!='' && keyword!=undefined){
            this.keyword = keyword;
        }else{
            this.keyword = '';
            this.info = []
        }
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
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
        onClickIcon(index){
            if(this.config.isWeiXin()){
                this.downShow = true;
                return false;
            } 
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
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.search{height: 46px; background: #fff; position: fixed; width: 100%;left: 0; top: 0; display: flex; z-index: 999;}
.search .ipt{flex: 1; padding:0 10px}
.search .ipt input{height: 30px; border-radius: 15px; padding: 0 10px; margin: 0; border: 0; background: #f1f1f1; width: 100%; box-sizing: border-box; margin-top: 8px; font-size: 14px}
.search .cancel{width: 40px; text-align: center; line-height: 46px; font-size: 14px}


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
.product .cartIcon i{background: rgb(247, 65, 125); width: 26px; height: 26px; text-align: center; line-height: 26px; color: #fff; border-radius: 50%;position:static}
.numberAction{float: right;}
.numberAction div{display: block; float: left; min-width: 24px; height: 24px; line-height:24px ;text-align: center; border: 1px #dbdbdb solid; margin-left: 5px; font-size: 12px; cursor: pointer;}

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

<template>
    <div class="wrap">
        <van-nav-bar title="购物车" fixed left-arrow @click-left="onClickLeft" right-text="清空" @click-right="onClickClear"/>

        <div style="height:46px"></div>
        
        <template v-if="info.length==0">
        <div class="emptyCart">
            <p>您没有选择任何商品！</p>
            <van-button type="default" class="my-btn" @click="gotoHome">去购买</van-button>
        </div>
        </template>

        <div class="product" v-for="(vo,index) in info" :key="vo.id">
            <div class="img"><img :src="vo.goods.picname"></div>
            <div class="info">
                <h1>{{vo.goods.name}}{{vo.extends}}</h1>
                <div class="price">${{vo.goods.price}}<span>{{vo.goods.weight}}kg</span></div>
                <div class="serverLi" v-for="s in vo.server" :key="s.name">
                {{s.name}} ${{s.price}}/件，数量{{vo.goodsNumber * vo.number}}，合计${{Math.round((s.price * vo.goodsNumber * vo.number) * 100) / 100}}
                </div>
                <div class="action">
                    <div class="numberAction">
                        <div class="set" @click="onClickNumber(index,'dec')">-</div>
                        <div class="buyNumber">{{vo.number}}</div>
                        <div class="set" @click="onClickNumber(index,'inc')">+</div>
                    </div>
                    <span><van-icon name="delete" @click="doDel(vo,index)"/></span>
                </div>
            </div>            
        </div> 

        <template v-if="info.length > 0">
        <div class="title">
            <p>选择快递公司</p>
            <div style="clear:both; font-size:12px; color:#999;padding-left:12px">可在澳邮官网，收件人管理，订单详情上传身份证</div>
        </div>
        <div class="kuaidi">
	        <li :class="{'active':thisWuliu.name==vo.name}" v-for="vo in wuliu" :key="vo.id" @click="onClickWuliu(vo)">{{vo.name}}</li>
	    </div>

	    <div class="kdResult" v-if="kdInfo!=''">
            <div class="kdTotle">共 {{kdInfo.number}} 箱 - ${{kdInfo.totalPrice}}</div>
            <div class="kdBaoguo">
                <li v-if="kdInfo.totalExtend > 0"><div class="goods">偏远地区加收邮费</div><div class="yunfei">${{kdInfo.totalExtend}}</div></li>
                <li v-for="vo in kdInfo.baoguo">
                    <div class="goods">
                        <p v-for="f in vo.goods">{{f.trueNumber}} * {{f.name}}</p>
                    </div>
                    <div class="yunfei">
                        {{vo.kuaidi}} - 约{{vo.totalWuliuWeight}}kg - ${{vo.yunfei}}
                    </div>
                </li>
            </div>
        </div>

        <div style="height:100px"></div>
        <div class="footer" v-show="info.length>0">   
            <div class="info">
                <p>合计：$<i>{{heji.total}}</i></p>
                <span>约：￥{{heji.rmb}}</span>
            </div>
            <div class="btn" @click="onSubmit">去结算</div>
        </div>

        </template>
    </div>
</template>

<script>
import user from '../chat/auth'
export default {
    data() {
        return {
            info:[],
            heji:[],
            wuliu:[],
            thisWuliu:[],
            kdInfo:[]
        };
    },
    watch: {
        $route(to) {
            if (to.name == "storeCart") {
                this.init();
            }
        }
    },
    created() {
        this.init();
    },
    methods: {
        gotoHome(){
            this.$router.push({path:'/store',query:{token:user.token,agentid:user.agentid}});
        },
        onClickLeft() {
            //this.$router.go(-1);
            this.$router.push({path:'/store',query:{token:user.token,agentid:user.agentid}});
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
            that.thisWuliu = [];
            that.kdInfo = [];
            var data = {token:user.token,agentid:user.agentid};
            that.$http.post("/V1/store/cart",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.info = res.body.goods;
                    that.wuliu = res.body.wuliu;
                    that.heji = res.body.heji;          
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });      
        },
        onClickNumber(index,type){    
            this.thisWuliu = [];   
            this.kdInfo = '';     
            if(type=='inc'){
                this.info[index]['number']++;
            }else{
                if(this.info[index]['number']==1){
                    return false;
                }
                this.info[index]['number']--;
            }
            this.setCartNumber(this.info[index]);
        },
        setCartNumber(info){
            var that = this;
            let data = {
                token : user.token,
                agentid : user.agentid,
                cartID : info.id,
                number : info.number,
            }     
            that.$http.post("/v1/store/setCartNumber",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.heji = res.body.heji;             
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
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
                that.$http.post("/V1/store/cartDel",data).then(result => {
                    that.thisWuliu = [];   
                    that.kdInfo = ''; 
                    let res = result.data;
                    if (res.code == 0) {
                        that.info.splice(index, 1);
                        that.heji = res.body.heji;
                        that.heji.total = that.heji.total*100;
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        onClickWuliu(info){
            var that = this;
            if(info.name == this.thisWuliu.name){
                this.thisWuliu = [];
                that.kdInfo = [];
            }else{
                this.thisWuliu = info;
                var data = {
                    token:user.token,
                    agentid:user.agentid,
                    kid:info.id
                };                
                that.$http.post("/V1/store/getYunfei",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.kdInfo = res.body.data;
                        that.heji = res.body.heji;
                        that.kdInfo.number = that.kdInfo.baoguo.length;
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        onSubmit(){
            if(this.thisWuliu==''){
                this.$toast('请选择快递公司');
                return false;
            }
            this.$store.commit('SET_WULIU',this.thisWuliu);
            this.$router.push({name:'storeCreate',query:{token:user.token,agentid:user.agentid}});
        }
    }
};
</script>
<style scoped>
.wrap{min-height: 100vh}
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
.numberAction{float: left;}
.numberAction div{display: block; float: left; min-width: 24px; height: 24px; line-height:24px ;text-align: center; border: 1px #dbdbdb solid; margin-right: 5px; font-size: 12px; cursor: pointer;}
.product .info .action span{float: right; font-size: 20px; line-height: 30px}
.serverLi{font-size: 12px; border: 1px #dbdbdb solid; padding: 5px; margin-bottom: 5px; background: #f7f7f7; color: #999}
.kuaidi{clear: both; overflow: hidden; padding: 10px; background: #fff}
.kuaidi li{float:left; text-align: center; text-align: center; height: 30px;line-height:30px; cursor: pointer; border: 1px #dbdbdb solid; padding:0 10px; font-size: 14px; margin-right: 10px}
.kuaidi li.active{background: #39c4da; color: #fff; border-color:#39c4da}
.emptyCart{ text-align: center; padding: 20px 0; color: #999}
.emptyCart p{margin-bottom: 30px;}
.my-btn{background: #05c1af; color: #fff;}
.kdResult{clear: both; overflow: hidden; background: #fff}
.kdResult .kdTotle{text-align: right; font-size: 16px; height: 40px; line-height: 40px; color: #39c4da;border-bottom: 1px #dbdbdb solid; padding-right: 10px}
.kdResult .kdBaoguo{ clear: both; color: #999}
.kdResult .kdBaoguo li{border-bottom: 1px #dbdbdb solid; clear: both; padding: 10px 0; overflow: hidden;}
.kdResult .kdBaoguo li .goods{ clear: both; padding: 0 5px}
.kdResult .kdBaoguo li .goods p{margin: 0; font-size: 12px;}
.kdResult .kdBaoguo li .yunfei{ clear: both; text-align: right; padding: 0 5px; font-size: 12px; color: #000}

.footer{position: fixed; bottom: 0px; width: 100%; height: 50px; border-top: 1px #f1f1f1 solid; background: #fff}
.footer .info{float: left; padding-left: 15px; padding-top: 5px}
.footer .info p{color: #F2493C; font-size:12px;}
.footer .info p i{font-size: 18px; font-weight: bold; font-style: normal}
.footer .info span{display: block; font-size: 12px; padding-left: 12px}
.footer .btn{float: right; background: #F0454C; font-size: 18px; line-height:50px; width: 100px; height: 50px; color: #fff; text-align: center;}
</style>

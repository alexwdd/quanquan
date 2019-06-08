<template>
    <div class="wrap">
        <van-nav-bar fixed title="红人榜" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>        

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="userList">  
                <li v-for="(vo,idx) in info" :key="vo.id">
                    <div class="num" :class="'n'+idx">{{idx+1}}</div>
                    <div class="face" @click="gotoUser(vo.id)">
                        <i class="icon icon-huangguan" :class="'n'+idx" v-if="idx<3"></i>
                        <img :src="vo.headimg">                        
                    </div>
                    <div class="name">{{vo.nickname}}</div>
                    <div class="focus focused" v-if="vo.focus==true" @click=doFocus(idx,vo)>已关注</div>
                    <div class="focus" v-else="" @click=doFocus(idx,vo)>关注</div>
                </li>
             </div>
        </van-list>        
    </div>
</template>

<script>
import user from './auth'
import { ImagePreview } from 'vant';
export default {
    data() {
        return {
            typeShow:false,
            token:'',            
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "more") {
                this.typeShow=false;
                this.info = [];
                this.page = 1;
                this.onLoad();
            }
        }
    },
    created() {        
        if(user.status==true){
            this.token = user.token;
        }
    },
    methods: {    
        onClickLeft() {
            this.$router.go(-1);
        },
        gotoUser(id){
            this.$router.push({'path':'/chat/user',query:{userid:id,token:this.token}});
        },
        doFocus(index,info){//关注
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    userID:info.id
                };                
                that.$http.post("/V1/chat/focus",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已关注'){
                            that.info[index].focus = true;
                            that.info[index].follow++;
                        }else{
                            that.info[index].focus = false;
                            that.info[index].follow--;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        onLoad() {
            var that = this;
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V1/chat/getUserList",data).then(result => {
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
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #7507c2;}

.userList{background: #fff; clear: both; border-bottom:1px #f1f1f1 solid}
.userList li{clear: both; overflow: hidden; padding: 10px}
.userList li .num{float: left; width: 24px; line-height: 50px; font-size: 14px; text-align: center}
.n0{color: #f30}
.n1{color:rgb(231, 75, 210)}
.n2{color: rgb(0, 153, 255)}
.userList li .face{float: left; margin-right: 10px; position: relative; width: 50px; height:50px;}
.userList li .face i{position: absolute;left: 0; top: 0; z-index: 9;transform:rotate(-25deg);
-ms-transform:rotate(-25deg); 	/* IE 9 */
-moz-transform:rotate(-25deg); 	/* Firefox */
-webkit-transform:rotate(-25deg); /* Safari 和 Chrome */
-o-transform:rotate(-25deg); 	/* Opera */}
.userList li .face img{width:40px; height:40px; border-radius: 5px; display: block; position: absolute; left: 5px; top: 5px; z-index: 0}
.userList li .name{float: left; line-height: 50px; font-size: 14px; max-width: 40%; overflow: hidden; white-space: nowrap}
.userList li .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #7507c2; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.userList li .focused{background-color: #ccc; color: #fff;}
</style>

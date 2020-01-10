<template>
    <div class="wrap">
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="userList">  
                <li v-for="(vo,idx) in info" :key="vo.id">
                    <div class="face" @click="gotoUser(vo.userID)">                        
                        <img :src="vo.headimg">                        
                    </div>
                    <div class="name">{{vo.nickname}}</div>
                    <div class="focus focused" @click=doFocus(idx,vo)>取消关注</div>
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
            token:'',            
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1,
        };
    },
    watch: {
        $route(to) {
            if (to.name == "myFocus") {
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
        gotoUser(id){
            this.$router.push({'path':'/chat/user',query:{userid:id,token:this.token}});
        },        
        doFocus(index,info){//关注
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    userID:info.userID
                };                
                that.$http.post("/V1/chat/focus",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        that.info.splice(index, 1);
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
                page : that.page,
            };
            that.$http.post("V1/account/myFocusUser",data).then(result => {
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
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}

.userList{background: #fff; clear: both; border-bottom:1px #f1f1f1 solid}
.userList li{clear: both; overflow: hidden; padding: 10px}
.userList li .num{float: left; width: 24px; line-height: 50px; font-size: 14px; text-align: center}

.userList li .face{float: left; margin-right: 10px}
.userList li .face img{width: 50px; height: 50px; border-radius: 5px; display: block;}
.userList li .name{float: left; line-height: 50px; font-size: 14px; max-width: 40%; overflow: hidden; white-space: nowrap}
.userList li .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #c00; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.userList li .focused{border: 1px #dbdbdb solid; background: #fff; color: #999; margin-right: 0}
</style>

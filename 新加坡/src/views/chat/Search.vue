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
            <div class="chat" v-for="(vo,idx) in info" :key="vo.id">
                <div class="user">
                    <div class="face"><img :src="vo.face"></div>
                    <div class="name"><p>{{vo.nickname}}</p><span>{{vo.createTime}}</span></div>
                    <div class="focus focused" v-if="vo.focus" @click=doFocus(idx,vo)>已关注</div>
                    <div class="focus" v-else="" @click=doFocus(idx,vo)>关注</div>
                </div>
                <div class="say" :id="'say'+vo.id">[{{vo.tag}}]{{vo.content}}</div>
                <div class="btn" :id="'btn'+vo.id" v-if="vo.content.length>100" @click="openSay(vo.id)">展开</div>
                <template v-if="vo.images!=''">

                <div class="photo single" v-if="vo.num==1">
                    <li v-for="(photo,index) in vo.images" :key="photo" @click="showImagePreview(index,vo)">
                        <img :src="photo" @click="showImagePreview">
                    </li>
                </div>

                <div class="photo" v-else="">
                    <li v-for="(photo,index) in vo.thumb" :key="photo" @click="showImagePreview(index,vo)">
                        <img :src="photo">
                    </li>
                </div>
                </template>
                <div class="action">
                    <li><van-icon class-prefix="icon" name="dianzan"/> {{vo.like}}</li>
                    <li><van-icon class-prefix="icon" name="pinglun1" @click="gotoComment(vo)"/> {{vo.comment}}</li>
                    <li><van-icon class-prefix="icon" name="fenxiang" /></li>
                </div>
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
            /* if (to.name == "chatSearch") {
                this.info = [];
                this.keyword = '';
                this.page = 1;
                this.onLoad();
            } */
        },
        keyword(newVal, oldVal) {
            //普通的watch监听
            if (newVal != "") {
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
        showImagePreview(index, info) {
            var images = info.images;
            const instance = ImagePreview({
                images,
                startPosition: index
            })
        },
        doLike(index,info){//点赞
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    chatID:info.id
                };                
                that.$http.post("/V1/chat/like",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已点赞'){
                            that.info[index].like++;
                        }else{
                            that.info[index].like--;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        doFocus(index,info){//关注
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    userID:info.memberID
                };                
                that.$http.post("/V1/chat/focus",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已关注'){
                            that.info[index].focus = true;
                        }else{
                            that.info[index].focus = false;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        openSay(id){
            if(document.getElementById("btn"+id).innerHTML=='展开'){
                document.getElementById("say"+id).style.maxHeight = "10000px";
                document.getElementById("btn"+id).innerHTML = "收起";
            }else{
                document.getElementById("say"+id).style.maxHeight = "58px";
                document.getElementById("btn"+id).innerHTML = "展开";
            }            
        },
        gotoComment(info){
            this.$router.push({'path':'/comment',query:{id:info.id,token:this.token}});
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
                keyword : that.keyword,
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V1/chat/search",data).then(result => {
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
.wrap >>> .van-nav-bar .van-icon {color: #7507c2;}
.search{height: 46px; background: #fff; position: fixed; width: 100%;left: 0; top: 0; display: flex}
.search .ipt{flex: 1; padding:0 10px}
.search .ipt input{height: 30px; border-radius: 15px; padding: 0 10px; margin: 0; border: 0; background: #f1f1f1; width: 100%; box-sizing: border-box; margin-top: 8px; font-size: 14px}
.search .cancel{width: 40px; text-align: center; line-height: 46px; font-size: 14px}
.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0;}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 50%;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #c00; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.chat .user .focused{background-color: #ccc; color: #fff;}

.chat .say{clear: both; font-size: 14px; margin-bottom: 10px; padding: 0 10px;overflow: hidden;max-height: 58px}
.chat .photo{clear: both; padding-left: 10px}
.chat .photo li{float: left; width: 33.333%; padding-right: 10px; box-sizing: border-box; padding-bottom: 10px}
.chat .photo li img{display: block; width: 100%}
.chat .single li{width: 60%}
.chat .action{clear: both;}
.chat .action li{float: left; width: 33.333%; text-align: center; font-size: 12px; line-height: 20px; color: #999}
.chat .action li i{font-size: 16px; display: inline;}

.btn{text-align: right; font-size: 14px; padding-right: 10px; color: #586a9c; margin-top: -10px; margin-bottom: 10px}
</style>

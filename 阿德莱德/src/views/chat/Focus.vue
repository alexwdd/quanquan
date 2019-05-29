<template>
    <div class="wrap">
        <div class="header">
            <div class="tab">
                <li @click="chat">话题</li>
                <li class="active" v-show="token!=''">关注</li>
                <li v-show="token!=''">CP配</li>
            </div>
            <div class="right">
                <span v-show="token!=''"><van-icon name="photo-o" @click="onClickMy"/><div class="dot" v-if="commentNumber>0">{{commentNumber}}</div></span>
                <span v-show="token!=''"><van-icon name="chat-o" @click="onClickReply"/><div class="dot" v-if="replyNumber>0">{{replyNumber}}</div></span>
                <span><van-icon name="search" @click="onClickSearch"/></span>
            </div>
        </div>
        
        <div style="height:46px"></div>

        <div class="comm">
            <div class="bd">
                <li v-for="(vo,idx) in commend" :key="vo.id">
                    <div class="item" @click=doFocus(idx,vo,1)>
                        <van-icon name="success" class="active" v-if="vo.focus==true"/>
                        <van-icon name="success" v-else=""/>
                        <img :src="vo.headimg">                        
                    </div>
                </li>
            </div>
            <div class="more" @click="more">
                <div class="text">
                    <p>排行榜</p>
                    <span>每日更新</span>
                </div>
                <div class="arrow">
                    <van-icon name="arrow" />
                </div>
            </div>            
        </div>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="chat" v-for="(vo,idx) in info" :key="vo.id">
                <div class="user">
                    <div class="face" @click="gotoUser(vo.memberID)"><img :src="vo.face"></div>
                    <div class="name"><p>{{vo.nickname}}</p><span>{{vo.createTime}}</span></div>
                                 
                    <div class="arrowBtn" @click="onClickAction(vo)" v-show="token!=''"><van-icon name="arrow-down" /></div> 
                </div>
                <div class="say" :id="'say'+vo.id"><span class="tag" v-for="tag in vo.tag" :key="tag.name" :style="'color:'+tag.color">#{{tag.name}}#</span>{{vo.content}}</div>
                <div class="btn" :id="'btn'+vo.id" v-if="vo.content.length>100" @click="openSay(vo.id)">展开</div>

                <template v-if="vo.images!=''">
                <div class="photo single" v-if="vo.num==1">
                    <li v-for="(photo,index) in vo.images" :key="photo.url" @click="showImagePreview(index,vo)">
                        <img :src="photo.url">
                    </li>
                </div>
                <div class="photo" v-else="">
                    <li v-for="(photo,index) in vo.thumb" :key="index" @click="showImagePreview(index,vo)">
                        <img :src="photo">
                    </li>
                </div>
                </template>

                <div class="bottom">
                    <div class="read">{{vo.hit}}阅读</div>
                    <div class="action">
                        <li @click="doLike(idx,vo)"><i class="icon icon-like" :class="{'active':vo.liked=='1'}"></i> {{vo.like}}</li>
                        <li @click="gotoComment(vo)"><i class="icon icon-wechat"></i> {{vo.comment}}</li>
                        <li @click="share(vo)"><i class="icon icon-share"></i> 分享</li>
                    </div>
                </div>
            </div>
        </van-list>   

        <div class="selectType" v-show="typeShow">
            <li @click="onClickRight">图文</li>
            <li>视频</li>
        </div>
        <div class="ball" @click="showType"><van-icon name="plus" /></div>   

        <van-actionsheet
        v-model="actionShow"
        :actions="actions"
        cancel-text="取消"
        @select="onSelect"
        />  
    </div>
</template>

<script>
import user from './auth'
import { ImagePreview } from 'vant';
export default {
    data() {
        return {
            commentNumber:0,//最新留言数
            replyNumber:0,//最新回复数

            typeShow:false,

            commend:[],

            token:'',            
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1,

            //选择器
            local:[],//当前信息
            actionShow: false,
            actions: [
                {name: '关注'},
                {name: '举报'}
            ]
        };
    },
    watch: {
        $route(to) {
            if (to.name == "focus") {
                this.typeShow=false;
                this.info = [];
                this.page = 1;
                this.onLoad();
                this.commendUser();
            }
        }
    },
    created() {        
        if(user.status==true){
            this.token = user.token;
            this.commendUser();
        }
    },
    methods: {
        share(info){
            let url = 'app://shareURL?url='+this.config.DOMAIN+'/chat/comment?id='+info.id+'&title='+info.nickname+'的话题';
            window.location.href = url;
        },
        gotoUser(id){
            this.$router.push({'path':'/chat/user',query:{userid:id,token:this.token}});
        },
        onClickAction(info){
            if(info.focus){
                this.actions[0]['name'] = '取消关注';
            }else{
                this.actions[0]['name'] = '关注';
            }
            this.local = info;
            this.actionShow = true;
        },
        onSelect(item){//举报、关注选择器
            this.actionShow = false;
            if(item.name!='举报'){
                this.doFocus(this.local);
            }else{
                this.$router.push({name:'jubao',params:{id:this.local.id}});
            }
        },
        
        showType(){
            this.typeShow = !this.typeShow;
        },
        onClickRight(){
            this.$router.push({'path':'/chat/write',query:{token:this.token}});
        },
        onClickSearch() {
            this.$router.push({'path':'/chat/search',query:{token:this.token}});
        },
        onClickMy(){
            this.$router.push({'path':'/chat/mychat',query:{token:this.token}});
        },
        onClickReply(){
            this.$router.push({'path':'/chat/reply',query:{token:this.token}});
        },
        chat(){
            this.$router.push({'path':'/chat',query:{token:this.token}});
        },
        more(){
            this.$router.push({'path':'/chat/more',query:{token:this.token}});
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
        commendUser(index,info){//点赞
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token
                };                
                that.$http.post("/V1/chat/getCommendUser",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.commend = res.body;
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        doFocus(index,info,type){//关注
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
                            if(type==1){
                                that.commend[index].focus = true;
                                that.commend[index].follow++;
                            }else{
                                that.info[index].focus = true;
                            }                            
                        }else{
                            if(type==1){
                                that.commend[index].focus = false;
                                that.commend[index].follow--;
                            }else{
                                that.info[index].focus = false;
                            }                            
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
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V1/chat/getFocus",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);
                    that.commentNumber = res.body.commentNumber;
                    that.replyNumber = res.body.replyNumber;
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
.header{height: 46px; width: 100%; position: fixed;top: 0; left: 0; background: #fff}
.tab{float: left; line-height: 46px;}
.tab li{display: inline-block; font-size: 14px; padding:0 10px;}
.tab li.active{color: #05c1af;}

.right{float: right; padding-top: 12px}
.right span{ padding:0 10px; font-size: 20px; position: relative;}
.right span .dot{position: absolute;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; text-align: center}

.ball{background:#191919; color: #fff; width: 50px; height: 50px; text-align: center; position: fixed; right: 5px; bottom: 100px; border-radius: 50%;}
.ball i{font-size:24px;line-height: 50px}
.selectType{width: 50px; position:fixed; right: 5px; bottom: 150px}
.selectType li{width: 50px; height: 50px;line-height: 50px;font-size: 14px; text-align: center; border-radius: 50px; margin-bottom: 10px; background: #191919; color: #fff}

.comm{background: #fff; clear: both; border-bottom:1px #f1f1f1 solid; display: flex}
.comm .bd{clear: both; overflow: hidden; padding: 10px 0; flex: 1}
.comm .bd li{float: left; width: 25%; text-align: center}
.comm .bd li .item{width: 50px; height: 50px; position: relative; margin: auto}
.comm .bd li .item img{width: 50px; height: 50px; border-radius: 5px; display: block;}
.comm .bd li .item i{position: absolute; right: 0; top: 0; width: 14px; height: 14px; background: #999; font-size: 12px; color: #fff; line-height: 14px; border-radius: 4px}
.comm .bd li .item i.active{background:#c00; color: #fff}
.comm .bd li p{font-size: 12px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;text-overflow: ellipsis;-ms-text-overflow: ellipsis;-o-text-overflow: ellipsis;}
.comm .bd li span{font-size: 12px; color: #999; text-align: center}
.comm .more{width: 70px; font-size: 14px; margin-top: 10px}
.comm .more .text{float: left; text-align: center}
.comm .more .text span{font-size: 12px; color: #999}
.comm .more .arrow{font-size: 14px; margin-top: 12px; color: #999}

.chat{background:#fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 5px;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #c00; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.chat .user .focused{background-color: #ccc; color: #fff;}

.chat .user .arrowBtn{float: right; border:1px #dbdbdb solid; width: 22px; height: 22px; border-radius: 50%; text-align: center; margin-top: 10px}
.chat .user .arrowBtn i{color: #999; font-size: 14px; line-height: 22px}

.chat .say{clear: both; font-size: 14px; margin-bottom: 10px; padding: 0 10px;overflow: hidden;max-height: 58px}
.chat .photo{clear: both; padding-left: 10px}
.chat .photo li{float: left; width: 33.333%; padding-right: 10px; box-sizing: border-box; padding-bottom: 10px}
.chat .photo li img{display: block; width: 100%}
.chat .single li{width: 60%}
.chat .bottom{clear: both; overflow: hidden; line-height: 30px;}
.chat .bottom .read{float: left; font-size: 12px; color: #999;padding-left:10px}
.chat .bottom .action{float: right;}
.chat .action li{float: left; text-align: center; font-size: 13px; line-height: 30px; color: #999; padding:0 10px}
.chat .action li i{font-size: 16px; display: inline;}
.chat .action li i.active{color: #05c1af}
.btn{text-align: right; font-size: 14px; padding-right: 10px; color: #586a9c; margin-top: -10px; margin-bottom: 10px}
</style>

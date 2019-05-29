<template>
    <div class="wrap">
        <div class="header">
            <div class="tab">
                <li class="active">话题</li>
                <li @click="focus" v-show="token!=''">关注</li>
                <li v-show="token!=''">CP配</li>
            </div>
            <div class="right">
                <span v-show="token!=''"><van-icon name="photo-o" @click="onClickMy"/><div class="dot" v-if="commentNumber>0">{{commentNumber}}</div></span>
                <span v-show="token!=''"><van-icon name="chat-o" @click="onClickReply"/><div class="dot" v-if="replyNumber>0">{{replyNumber}}</div></span>
                <span><van-icon name="search" @click="onClickSearch"/></span>
            </div>
        </div>

        <div class="topCate">
            <div class="cateTab">
                <van-tabs color="#05c1af" v-model="cateActive">
                    <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                        <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="cateBar" @click="show"><van-icon name="bars"></van-icon></div>
        </div>

        <div class="cateList" v-show="cateShow">
            <div class="hd">全部分类 <van-icon name="cross" @click="show"></van-icon></div>
            <swipe class="my-swipe" :auto="0">
				<swipe-item v-for="vo in quick" :key="vo.id">
                    <div class="quick">
                        <li v-for="f in vo" :key="f.id" @click="changeCate1(f)"><img :src="f.icon"><p>{{f.title}}</p></li>
                    </div>
                </swipe-item>
			</swipe>               
        </div>

        <div style="height:92px"></div>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="chat" v-for="(vo,idx) in info" :key="vo.id">
                <div class="user">      
                    <div class="face" @click="gotoUser(vo.memberID)"><img :src="vo.face"></div>
                    <div class="name"><p>{{vo.nickname}}</p><span>{{vo.createTime}}</span></div>
                    <template v-if="user.id == vo.memberID">
                        <div class="focus focused" @click=doDel(idx,vo)>删除</div>
                    </template>
                    <template v-else="">
                        <div class="arrowBtn" @click="onClickAction(vo)" v-show="token!=''"><van-icon name="arrow-down" /></div>
                        <div class="focus" v-if="!vo.focus" @click=doFocus(vo) v-show="token!=''">关注</div>
                    </template>                    
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
            user:[],
            token:'',
            commentNumber:0,//最新留言数
            replyNumber:0,//最新回复数

            typeShow:false,

            cateShow:true,
            cate:'',
            quick:[],
            cateActive:0,

            info:[],
            loading: false,
            finished: false,
            canPost:true,
            cid:0,
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
            if (to.name == "chat") {
                this.info = [];
                this.cate = '',
                this.quick = [];
                this.cateShow=false;
                this.typeShow=false;
                this.page = 1;
                this.cid = 0;
                this.onLoad();
            }
        }
    },
    created() {        
        if(user.status==true){ 
            this.token = user.token;
            this.getUserInfo();
        }
    },
    methods: {
        getUserInfo(){
            var that = this;
            if(user.status){
                var data = {
                    token:user.token,
                };                
                that.$http.post("/V1/chat/userinfo",data).then(result => {
                    let res = result.data;
                    this.user = res.body;
                });
            }
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
        doDel(index,info){//删除话题
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:info.id
                };                
                that.$http.post("/V1/chat/del",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.info.splice(index, 1);
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        showType(){
            this.typeShow = !this.typeShow;
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        onClickSearch() {
            this.$router.push({'path':'/chat/search',query:{token:this.token}});
        },
        onClickRight(){
            this.$router.push({'path':'/chat/write',query:{token:this.token}});
        },
        onClickMy(){
            this.$router.push({'path':'/chat/mychat',query:{token:this.token}});
        },
        onClickReply(){
            this.$router.push({'path':'/chat/reply',query:{token:this.token}});
        },
        gotoUser(id){
            this.$router.push({'path':'/chat/user',query:{userid:id,token:this.token}});
        },
        show(){
            this.cateShow = !this.cateShow;
        },
        focus(){
            this.$router.push({'path':'/chat/focus',query:{token:this.token}});
        },
        share(info){
            let url = 'app://shareURL?url='+this.config.DOMAIN+'/chat/comment?id='+info.id+'&title='+info.nickname+'的话题';
            window.location.href = url;
        },
        changeCate(sort){
            this.cid = sort;
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
        showImagePreview(index, info) {
            var images = [];
            for(var i=0; i<info.images.length; i++){
                images.push(info.images[i]['url']);
            }
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
                            that.info[index].liked = 1;
                        }else{
                            that.info[index].like--;
                            that.info[index].liked = 0;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        doFocus(info){//关注
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
                        for(var i in that.info){
                            if(that.info[i]['memberID'] == info.memberID ){
                                if(res.desc=='已关注'){
                                    that.info[i].focus = true;
                                }else{
                                    that.info[i].focus = false;
                                }
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
            this.$router.push({'path':'/chat/comment',query:{id:info.id,token:this.token}});
        },
        onLoad() {
            var that = this;
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                cid : that.cid,
                cityID : that.config.CITYID,
                page : that.page,
            };
            if(user.status){
                data.token = user.token
            }
            that.$http.post("V1/chat/getmain",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);  
                    if(that.cate==''){
                        that.cate = [{title:'全部',id:0,checked:true}];
                        that.cate = that.cate.concat(res.body.cate);
                    }
                    that.quick = res.body.quick;
                    that.commentNumber = res.body.commentNumber;
                    that.replyNumber = res.body.replyNumber;
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    },
    mounted:function(){
        this.show();
    },
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


.topCate{position: fixed; top: 45px; width: 100%; display: flex;background: #fff}
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:45px; width: 100%; z-index: 999; background: #fff}
.cateList .hd{height: 44px; line-height: 44px; text-align: center; position: relative; background: #05c1af; color: #fff}
.cateList i{position: absolute;right: 5px; top: 15px}
.my-swipe{height: 250px;width: 100vw; border-bottom: 1px #f1f1f1 solid}
.wrap >>> .mint-swipe-indicator.is-active {background: #f00;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; width:20%; text-align: center;font-size: 12px; padding: 10px 0}
.quick li img{display: block; margin: auto; height: 40px}
.custom-indicator {position: absolute;left: 0px;bottom:10px;width: 100%;height: 20px;text-align: center}
.custom-indicator li{display: inline-block; padding: 0 3px}
.custom-indicator li span{display: block; width: 6px; height: 6px; border-radius:3px; background: #ccc}
.custom-indicator li span.active{background: #f60; width: 14px}

.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 5px;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #05c1af; width: 60px; text-align: center; color: #fff; margin-top: 10px; margin-right: 10px;}
.chat .user .focused{border: 1px #dbdbdb solid; background: #fff; color: #999; margin-right: 0}

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

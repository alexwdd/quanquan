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
            token:'',  
            keyword:'',          
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
            this.getUserInfo();
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
            this.$router.push({'path':'/chat/comment',query:{id:info.id,token:this.token}});
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
.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 5px;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #7507c2; width: 60px; text-align: center; color: #fff; margin-top: 10px; margin-right: 10px;}
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
.chat .action li i.active{color: #7507c2}
.btn{text-align: right; font-size: 14px; padding-right: 10px; color: #586a9c; margin-top: -10px; margin-bottom: 10px}
</style>

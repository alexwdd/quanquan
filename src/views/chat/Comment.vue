<template>
    <div class="wrap">
        <van-nav-bar fixed title="话题详情" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <div class="chat">
            <div class="user">
                <div class="face" @click="gotoUser(info.memberID)"><img :src="info.face"></div>
                <div class="name"><p>{{info.nickname}}</p><span>{{info.createTime}}</span></div>
                
                <template v-if="user.id == info.memberID">
                    <div class="focus focused" @click="doDel">删除</div>
                </template>
                <template v-else="">
                    <div class="arrowBtn" @click="onClickAction" v-show="token!=''"><van-icon name="arrow-down" /></div>
                    <div class="focus" v-if="!info.focus" @click="doFocus" v-show="token!=''">关注</div>
                </template>            
            </div>
            <div class="say"><span class="tag" v-for="tag in info.tag" :key="tag.name" :style="'color:'+tag.color">#{{tag.name}}#</span>{{info.content}}</div>
            <template v-if="info.images!=''">

            <div class="photo single" v-if="info.num==1">
                <li v-for="(photo,index) in info.images" :key="photo" @click="showImagePreview(index)">
                    <img :src="photo">
                </li>
            </div>

            <div class="photo" v-else="">
                <li v-for="(photo,index) in info.thumb" :key="photo" @click="showImagePreview(index)">
                    <img :src="photo">
                </li>
            </div>
            </template>

            <div class="bottom">
                <div class="read">{{info.hit}}阅读</div>
                <div class="action">
                    <li @click="doLike"><i class="icon icon-like" :class="{'active':info.liked=='1'}"></i> {{info.like}}</li>
                    <li @click="showWrite"><i class="icon icon-wechat"></i> {{info.comment}}</li>
                    <li><i class="icon icon-share"></i> 分享</li>
                </div>
            </div>
        </div>

        <div class="feedback">
			<div class="hd">
				<p>大家怎么说</p>
			</div>
			<div class="empty" v-show="empty" @click="showWrite"><p>抢占沙发~</p></div>
            <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="getData">
			<div class="bd" v-for="(vo,index) in comment" :key="index">                
                <li>
                    <div class="face"><img :src="vo.headimg"></div>
                    <div class="desc">
                        <div class="name">{{vo.nickname}}</div>
                        <div class="date">{{vo.createTime}}</div>
                        <div class="say" @click="reply(vo,vo.id)">{{vo.content}}</div>
                    </div>
                </li>  
                <div class="reply" v-for="item in vo.reply" :key="item.id" @click="reply(item,vo.id)">
                    <span>{{item.nickname}}</span> 回复 <span>{{item.toNickname}}</span>：{{item.content}}
                </div>              
			</div>
            </van-list>	
		</div>

        <div style="height:46px"></div>

        <div class="footer" v-show="token!=''">
            <div class="writeBox" @click="showWrite">
                <van-icon name="edit" /> 我来说两句...
            </div>
        </div>

        <van-popup v-model="boxShow" position="bottom">
            <div class="write">
                <div class="ipt">
                    <van-field
                        v-model="formData.content"
                        type="textarea"
                        :placeholder="formData.placeholder"
                        rows="1"
                        autosize
                    />
                </div>
                <div class="sendBtn" @click="saveComment"><span>提交</span></div>       
            </div>            
        </van-popup>

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
    data(){
		return {
            user:[],
            id:'',
            token:'',
            info:{},
            comment:[],
            content:'',
            formData: {
                placeholder: "评论",
                chatID:0,
                toID:0,
                toUserId:0,
                toNickname:'',
                content: ''
            },
            boxShow:false,
            empty:false,
            

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
		}
    },
	watch: {
        $route(to) {
            if (to.name == "comment") {  
                this.page = 1;
                this.comment = [];
                this.empty = false;
                this.init();
                this.getData();
            }
        }
    },
	created(){
        if(user.status==true){ 
            this.token = user.token;
            this.getUserInfo();
        }
        this.page = 1;
        this.comment = [];
        this.init();
	},
    methods: {
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
        onClickAction(){
            if(this.info.focus){
                this.actions[0]['name'] = '取消关注';
            }else{
                this.actions[0]['name'] = '关注';
            }
            this.actionShow = true;
        },
        onSelect(item){//举报、关注选择器
            this.actionShow = false;
            if(item.name!='举报'){
                this.doFocus();
            }else{
                this.$router.push({name:'jubao',params:{id:this.info.id}});
            }
        },
        doDel(){//删除话题
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:this.info.id
                };                
                that.$http.post("/V1/chat/del",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$router.go(-1);
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        showImagePreview(index) {
            var images = [];
            for(var i=0; i<this.info.images.length; i++){
                images.push(this.info.images[i]['url']);
            }
            const instance = ImagePreview({
                images,
                startPosition: index
            })
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        doFocus(){
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    userID:that.info.memberID
                };                
                that.$http.post("/V1/chat/focus",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已关注'){
                            that.info.focus = true;
                        }else{
                            that.info.focus = false;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        doLike(){//点赞
            var that = this;
            if(user.status){
                var data = {
                    cityID:that.config.CITYID,
                    token:user.token,
                    chatID:that.info.id
                };                
                that.$http.post("/V1/chat/like",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        this.$toast(res.desc);
                        if(res.desc=='已点赞'){
                            that.info.like++;
                            that.info.liked = 1;
                        }else{
                            that.info.like--;
                            that.info.liked = 0;
                        }
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        },
        /* doDigg(index,info){
            var that = this;
            if(user.status){
                var data = {
                    token:user.token,
                    commentID:info.id
                };                
                that.$http.post("/V1/chat/digg",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.comment[index].digg++;
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        //that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            }
        }, */
        showWrite(){
            this.formData.placeholder = '评论';
            this.formData.toID = 0;
            this.formData.toUserId = 0;
            this.formData.toNickname = '';
            //that.formData.content = '';
            this.boxShow = true;
        },
        init(){            
            var that = this;
            if(user.status==true){
                that.token = user.token;
            }
            that.id = that.$route.query.id;
			if (that.id>0 && that.id!=''){
                let data = {
                    id : that.id,
                    token:user.token
                };
				that.$http.post("/V1/chat/getinfo",data).then(result => {   
                    let res = result.data;
                    if (res.code == 0) {
                        // 加载状态结束
                        that.info = res.body.data;
                        that.formData.chatID = that.info.id;
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
			}
        },       
        getData() {
            var that = this;
            that.id = that.$route.query.id;
            let data = {
                id : that.id,
                token:user.token,
                page : that.page
            };                
            that.$http.post("/V1/chat/getComment",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束   
                    that.loading = false;
                    that.canPost = true;
                    that.comment = that.comment.concat(res.body.data);                    
                    if (that.comment==0){
                        that.empty = true;
                    }
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        saveComment:function(){
            var that = this;
            if(that.formData.content == ''){
                that.$dialog.alert({title:'错误信息',message:'请输入评论内容'});
                return false;
            }           
            var formData = that.formData; 
            var toID = that.formData.toID;  
            formData.cityID = that.config.CITYID;         
            formData.token = user.token;         
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/V1/chat/comment",formData).then(result => {
                let res = result.data;
                this.$toast.clear();
                if (res.code == 0) {

                    that.formData.placeholder = '评论';
                    that.formData.toID = 0;
                    that.formData.toUserId = 0;
                    that.formData.toNickname = '';
                    that.formData.content = '';

                    that.boxShow = false;
                    that.empty = false;
                    if(toID==0){
                        that.comment = res.body.concat(that.comment);
                    }else{
                        for (let i = 0; i<that.comment.length; i++) {
                            console.log(toID,that.comment[i]['id']);
                            if(toID==that.comment[i]['id']){
                                that.comment[i].reply = that.comment[i].reply.concat(res.body);
                            }                            
                        }                        
                    }                    
                }else if(res.code==999){
                    window.location.href='app://login';  
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        reply:function(info,toID){
            if(this.info.open==0){
                return false;
            }
            var that = this;
            that.formData.placeholder = '回复'+info.nickname;
            that.formData.toID = toID;
            that.formData.toUserId = info.memberID;
            that.formData.toNickname = info.nickname;
            that.formData.content = '';
            that.boxShow = true;
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 50%;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #05c1af; width: 60px; text-align: center; color: #fff; margin-top: 10px; margin-right: 10px;}
.chat .user .focused{border: 1px #dbdbdb solid; background: #fff; color: #999; margin-right: 0}
.chat .user .arrowBtn{float: right; border:1px #dbdbdb solid; width: 22px; height: 22px; border-radius: 50%; text-align: center; margin-top: 10px}
.chat .user .arrowBtn i{color: #999; font-size: 14px; line-height: 22px}

.chat .say{clear: both; font-size: 14px; margin-bottom: 10px; padding: 0 10px}
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

.footer{width: 100%; position: fixed; bottom: 0; left: 0; height: 46px; background: #fff; box-sizing: border-box; padding: 8px; display: flex}
.writeBox{background: #f1f1f1; height: 30px; border-radius: 18px; flex: 1; line-height: 30px; font-size: 14px; padding-left: 10px; color: #999}
.share,.like{width:60px; text-align: center; height: 30px; line-height: 30px}
.share i{font-size:20px}
.like{font-size: 14px}
.like i{margin-right: 5px}

.write{display: flex;padding: 10px 0}
.write .ipt{flex: 1}
.write .sendBtn{width: 40px; line-height: 46px; text-align: center; font-size: 14px; color: #586a9c; position: relative;}
.write .sendBtn span{position: absolute; left: 0; bottom: 0}
.feedback{clear: both; overflow: hidden; background: #fff}
.feedback .hd{clear: both; overflow: hidden; margin-bottom: 15px; padding: 10px; padding-bottom: 0}
.feedback .hd p{float: left; font-size: 14px; color: #999}
.feedback .hd span{float: right; cursor: pointer; font-size: 14px;color:#586a9c}
.feedback .bd{clear: both; overflow: hidden;margin-bottom: 15px;padding: 10px}
.feedback .bd li{clear: both; overflow: hidden; display: flex;}
.feedback .bd li>.face{width: 50px;}
.feedback .bd li>.face img{border-radius: 50%}
.feedback .bd li>.desc{flex: 1; padding: 0 10px}
.feedback .bd li>.desc .name{font-size: 12px; color: #999; margin-top:5px}
.feedback .bd li>.desc .date{font-size: 12px; color: #999}
.feedback .bd li>.desc .say{font-size: 14px; margin-top: 10px}
.feedback .bd li>.like{ width:60px; text-align: right; color: #586a9c}
.feedback .bd li>.like img{height:20px;display: block; float: right}
.feedback .bd li>.like span{display: block; float: right; line-height: 20px; font-size: 12px; margin-top:2px}

.reply{clear: both; overflow: hidden; display: flex; padding-left: 20px; background: #f7f7f7; margin-left: 50px; padding: 5px;}
.reply{font-size: 14px; line-height: 100%}
.reply span{color:#05c1af; padding:0 3px}

.empty{text-align: center; padding: 30px 0; color: #999}
</style>
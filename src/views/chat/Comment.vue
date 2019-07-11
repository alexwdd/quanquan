<template>
    <div class="wrap">
        <van-nav-bar fixed title="话题详情" left-arrow @click-left="onClickLeft" v-show="!notApp"/>
        <div class="top" v-show="notApp">
            <div class="left" @click="onClickLeft"><img src="../../assets/image/left.png"></div>
            <div class="right"><div class="btn" @click="openApp">打开APP</div></div>
        </div>

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
                    <img :src="photo.url">
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
                    <li @click="share"><i class="icon icon-share"></i> 分享</li>
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
                    <div class="face" @click="gotoUser(vo.memberID)"><img :src="vo.headimg"></div>
                    <div class="desc">
                        <div class="name">{{vo.nickname}}</div>
                        <div class="date">{{vo.createTime}}</div>
                        <div class="say" @click="reply(vo,vo.id)">{{vo.content}}</div>
                    </div>
                    <div class="action" @click="onClickComment(vo,index)" v-show="token!=''">
                        <van-icon name="arrow-down" />
                    </div>
                </li>  
                <div class="reply" v-for="(item,idx) in vo.reply" :key="item.id">
                    <span @click="reply(item,vo.id)">{{item.nickname}}</span> 回复 <span @click="reply(item,vo.id)">{{item.toNickname}}</span>：{{item.content}}
                    <span class="delBtn" @click="delReply(item,index,idx)" v-if="user.id==item.memberID">删除</span>
                </div>              
			</div>
            </van-list>	
		</div>

        <div style="height:46px"></div>

        <div class="footerBox" v-show="token!=''">
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

        <van-actionsheet
        v-model="commentShow"
        :actions="commentActions"
        cancel-text="取消"
        @select="onSelectComment"
        />

        <div class="footer" v-show="notApp">
            <div class="logo"><img src="../../assets/image/logo.jpg"></div>
            <div class="info">
                <p>新加坡同城生活掌上宝</p>
                <p>
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                    <van-icon name="star" />
                </p>
            </div>
            <div class="download" @click="download">下载APP</div>
        </div>

        <van-popup position="top" v-model="show">
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
                </div>
            </div>
        </van-popup>
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
            ],

            //留言选择器
            local:[],//当前信息
            commentShow: false,
            commentActions: [
                {name: '删除'}
            ],
            localComment:[],
            index:0,

            notApp:true,
            show:false,
            downShow:false,
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
        share(){
            let info = this.info;
            let url = 'app://shareURL?url='+this.config.DOMAIN+'chat/comment?id='+info.id+'&title='+info.nickname+'的话题';
            window.location.href = url;
        },
        openApp(){
            if(this.config.isWeiXin()){
                this.show = true
            }else{
                var url = '';
                if(this.config.isIOS()){
                    url = this.config.IOS;
                }else{
                    url = this.config.ANDROIDS
                }
                if (this.open_app(this.config.SCHEME)) {
                    this.open_app(this.config.SCHEME);
                } else {
                    var delay = setInterval(function() {
                        var d = new Date();
                        var t1 = d.getTime();
                        var t0 = 0;
                        if (t1 - t0 < 3000 && t1 - t0 > 2000) {
                            //alert('检测到未安装，请下载APP');
                            window.location.href = url
                        }
                        if (t1 - t0 >= 3000) {
                            clearInterval(delay);
                        }
                    }, 1000);
                }
            }
        },
        open_app(src){
            // 通过iframe的方式试图打开APP，如果能正常打开，会直接切换到APP，并自动阻止a标签的默认行为
            // 否则打开a标签的href链接
            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
            if (userAgent.indexOf("Safari") > -1) {
                window.location.href = src;
            } else {
                var ifr = document.createElement('iframe');
                ifr.src = src;
                ifr.style.display = 'none';
                document.body.appendChild(ifr);
                window.setTimeout(function() {
                    document.body.removeChild(ifr);
                }, 2000);
            }
        },
        download(){
            this.downShow = true;  
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
        onClickComment(info,index){
            if(this.user.id == info.memberID){
                this.commentActions[0]['name'] = '删除';
            }else{
                this.commentActions[0]['name'] = '举报';
            }
            this.localComment = info;
            this.index = index;
            this.commentShow = true;
        },
        onSelectComment(item){
            this.commentShow = false;
            if(item.name!='举报'){
                this.doDelComment(this.localComment);
            }else{
                this.$router.push({name:'jubao',params:{id:this.info.id}});
            }
        },
        doDelComment(info){//删除话题
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:info.id
                };                
                that.$http.post("/V1/chat/delComment",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.comment.splice(this.index, 1);
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
        },
        delReply(info,index,idx){//删除话题
            var that = this;
            that.$dialog.confirm({
                title: '系统提示',
                message: '确认删除吗'
            }).then(() => {
                var data = {
                    token:user.token,
                    id:info.id
                };                
                that.$http.post("/V1/chat/delComment",data).then(result => {
                    let res = result.data;
                    if (res.code == 0) {
                        that.comment[index]['reply'].splice(idx, 1);
                    }else if(res.code==999){
                        window.location.href='app://login';  
                    }else{
                        that.$dialog.alert({title:'错误信息',message:res.desc});
                    }
                });
            })
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
            if(this.config.isApp()){
                this.$router.go(-1);
            }else{
                this.$router.push('/')
            }
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
            if(this.config.isApp()){
                that.notApp = false;
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
.wrap >>> .van-nav-bar .van-icon {color: #7507c2;}
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
.chat .action li i.active{color: #7507c2}
.btn{text-align: right; font-size: 14px; padding-right: 10px; color: #586a9c; margin-top: -10px; margin-bottom: 10px}

.footerBox{width: 100%; position: fixed; bottom: 0; left: 0; height: 46px; background: #fff; box-sizing: border-box; padding: 8px; display: flex; display: none}
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
.feedback .bd li>.face img{border-radius: 5px;}
.feedback .bd li>.desc{flex: 1; padding: 0 10px}
.feedback .bd li>.desc .name{font-size: 12px; color: #999; margin-top:5px}
.feedback .bd li>.desc .date{font-size: 12px; color: #999}
.feedback .bd li>.desc .say{font-size: 14px; margin-top: 10px}
.feedback .bd li>.action{ width:60px; text-align: right}
.feedback .bd li>.action i{display: block; border:1px #dbdbdb solid; color: #dbdbdb; float: right; border-radius:9px; padding:0 5px}

.reply{clear: both; overflow: hidden; padding-left: 20px; background: #f7f7f7; margin-left: 50px; padding: 5px;}
.reply{font-size: 14px; line-height: 100%}
.reply span{color:#7507c2; padding:0 3px}
.reply span.delBtn{color: rgb(46, 64, 114)}

.empty{text-align: center; padding: 30px 0; color: #999}


.top{clear: both; overflow: hidden; height: 46px; position: fixed; left: 0; width: 100%; z-index: 999; background: #fff; border-bottom: 1px #f1f1f1 solid}
.top img{display: block; height: 46px;}
.top .left{float: left;}
.top .right{float: right;}
.top .right .btn{float:right; height: 30px; line-height: 30px; background: #7507c2; border-radius: 5px; color: #fff; margin-right: 10px; margin-top: 10px; font-size: 14px; padding: 0 10px}
.footer{background: rgba(0,0,0,0.8); width:100%; height: 50px; border-radius: 5px; margin: auto; position: fixed; left: 0;bottom: 0px; z-index: 999;}
.footer .logo{float: left; height: 40px; margin-top: 5px; margin-left: 5px; margin-right: 10px}
.footer .logo img{height: 40px; display: block;border-radius: 5px}
.footer .info{float: left; font-size: 14px; color: #fff; padding-top: 5px}
.footer .info p{line-height: 20px;}
.footer .info p i{color:#f60 }
.footer .download{float:right; height: 30px; line-height: 30px; background: #7507c2; border-radius: 5px; color: #fff; margin-right: 10px; margin-top: 10px; font-size: 14px; padding: 0 10px}
.alert{width: 100%;}
.alert img{width: 100%}
.my-van-popup {background-color:transparent; width: 80%;}
.down{clear: both; overflow: hidden;}
.down img{display: block}
.down .hd{clear: both;}
.down .bd{background: #fff; border-bottom-left-radius: 10px; border-bottom-right-radius: 10px; padding: 20px; overflow: hidden; padding-right: 0}
.down .bd li{float: left; width: 50%; padding-right: 20px; box-sizing: border-box}
</style>
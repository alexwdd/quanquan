<template>
    <div class="wrap">
        <van-nav-bar fixed title="评论与回复" left-arrow @click-left="onClickLeft" right-text="全部已读" @click-right="onClickRight"/>
        <div style="height:46px"></div>
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">

            <div class="comment" v-for="(vo) in info" :key="vo.id">                
                <div class="hd">
                    <span class="say" v-if="vo.memberID != userid ">{{vo.nickname}} <i>回复了我</i></span>
                    <span class="say" v-else-if="vo.toUserId!=0"><i>我回复了</i>{{vo.toNickname}}</span>
                    {{vo.content}}
                </div>
                <div class="to" v-if="vo.toContent!=''">{{vo.toContent}}</div>
                <div class="bd" @click="gotoComment(vo)"><span class="tag" v-for="tag in vo.chat.tag" :key="tag.name" :style="'color:'+tag.color">#{{tag.name}}#</span>{{vo.chat.content}}</div>
                <div class="fd">
                    <div class="date">{{vo.createTime}}</div>
                    <div class="action" @click="reply(vo)"><i class="icon icon-wechat"></i> 回复</div>
                </div>
            </div>

        </van-list>     

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
    </div>
</template>

<script>
import user from './auth'
import { ImagePreview } from 'vant';
export default {
    data() {
        return {
            token:'',
            userid:0,
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1,

            boxShow:false,
            formData: {
                placeholder: "评论",
                chatID:0,
                toID:0,
                toUserId:0,
                toNickname:'',
                content: ''
            },
        };
    },
    watch: {
        $route(to) {
            if (to.name == "reply") {
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
        onClickRight(){
            var that = this;
            let data = {
                token : user.token
            };
            that.$http.post("V1/chat/setRead",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    this.$toast('操作成功');
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        gotoComment(info){
            this.$router.push({'path':'/chat/comment',query:{id:info.chatID,token:this.token}});
        },
        onLoad() {
            var that = this;
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                token : user.token,
                cid : that.cid,
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V1/chat/reply",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data); 
                    that.userid = res.body.my; 
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        reply:function(info){
            if(this.info.open==0){
                return false;
            }
            var that = this;
            if(info.memberID != that.userid){
                that.formData.placeholder = '回复'+info.nickname;
                that.formData.toUserId = info.memberID;
                that.formData.toNickname = info.nickname;
            }else if(info.toUserId!=0){
                that.formData.placeholder = '回复'+info.toNickname;
                that.formData.toUserId = info.toUserId;
                that.formData.toNickname = info.toNickname;
            }
            that.formData.toID = info.toID;
            that.formData.chatID = info.chatID;            
            that.formData.content = '';
            that.boxShow = true;
        },
        saveComment:function(){
            var that = this;
            if(that.formData.content == ''){
                that.$dialog.alert({title:'错误信息',message:'请输入评论内容'});
                return false;
            }           
            var formData = that.formData; 
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

                    that.info = [];
                    that.page = 1;
                    that.onLoad();

                    that.boxShow = false;
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
.wrap >>> .van-nav-bar .van-nav-bar__text {color: #666;}
.comment{clear: both; overflow: hidden; background: #fff; margin-top: 5px; font-size: 14px}
.comment .hd{padding: 10px;}
.comment .hd span{color: #05c1af;}
.comment .hd span i{font-style: normal; color: #999; padding: 0 5px}
.comment .bd{margin: 0 10px; background: #f7f7f7; padding: 10px}
.comment .to{padding:0 10px 10px 10px; color: #999}
.comment .fd{clear: both; padding: 10px; color: #999; overflow: hidden;}
.comment .fd .date{float: left;}
.comment .fd .action{float: right;}
.write{display: flex; padding: 10px 0}
.write .ipt{flex: 1}
.write .sendBtn{width: 40px; line-height: 46px; text-align: center; font-size: 14px; color: #586a9c; position: relative;}
.write .sendBtn span{position: absolute; left: 0; bottom: 0}
</style>

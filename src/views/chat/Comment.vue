<template>
    <div class="wrap">
        <van-nav-bar fixed title="话题留言" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <div class="chat">
            <div class="user">
                <div class="face"><img :src="info.face"></div>
                <div class="name"><p>{{info.nickname}}</p><span>{{info.createTime}}</span></div>
                <div class="focus focused" v-if="info.focus" @click=doFocus>已关注</div>
                <div class="focus" v-else="" @click=doFocus>关注</div>
            </div>
            <div class="say">{{info.content}}</div>
            <template v-if="info.images!=''">

            <div class="photo single" v-if="info.num==1">
                <li v-for="photo in info.images" :key="photo" @click="showImagePreview">
                    <img :src="photo">
                </li>
            </div>

            <div class="photo" v-else="">
                <li v-for="photo in info.thumb" :key="photo" @click="showImagePreview">
                    <img :src="photo">
                </li>
            </div>
            </template>
        </div>

        <div class="feedback">
			<div class="hd">
				<p>留言</p>
			</div>
			<div class="empty" v-show="empty" @click="showWrite"><p>抢占沙发~</p></div>
			<div class="bd">
                <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="getData">
                    <li v-for="vo in comment">
                        <div class="face"><img :src="vo.headimg"></div>
                        <div class="desc">
                            <div class="name">{{vo.nickname}}</div>
                            <div class="say">{{vo.content}}</div>
                        </div>					
                    </li>
                </van-list>	
			</div>
		</div>

        <div style="height:46px"></div>

        <div class="footer">
            <div class="writeBox" @click="showWrite">
                <van-icon name="edit" /> 写留言...
            </div>
            <div class="like"><van-icon class-prefix="icon" name="dianzan" />1</div>
            <div class="share"><van-icon class-prefix="icon" name="fenxiang" /></div>
        </div>

        <van-popup v-model="boxShow" position="bottom">
            <div class="write">
            <van-field
                v-model="content"
                type="textarea"
                placeholder="请输入留言"
                rows="1"
                autosize
            />
            <van-cell-group>
                <van-switch-cell v-model="checked" title="公开" active-color="#05c1af"/>
            </van-cell-group>
            </div>
            <div style="padding: 10px;">
                <van-button class="my-btn" size="large" @click="saveComment">提交</van-button>
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
            id:'',
            token:'',
            info:{},
            comment:[],
            content:'',
            boxShow:false,
            empty:false,
            checked:true,

            loading: false,
            finished: false,
            canPost:true,
            page:1
		}
    },
	watch: {
        $route(to) {
            if (to.name == "comment") {  
                this.page = 1;
                this.comment = [];
                this.init();
                this.getData();
            }
        }
    },
	created(){
        this.page = 1;
        this.comment = [];
        this.init();
	},
    methods: {        
        showImagePreview(position, timer) {
            var that = this;
            var images = that.info.images;
            const instance = ImagePreview({
                images,
                asyncClose: !!timer,
                startPosition: typeof position === 'number' ? position : 0
            });
            if (timer) {
                setTimeout(() => {
                    instance.close();
                }, timer);
            }
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        doFocus(){

        },
        showWrite(){
            this.boxShow = true;
        },
        init(){
            var that = this;
            that.id = that.$route.query.id;
			if (that.id>0 && that.id!=''){
                let data = {
                    id : that.id
                };
				that.$http.post("/V1/chat/getinfo",data).then(result => {   
                    let res = result.data;
                    if (res.code == 0) {
                        // 加载状态结束
                        that.info = res.body.data;
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
            if(that.content == ''){
                that.$dialog.alert({title:'错误信息',message:'请输入评论内容'});
                return false;
            }           
            var data = {
                cityID:that.config.CITYID,
                token:user.token,
                content:that.content,
                id:that.id
            };
            if(that.checked){
                data.open=1;
            }else{
                data.open=0;
            }
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/V1/chat/comment",data).then(result => {
                let res = result.data;
                this.$toast.clear();
                if (res.code == 0) {
                    that.content='';                  
                    this.$dialog.alert({title:'系统信息',message:res.desc});
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
.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 50%;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #c00; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.chat .user .focused{background-color: #ccc; color: #fff;}
.chat .say{clear: both; font-size: 14px; margin-bottom: 10px; padding: 0 10px}
.chat .photo{clear: both; padding-left: 10px}
.chat .photo li{float: left; width: 33.333%; padding-right: 10px; box-sizing: border-box; padding-bottom: 10px}
.chat .photo li img{display: block; width: 100%}
.chat .single li{width: 60%}
.chat .action{clear: both;}
.chat .action li{float: left; width: 33.333%; text-align: center; font-size: 12px; line-height: 20px; color: #999}
.chat .action li i{font-size: 16px; display: inline;}

.footer{width: 100%; position: fixed; bottom: 0; left: 0; height: 46px; background: #fff; box-sizing: border-box; padding: 8px; display: flex}
.writeBox{background: #f1f1f1; height: 30px; border-radius: 18px; flex: 1; line-height: 30px; font-size: 14px; padding-left: 10px; color: #999}
.share,.like{width:60px; text-align: center; height: 30px; line-height: 30px}
.share i{font-size:20px}
.like{font-size: 14px}
.like i{margin-right: 5px}

.my-btn{color: #fff;background-color: #05c1af;border: 1px solid #05c1af;}

.feedback{clear: both; overflow: hidden; padding: 10px; background: #fff}
.feedback .hd{clear: both; overflow: hidden; margin-bottom: 15px}
.feedback .hd p{float: left;}
.feedback .hd span{float: right; cursor: pointer; font-size: 14px;color:#586a9c}
.feedback .bd{clear: both; overflow: hidden;}
.feedback .bd li{clear: both; overflow: hidden; display: flex; margin-bottom: 15px}
.feedback .bd li .face{width: 50px;}
.feedback .bd li .face img{border-radius: 50%}
.feedback .bd li .desc{flex: 1; padding: 0 10px}
.feedback .bd li .desc .name{font-size: 14px; color: #999}
.feedback .bd li .desc .say{font-size: 14px;}
.feedback .bd li .like{ width:60px; text-align: right; color: #586a9c}
.feedback .bd li .like img{height:20px;display: block; float: right}
.feedback .bd li .like span{display: block; float: right; line-height: 20px; font-size: 12px; margin-top:2px}
.empty{text-align: center; padding: 30px 0; color: #999}
</style>
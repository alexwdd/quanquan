<template>
    <div class="wrap">
        <van-nav-bar fixed title="评论与回复" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="comment" v-for="(vo) in info" :key="vo.id">
                <div class="hd"><span class="say" v-if="vo.toUserId != vo.memberID">{{vo.nickname}} <i>回复了我</i></span>{{vo.content}}</div>
                <div class="to" v-if="vo.toContent!=''">{{vo.toContent}}</div>
                <div class="bd"><span class="tag" v-for="tag in vo.chat.tag" :key="tag.name" :style="'color:'+tag.color">#{{tag.name}}#</span>{{vo.chat.content}}</div>
                <div class="fd">
                    <div class="date">{{vo.createTime}}</div>
                    <div class="action"><i class="icon icon-wechat"></i> 回复</div>
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
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
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
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.comment{clear: both; overflow: hidden; background: #fff; margin-top: 5px; font-size: 14px}
.comment .hd{padding: 10px;}
.comment .hd span{color: #05c1af;}
.comment .hd span i{font-style: normal; color: #999; padding: 0 5px}
.comment .bd{margin: 0 10px; background: #f7f7f7; padding: 10px}
.comment .to{padding:0 10px 10px 10px; color: #999}
.comment .fd{clear: both; padding: 10px; color: #999; overflow: hidden;}
.comment .fd .date{float: left;}
.comment .fd .action{float: right;}

</style>

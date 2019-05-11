<template>
    <div class="wrap">
        <van-nav-bar fixed title="我发布的话题" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>
        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="chat" v-for="(vo,idx) in info" :key="vo.id">
                <div class="user">
                    <div class="face"><img :src="vo.face"></div>
                    <div class="name"><p>{{vo.nickname}}<i v-if="vo.noread > 0">{{vo.noread}}</i></p><span>{{vo.createTime}}</span></div>
                    <div class="del" @click=doDel(idx,vo)>删除</div>
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
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            page:1
        };
    },
    watch: {
        $route(to) {
            if (to.name == "mychat") {
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
        doDel(index,info){//删除
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
                cid : that.cid,
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V1/chat/myChat",data).then(result => {
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
.tab{clear: both;overflow: hidden;}
.tab li{display: inline-block; font-size: 14px; padding:0 10px;}
.tab li.active{color: #05c1af;}

.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 50%;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name p i{display:inline-block;min-width:14px; height:14px; line-height:14px; border-radius:50%; background: #c00;top:0px; right: 0px; font-size:12px; color:#fff; font-style: normal; margin-left: 5px; text-align: center}
.chat .user .name span{color: #999}
.chat .user .del{float: right; font-size: 14px; height: 24px; line-height: 24px;color: #586a9c; margin-top: 10px}

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

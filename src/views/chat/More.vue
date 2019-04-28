<template>
    <div class="wrap">
        <van-nav-bar fixed title="发现更多" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>        

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <div class="comm">  
                <li>
                    <div class="item">
                        <van-icon name="success" class="active"/>
                        <img src="http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png">                        
                    </div>
                    <p>jack</p>
                    <span>45人关注</span>
                </li>
                <li>
                    <div class="item">
                        <van-icon name="success" />
                        <img src="http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png">                        
                    </div>
                    <p>jack</p>
                    <span>45人关注</span>
                </li>
                <li>
                    <div class="item">
                        <van-icon name="success" />
                        <img src="http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png">                        
                    </div>
                    <p>jack</p>
                    <span>45人关注</span>
                </li>
                <li>
                    <div class="item">
                        <van-icon name="success" />
                        <img src="http://www.worldmedia.top/uploads/2018-10-30/5bd7333970480.png">                        
                    </div>
                    <p>jack</p>
                    <span>45人关注</span>
                </li>
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
            typeShow:false,
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
            if (to.name == "more") {
                this.typeShow=false;
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

.comm{background: #fff; clear: both; border-bottom:1px #f1f1f1 solid}

.comm{clear: both; overflow: hidden; padding:10px 0}
.comm li{float: left; width: 25%; text-align: center}
.comm li .item{width: 50px; height: 50px; position: relative; margin: auto}
.comm li .item img{width: 50px; height: 50px; border-radius: 50%; display: block;}
.comm li .item i{position: absolute; right: 0; top: 0; width: 14px; height: 14px; background: #999; font-size: 12px; color: #fff; line-height: 14px; border-radius: 4px}
.comm li .item i.active{background:#c00; color: #fff}
.comm li p{font-size: 12px}
.comm li span{font-size: 12px; color: #999; text-align: center}
</style>

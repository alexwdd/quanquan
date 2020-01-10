<template>
    <div class="wrap">
        <van-nav-bar fixed :title="title" left-arrow @click-left="onClickLeft"/>
        <div style="height:46px"></div>
		<div id="fallBox">
			<vue-waterfall-easy ref="waterfall" :imgsArr="info" @scrollReachBottom="getData"  @click="detail">
				<template slot-scope="props">
                    <div class="item-body">
                        <div class="item-desc">{{props.value.title}}</div>
                        <div class="item-footer">
                            <div class="avatar" v-if="props.value.user.headimg==''"><img src="../assets/image/logo.jpg"></div>
                            <div class="avatar" v-else=""><img :src="props.value.user.headimg"></div>
                            <div class="name" v-if="props.value.user.nickname==''">{{config.APP_NAME}}</div>
                            <div class="name" v-else="">{{props.value.user.nickname}}</div>
                            <div class="like">
                                <van-icon name="like-o" />
                                <div class="like-total">{{props.value.hit}}</div>
                            </div>
                        </div>
                    </div>
				</template>
			</vue-waterfall-easy>
		</div>
    </div>
</template>

<script>
import vueWaterfallEasy from 'vue-waterfall-easy'
export default {
    data(){
		return {
            title:this.config.APP_NAME+'推荐',
            info:[],
            page:1,
            finished: false,
		}
    },
    components:{vueWaterfallEasy},
	watch: {
        $route(to) {
            if (to.name == "commend") {
                this.info = [];
                this.page = 1;
                this.finished = false;
                this.getData();
            }
        }
    },
	created(){
        this.getData()
    },
    methods: {
        detail(event, { index, value }) {
            if(value.type=='article'){
                this.$router.push({name:'view',params:{id:value.articleid}})
            }else{
                this.$router.push({name:'detail',params:{type: value.type,id:value.articleid}})
            }	
		},
        onClickLeft() {
            this.$router.go(-1);
        },
        getData() {
            var that = this;  
            if(that.finished){
                this.$refs.waterfall.waterfallOver();
                return false;
            }
            let data = {
                cityID : that.config.CITYID,
                page : that.page,
            };
            that.$http.post("V3/weixin/getcomm",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    for (let i = 0; i < res.body.data.length; i++) {
						res.body.data[i]['src'] = res.body.data[i]['image'];
					}
                    that.info = that.info.concat(res.body.data); 
                    if(res.body.next==0){
                        that.finished = true;
                    }     
                    that.page++;          
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
#fallBox{width: 100%; height:100vh;}

.item-body{background: #fff}
.item-desc{font-size: 14px; padding: 5px;clear: both}
.item-footer{clear: both;background: #fff; overflow: hidden; padding: 5px;}
.item-footer .avatar{float: left; margin-right: 5px}
.item-footer .avatar img{display: block; width: 30px; height: 30px; border-radius: 50%}
.item-footer .name{line-height: 30px;float: left;font-size: 12px}
.item-footer .like{float: right; line-height: 30px; color: #999}
.item-footer .like i{float: left; margin-top: 7px; margin-right: 3px}
.item-footer .like .like-total{float: left; font-size: 12px}
</style>
<template>
    <div class="wrap">
        <van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft"/>

        <div style="height:46px"></div>

        <div id="fallBox">
			<vue-waterfall-easy ref="waterfall" :imgsArr="info" @scrollReachBottom="getData"  @click="detail">
				<template slot-scope="props">
					<div class="fall">
						<div class="title">{{props.value.title}}</div>
						<div class="footer">
							<div class="date">{{props.value.createTime}}</div>
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
    data() {
        return {
            cateName:'',
            info:[],
            finished: false,
            page:1
        };
    },
    components: {
		vueWaterfallEasy
	},
    watch: {
        $route(to) {
            if (to.name == "news") {
                this.info = [];
                this.page = 1;
                this.finished = false;
                this.getData();
            }
        }
    },
    created() {
        this.getData();
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        detail(event, { index, value }) {
			this.$router.push({name:'view',params:{ id:value.id }})		
		},
        getData() {
            var that = this;            
            if(that.finished){
                this.$refs.waterfall.waterfallOver();
                return false;
            }
            let data = {
                cityID : that.config.CITYID,
                cid:that.id = that.$route.params.cid,
                page : that.page
            };
            that.$http.post("V3/weixin/news",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    for (let i = 0; i < res.body.data.length; i++) {
						res.body.data[i]['src'] = res.body.data[i]['picname'];
					}
					if(res.body.next==0){
                        that.finished = true;
                    }              
                    that.info = that.info.concat(res.body.data);
                    that.cateName = res.body.cateName;
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
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
#fallBox{width: 100%; height:100vh;}
.fall{clear: both;background: #fff; overflow: hidden; padding: 5px;}
.fall .title{font-size: 14px;clear: both;color:#000}
.fall .footer{clear: both;}
.fall .date{line-height: 30px;float: left;font-size: 12px}
.fall .like{float: right; line-height: 30px; color: #999}
.fall .like i{float: left; margin-top: 7px; margin-right: 3px}
.fall .like .like-total{float: left; font-size: 12px}
</style>

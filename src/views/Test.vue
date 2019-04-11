<template>
    <div class="wrap">
		<van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft"/>

		<div id="fallBox">
			<vue-waterfall-easy :imgsArr="imgsArr" @scrollReachBottom="getData">
				<template slot-scope="props">
					<div class="fall">
						<div class="img"><img :src="props.value.picname"></div>
						<div class="title">{{props.value.title}}</div>
						<div class="footer">
							<div class="date">{{props.value.createTime}}</div>
							<div class="like">{{props.value.hit}}</div>
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
	name: 'app',
	data() {
		return {
			cateName:'',
			imgsArr: [],
			page: 1, // request param
		}
	},
	components: {
		vueWaterfallEasy
	},
  	methods: {
		onClickLeft() {
        	this.$router.go(-1);
        },
      	getData() {			
            var that = this;
            let data = {
				cityID : that.config.CITYID,
				cid:94,
                page : that.page,
            };
            that.$http.post("V3/weixin/news",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束           
					that.imgsArr = that.imgsArr.concat(res.body.data);  
					that.cateName = res.body.cateName;
                    that.page++;          
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
  	},
  	created() {
		this.getData()
	}
}
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {
    color: #05c1af;
}
#fallBox{width: 100%; height:800px;}

</style>
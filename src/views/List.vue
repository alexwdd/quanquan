<template>
    <div class="wrap">
        <div class="indexList">
            <div class="db"> 
                <div class="picList">
                    <div class="picInfo" v-bind:style="{backgroundImage:'url('+vo.thumb_b+')'}">
                        <div class="slider-money">
                            <span v-if="vo.price == 0">详情请咨询</span>
                            <span v-else-if="vo.price == 0.10">自助</span>
                            <span v-else-if="vo.price == 0.1">自助</span>
                            <span v-else>{{fixHead}}${{vo.price}}</span>
                            <div class="tag4" v-if="vo.tag4 !='' ">{{vo.tag4}}</div>
                        </div>
                        <div class="slider-tag">
                            <span class="tag1" v-if="vo.tag1 !=''">{{vo.tag1}}</span>
                            <span class="tag2" v-if="vo.tag2 !=''">{{vo.tag2}}</span>
                            <span class="tag3" v-if="vo.tag3 !=''">{{vo.tag3}}</span>
                        </div>
                    </div>
                    <div class="info">
                        <p>{{vo.title}}</p>
                        <div class="address"><van-icon name="location-o" /> {{vo.address|empty}}</div>
                    </div>
                </div>   
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            ad :'',
            cate:'',
            info:''
        };
    },
    watch: {
        $route(to) {
            if (to.path == "/") {
                this.init();
            }
        }
    },
    created() {
        this.init();
    },
    methods: {        
        init() {
            var that = this;
            this.$toast.loading({mask: true,duration:0});
            let data = {
                cityID : that.config.CITYID
            }
            that.$http.post("V1/article/getads",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
					that.ad = res.body.ads;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
            that.$http.post("V3/article/getmodels",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {
					that.cate = res.body;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
            that.$http.post("V3/article/getmain",data).then(result => {
				this.isLoading=false;
				this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {
					that.info = res.body;
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap {min-height: 100vh;}
.banner{height: 30vh;}
.banner img{width: 100%; height: 100%;}
.indexMenu{clear: both; overflow: hidden;}
.indexMenu li{float: left; width: 33.33%; text-align: center}

.indexList{clear: both; border-top: 1px #dbdbdb dashed; padding: 0 10px; padding-bottom: 10px}
.indexList .hd{height: 40px; line-height: 40px;}
.indexList .hd span{float: right; font-size: 12px; color: #05c1af}
.news img{height: 200px; width: 100%;}

.picInfo{position: relative; height: 180px; background-position: center; background-repeat: no-repeat;background-size: cover;}
.picList .slider-money{position: absolute; left: 0; bottom: 40px; z-index: 99; width: 100%}
.picList .slider-money span{background: rgba(0,0,0,0.7); color: #05c1af;padding: 5px 10px; display:block; float: left; margin-right: 15px; margin-top: -5px}
.picList .slider-money .tag4{background: #06c2b0; float: left;color: #fff; border-radius: 5px; padding: 3px 6px; font-size: 12px;}
.picList .slider-tag{position: absolute; left: 5px; bottom: 5px; width: 100%; z-index: 99}
.picList .slider-tag span{display: inline-block; color: #fff; border-radius: 5px; padding: 3px 6px; font-size: 12px;}
.picList .slider-tag span.tag1{background: #2bc3fa}
.picList .slider-tag span.tag2{background: #f54d8f}
.picList .slider-tag span.tag3{background: #8d8e8f}
.picList .info{clear: both; overflow: hidden;}
.picList .info p{font-size: 16px; font-weight: normal; width: 100%;overflow: hidden;text-overflow: ellipsis;white-space: nowrap; padding: 5px 0}
.picList .info .address{font-size: 14px}
.picList .info .address i{color:#05c1af}
</style>

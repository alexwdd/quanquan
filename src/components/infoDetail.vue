<template>	
    <div class="picList">
        <div class="picInfo" v-bind:style="{backgroundImage:'url('+info.thumb_b+')'}">
            <div class="slider-money">
                <span v-if="info.price == 0">详情请咨询</span>
                <span v-else-if="info.price == 0.10">自助</span>
                <span v-else-if="info.price == 0.1">自助</span>
                <span v-else>${{info.price}}</span>
                <div class="tag4" v-if="info.tag4 !='' ">{{info.tag4}}</div>
            </div>
            <div class="slider-tag">
                <span class="tag1" v-if="info.tag1 !=''">{{info.tag1}}</span>
                <span class="tag2" v-if="info.tag2 !=''">{{info.tag2}}</span>
                <span class="tag3" v-if="info.tag3 !=''">{{info.tag3}}</span>
            </div>
        </div>
        <div class="info">
            <p>{{info.title}}</p>
            <div class="address"><van-icon name="location-o" /> {{info.address|empty}}</div>
        </div>
    </div>
</template>

<script>
export default {
    name: "topnav",
    props: {
        info:{}
    },
    created(){
        console.log(this.info)
    },
    methods:{
    }
};
</script>
<style scoped>
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
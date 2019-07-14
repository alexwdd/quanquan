<template>	
    <div>
        <div class="news" v-if="type=='article'">
            <router-link :to="'/view/'+info.id">
            <img v-lazy="info.thumb"/>                            
            <p>{{info.title}}</p>
            </router-link>
        </div>

        <div class="job" v-else-if="type=='zp'">   
            <router-link :to="'/detail/'+type+'/'+info.articleid">
            <h1>{{info.title}}</h1>
			<p><van-icon class-prefix="icon" name="loufang" /> {{info.company|empty}}</p>
			<p><van-icon class-prefix="icon" name="weizhi" /> {{info.address|empty}}</p>
			<div class="jobInfo">
				<div class="job-left">{{info.price}}</div>
				<div class="job-right">
                    <van-tag type="success">{{info.sortName}}</van-tag>
                    <van-tag type="primary" v-if="info.work!=''">{{info.work}}</van-tag>
                    <van-tag type="danger" v-if="info.visa!=''">{{info.visa}}</van-tag>
				</div>
			</div>
            </router-link>
        </div>

        <div class="picList" :class="{padd: padding }" v-else="">
            <router-link :to="'/detail/'+type+'/'+info.articleid">
            <div class="picInfo" v-lazy:background-image="info.thumb_b">
                <div class="slider-money">
                    <span>{{info.price}}</span>
                </div>
                <div class="slider-tag">
                    <span class="tag1" v-if="info.tag1 !=''">{{info.tag1}}</span>
                    <span class="tag2" v-if="info.tag2 !=''">{{info.tag2}}</span>
                    <span class="tag3" v-if="info.tag3 !=''">{{info.tag3}}</span>
                </div>
            </div>
            <div class="info">
                <p>{{info.title}}</p>
                <div class="address"><van-icon class-prefix="icon" name="weizhi" /> {{info.address|empty}}</div>
            </div>
            </router-link>
        </div>
    </div>    
</template>

<script>
import Vue from 'vue';
import def from '../assets/image/default_320.jpg';
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:def
});
import '../assets/fonts/iconfont.css';
export default {
    props: {
        type:String,
        padding:Boolean,
        info:{}
    },
    created(){
    },
    methods:{
    }
};
</script>
<style scoped>
.news{padding-right: 10px;}
.news img{height: 200px; width: 100%;}

.picInfo{position: relative; height: 180px; background-position: center; background-repeat: no-repeat;background-size: cover;}

.picList{background: #fff; padding-right: 10px}
.padd{padding:10px 0px; width: 100%; box-sizing: border-box; border-bottom:1px #dbdbdb dashed;}
.picList .slider-money{position: absolute; left: 0; bottom: 40px; z-index: 99; width: 100%}
.picList .slider-money span{background: rgba(0,0,0,0.7); color: #05c1af;padding: 5px 10px; display:block; float: left; margin-right: 15px; margin-top: -5px}
.picList .slider-money .tag4{background: #06c2b0; float: left;color: #fff; border-radius: 5px; padding: 3px 6px; font-size: 12px;}
.picList .slider-tag{position: absolute; left: 5px; bottom: 5px; width: 100%; z-index: 0}
.picList .slider-tag span{display: inline-block; color: #fff; border-radius: 5px; padding: 3px 6px; font-size: 12px;}
.picList .slider-tag span.tag1{background: #2bc3fa}
.picList .slider-tag span.tag2{background: #f54d8f}
.picList .slider-tag span.tag3{background: #8d8e8f}
.picList .info{clear: both; overflow: hidden;}
.picList .info p{font-size: 16px; font-weight: normal; width: 100%;overflow: hidden;text-overflow: ellipsis;white-space: nowrap; padding: 5px 0}
.picList .info .address{font-size: 14px}
.picList .info .address i{color:#05c1af}

.job{clear: both; overflow: hidden; padding-right: 10px;}
.job h1{font-size: 16px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical; margin-bottom: 10px; height: 42px;}
.job p{font-size: 14px; padding: 5px 0}
.job p i{color:#05c1af; font-size: 14px;}
.job .jobInfo{clear: both; overflow:hidden;}
.job .jobInfo .job-left{float: left;}
.job .jobInfo .job-right{float: right;}
</style>
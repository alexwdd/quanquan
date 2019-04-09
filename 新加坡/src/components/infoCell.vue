<template>	
    <div>
        <div v-if="type=='sp'"></div>
        <div v-if="type=='tc'">
            <van-cell title="开始时间" :value="info.begin|empty"/>
            <van-cell title="结束时间" :value="info.end|empty"/>
            <van-cell title="相关链接" :value="info.links" v-if="info.links!=''"/>
        </div>

        <div v-if="type=='zf'">
            <van-cell title="出租类型" :value="info.singleType|empty"/>
            <van-cell title="出租时长" :value="info.remark|empty"/>
            <van-cell title="入住时间" :value="info.Into|empty"/>
            <div class="sheshi">
		    	<dd v-for="(item,index) in sheshi" :key="index"><span :class="{active: item.checked}">{{item.name}}</span></dd>
            </div>
            <van-cell title="地铁" :value="info.subway|empty"/>
        </div>

        <div v-if="type=='zp'">
            <van-cell title="工作类型" :value="info.work|empty"/>
            <van-cell title="签证类型" :value="info.visa|empty"/>
            <van-cell title="公司名称" :value="info.company|empty"/> 
            <van-cell title="邮箱" :value="info.email|empty"/>
            <van-cell title="相关链接" :value="info.links" v-if="info.links!=''"/>
        </div>

        <div v-if="type=='esc'">
            <van-cell title="汽车品牌" :value="info.brand|empty"/>
            <van-cell title="变速箱" :value="info.trans|empty"/>
            <van-cell title="里程数" :value="info.mileage|empty"/>
            <van-cell title="出厂年份" :value="info.year|empty"/>
        </div>

        <div v-if="type=='ms'">
            <van-cell title="平台优惠" :value="info.discount|empty" v-if="info.discount!=''"/>
            <van-cell title="营业时间" :value="info.time|empty"/>
            <van-cell title="配送范围" :value="info.area|empty"/>
            <van-cell title="特色标签" :value="info.feature|empty" v-if="info.feature!=''"/>
            <van-cell title="相关链接" :value="info.links" v-if="info.links!=''"/>
        </div>

        <div v-if="type=='sh'">
            <van-cell title="平台优惠" :value="info.discount|empty" v-if="info.discount!=''"/>
            <van-cell title="相关链接" :value="info.links" v-if="info.links!=''"/>
        </div>

        <div v-if="type=='xp'">
            <van-cell title="平台优惠" :value="info.discount|empty" v-if="info.discount!=''"/>
            <van-cell title="特色标签" :value="info.feature|empty" v-if="info.feature!=''"/>
            <van-cell title="相关链接" :value="info.links" v-if="info.links!=''"/>
        </div>
    </div>    

</template>

<script>
export default {
    props: {
        type:String,
        info:{},
        sheshi:{}
    },
    created(){
    },
    methods:{      
    }
};
</script>
<style scoped>
.sheshi{clear:both;overflow:hidden;background: #fff}
.sheshi dd{float:left;width:33.333%;margin:0;padding:5px; box-sizing: border-box}
.sheshi dd span{background:#f7f7f7;display:block;line-height:40px;text-align:center;cursor:pointer;color:#ccc; font-size: 14px}
.sheshi dd span.active{background:#7507C2;color:#fff}
</style>
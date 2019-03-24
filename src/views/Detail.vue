<template>
    <div class="wrap">
        <van-nav-bar title="文章详情" left-arrow @click-left="onClickLeft"/>
        <div class="title">{{info.title}}</div>
        <div class="date">{{info.time}}</div>
        <div class="content" v-html="info.content"></div>
    </div>
</template>

<script>
export default {
    data(){
		return {
			id:'',
			info:{}
		}
	},
	watch:{
		// 如果路由有变化，会再次执行该方法
    	'$route':'init'
	},
	created(){
		this.init();
	},
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        init(){
            
		}
    }
};
</script>
<style scoped>

</style>

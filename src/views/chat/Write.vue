<template>
    <div class="wrap">
        <van-nav-bar title="发布话题" left-arrow @click-left="onClickLeft"></van-nav-bar>
        
        <textarea class="text" placeholder="请输入您要发布的内容" v-model="content"></textarea>

        <div class="images-list">
            <div v-for="(vo,index) in images" :key="index" class="photo">
                <img :src="vo.content">
                <van-icon class="del" name="cross" @click="delImg(index)"/>
            </div>

            <van-uploader v-show="show" :after-read="onRead" class="photo" accept="image/gif, image/jpeg, image/png" multiple>
                <van-icon class="cam" name="photograph"/>
            </van-uploader>
        </div>

        <van-cell title="版块" is-link arrow-direction="down" value="" />
        <van-cell title="标签" is-link arrow-direction="down" value="" />
        
        <div class="btn">
            <van-button size="large" round class="my-btn" @click="submit">确认发布</van-button>
        </div>
    </div>
</template>

<script>
import user from './auth' // permission control
export default {
    data() {
        return {
            show:true,
            content:'',
            cate:[],
            tag:'',
            images:[]
        };
    },
    beforeRouteEnter:(to,from,next)=>{
        if(user.status==false){
            window.location.href='app://login';
        }else{
            next();
        }
    },
    watch: {

    },
    created() {
        //console.log(user);
    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        onRead(file){
            var that = this;
            if((that.images.length + file.length)>9){
                that.$dialog.alert({title:'错误信息',message:'最多上传9张图片'});
                return false;
            }
            that.images = that.images.concat(file);
            if(that.images.length>=9){
                that.show = false;
            }
        },
        delImg: function(idx) {
            this.images.splice(idx, 1);
            if(this.images.length<9){
                this.show = true;
            }
        },
        submit:function(){
            var that = this;
            if(that.content == ''){
                that.$dialog.alert({title:'错误信息',message:'请输入内容'});
                return false;
            }
            if(that.images.length>9){
                that.$dialog.alert({title:'错误信息',message:'最多上传9张图片'});
                return false;
            }
            var data = {
                token:user.token,
                content:that.content,
                images:that.images,
                cate:that.cate,
                tag:that.tag
            };
            that.$http.post("/V1/chat/submit",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    this.fallData = res.body;
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
.wrap{background: #fff; height: 100vh; width: 100%;}
.text{border: 0; padding: 10px; font-size: 14px; width: 100%; box-sizing: border-box; min-height: 20vh}
.images-list{ padding: 10px; clear: both; overflow: hidden;}
.photo{background: #f1f1f1; width: 60px; height: 60px; text-align: center; line-height: 60px; float: left; margin-right: 10px; margin-bottom: 10px; overflow: hidden; position: relative;}
.del{position: absolute; right: 0; top: 0; background:rgba(0, 0, 0, 0.8); color: #fff;}
.cam{font-size: 30px; line-height: 60px; color: #ccc}
.photo img{display: block; width: 100%}
.btn{padding: 10px; position: fixed; bottom: 20px; left: 0; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
</style>

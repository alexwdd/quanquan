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

        <van-cell title="版块" is-link arrow-direction="down" :value="cate.name" @click="clickShowCate"/>
        <van-cell title="标签" is-link arrow-direction="down" :value="tag"  @click="clickShowTag"/>
        
        <div class="btn">
            <van-button size="large" round class="my-btn" @click="submit">确认发布</van-button>
        </div>

        <van-popup v-model="cateShow" position="bottom">
            <div class="quick">
                <li v-for="vo in cateArr" :key="vo.cid" @click="onSelectCate(vo)"><img :src="vo.icon"><p>{{vo.name}}</p></li>
            </div>
        </van-popup>
        <van-popup v-model="tagShow" position="bottom">
            <div class="tag">
                <li v-for="vo in tagArr" :key="vo.cid" @click="onSelectTag(vo.name)"><van-tag plain size="medium">{{vo.name}}</van-tag></li>
            </div>
        </van-popup>
    </div>
</template>

<script>
import user from './auth' // permission control
export default {
    data() {
        return {
            cateShow:false,
            tagShow:false,
            show:true,
            content:'',
            cateArr:[],
            cate:[],
            tagArr:[],
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
        $route(to) {
            if (to.name == "write") {
                this.init();
            }
        }
    },
    created() {
        this.init()
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
            if(Object.prototype.toString.call(file)==='[object Array]'){
                for (let i = 0; i < file.length; i++) {
                    that.compressImage(file[i],600,0,function(res){                    
                        file[i]['content'] = res;
                        that.images = that.images.concat(file[i]);
                        if(that.images.length>=9){
                            that.show = false;
                        }          
                    });
                }
            }else{
                that.compressImage(file,600,0,function(res){                    
                    file.content = res;
                    that.images = that.images.concat(file);
                    if(that.images.length>=9){
                        that.show = false;
                    }          
                });
            }           
        },
        compressImage(file,width,height=0,callback){
            var img = new Image();
            img.src = file.content
            img.onload = function() {
                var that = this;
                if(height>0){
                    var w = width,h = height;
                }else{
                    //生成比例
                    var w = that.width,h = that.height,scale = w / h;
                    w = width || w;
                    h = w / scale;
                }
                //生成canvas
                let canvas = document.createElement('canvas');
                let ctx = canvas.getContext('2d');      
                canvas.width = w;
                canvas.height = h;
                ctx.drawImage(that, 0, 0, w, h);
                // 生成base64            
                let base64 =  canvas.toDataURL(file.file.type, 0.8);
                callback(base64)
            };
        },
        delImg: function(idx) {
            this.images.splice(idx, 1);
            if(this.images.length<9){
                this.show = true;
            }
        },
        clickShowCate(){
            this.cateShow = true;
        },
        onSelectCate(info){
            this.cate = info;
            this.cateShow = false;
        },
        clickShowTag(){
            this.tagShow = true;
        },
        onSelectTag(value){
            this.tag = value;
            this.tagShow = false;
        },
        init(){
            var that = this;
            if(user.status==true){
                that.token = user.token;
            }
            let data = {
                cityID : that.config.CITYID
            };
            that.$http.post("V1/chat/cate",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    that.cateArr = res.body.cate;
                    that.tagArr = res.body.tag;
                 }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        },
        submit:function(){
            var that = this;
            if(that.content == ''){
                that.$dialog.alert({title:'错误信息',message:'请输入内容'});
                return false;
            }
            if(that.cate.cid == '' || that.cate.cid == undefined){
                that.$dialog.alert({title:'错误信息',message:'请选择版块'});
                return false;
            }
            if(that.tag == ''){
                that.$dialog.alert({title:'错误信息',message:'请选择标签'});
                return false;
            }
            if(that.images.length>9){
                that.$dialog.alert({title:'错误信息',message:'最多上传9张图片'});
                return false;
            }
            let imageStr = '';
            for(var i=0;i<that.images.length;i++){
                if(i==0){
                    imageStr = that.images[i].content;
                }else{
                    imageStr += "###" + that.images[i].content;
                }
            }
            var data = {
                cityID:that.config.CITYID,
                token:user.token,
                content:that.content,
                images:imageStr,
                cid:that.cate.cid,
                tag:that.tag
            };
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/V1/chat/submit",data).then(result => {
                let res = result.data;
                this.$toast.clear();
                if (res.code == 0) {
                    that.content='';
                    that.cate=[];
                    that.tag='';
                    that.images=[];
                    that.show=true;
                    this.$dialog.alert({title:'系统信息',message:res.desc}).then(() => {
                        this.$router.push({path:'/chat',query:{token:this.token}});   
                    });
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
.wrap{background: #fff; height: 100vh; width: 100%;}
.text{border: 0; padding: 10px; font-size: 14px; width: 100%; box-sizing: border-box; min-height: 20vh}
.images-list{ padding: 10px; clear: both; overflow: hidden;}
.photo{background: #f1f1f1; width: 60px; height: 60px; text-align: center; line-height: 60px; float: left; margin-right: 10px; margin-bottom: 10px; overflow: hidden; position: relative;}
.del{position: absolute; right: 0; top: 0; background:rgba(0, 0, 0, 0.8); color: #fff;}
.cam{font-size: 30px; line-height: 60px; color: #ccc}
.photo img{display: block; width: 100%}
.btn{padding: 10px; position: fixed; bottom: 20px; left: 0; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}

.quick{clear: both; overflow: hidden; margin-bottom: 30px;}
.quick li{float: left; width:20%; text-align: center;font-size: 12px; padding: 10px 0}
.quick li img{display: block; margin: auto; height: 40px}

.tag{clear: both; margin-bottom: 30px; overflow: hidden; padding-left: 10px; padding-top: 20px}
.tag li{float: left; margin-right: 10px; margin-bottom: 10px}
</style>

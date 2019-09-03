<template>
    <div class="wrap">
        <van-nav-bar title="发布话题" left-arrow @click-left="onClickLeft"></van-nav-bar>
        
        <textarea class="text" placeholder="请输入您要发布的内容" v-model="content"></textarea>

        <div class="images-list">
            <div v-for="(vo,index) in images" :key="index" class="photo">
                <img :src="vo.content">
                <van-icon class="del" name="cross" @click="delImg(index)"/>
            </div>

            <van-uploader v-show="show" :after-read="onRead" class="photo" multiple>
                <van-icon class="cam" name="photograph"/>
            </van-uploader>
        </div>

        <van-cell title="版块(选填)" is-link arrow-direction="down" :value="cate.name" @click="clickShowCate"/>
        <van-cell title="标签(选填)" is-link arrow-direction="down" @click="clickShowTag">
            <template>
                <span class="custom-text" v-for="(vo,index) in tag" :key="vo.id">{{vo.name}}</span>
            </template>
        </van-cell>
        <van-cell-group>
            <van-switch-cell v-model="checked" title="公开" active-color="#7507c2"/>
        </van-cell-group>
        
        <div class="btn">
            <van-button size="large" round class="my-btn" @click="submit">确认发布</van-button>
        </div>

        <van-popup v-model="cateShow" position="bottom">
            <div class="quick">
                <li v-for="vo in cateArr" :key="vo.cid" @click="onSelectCate(vo)"><p>{{vo.name}}</p></li>
            </div>
        </van-popup>
        <van-popup v-model="tagShow" position="bottom">
            <div class="tag">
                <div class="hd">最多可选两个标签</div>
                <div class="bd">
                    <li v-for="vo in tagArr" :key="vo.cid" @click="onSelectTag(vo)"><van-tag plain size="large" :color="vo.value">{{vo.name}}</van-tag></li>
                </div>
                <div class="hd">已选标签</div>
                <div class="fd">
                    <li v-for="(vo,index) in tag" :key="vo.id">
                        <span>{{vo.name}}<i @click="delTag(vo,index)">X</i></span>                        
                    </li>
                </div>
                <div class="ad">
                    <div class="selectBtn" @click="confirmTag">选好了</div>                    
                </div>
            </div>
        </van-popup>
    </div>
</template>

<script>
import user from './auth'; // permission control
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
            tag:[],
            images:[],
            checked:true,
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
                    console.log(file);
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
        onSelectTag(info){
            if(this.tag.length<2){
                var flag = true;
                for(var i=0 ; i<this.tag.length; i++){
                    if(this.tag[i]['id']==info.id){
                        flag = false;
                        break;
                    }
                }
                if(flag){
                    this.tag.push(info);
                }
            }
        },
        delTag(index){
            this.tag.splice(index, 1);
        },
        confirmTag(value){
            if(this.tag.length>0){
                this.tagShow = false;
            }            
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
            /* if(that.cate.cid == '' || that.cate.cid == undefined){
                that.$dialog.alert({title:'错误信息',message:'请选择版块'});
                return false;
            }
            if(that.tag.length==0){
                that.$dialog.alert({title:'错误信息',message:'请选择标签'});
                return false;
            } */
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
            let tag = '';
            for(var i=0;i<that.tag.length;i++){
                if(i==0){
                    tag = that.tag[i].name+'|'+that.tag[i].value;
                }else{
                    tag += "," + that.tag[i].name+'|'+that.tag[i].value;
                }
            }
            var data = {
                cityID:that.config.CITYID,
                token:user.token,
                content:that.content,
                images:imageStr,
                cid:that.cate.cid,
                tag:tag,
                type:1
            };
            if(that.checked){
                data.open=1;
            }else{
                data.open=0;
            }
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
.wrap >>> .van-nav-bar .van-icon {color: #7507c2;}
.wrap{background: #fff; height: 100vh; width: 100%;}
.text{border: 0; padding: 10px; font-size: 14px; width: 100%; box-sizing: border-box; min-height: 20vh}
.images-list{ padding: 10px; clear: both; overflow: hidden;}
.photo{background: #f1f1f1; width: 60px; height: 60px; text-align: center; line-height: 60px; float: left; margin-right: 10px; margin-bottom: 10px; overflow: hidden; position: relative;}
.del{position: absolute; right: 0; top: 0; background:rgba(0, 0, 0, 0.8); color: #fff;}
.cam{font-size: 30px; line-height: 60px; color: #ccc}
.photo img{display: block; width: 100%}
.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #7507c2; color: #fff;}

.quick{clear: both; overflow: hidden; padding:20px;}
.quick li{float: left;text-align: center;font-size: 12px; padding:5px 10px; border:1px #dbdbdb solid; border-radius:14px; margin-right: 10px; margin-bottom: 10px}
.quick li img{display: block; margin: auto; height: 40px}

.tag{clear: both; margin-bottom: 30px; overflow: hidden; padding-left: 10px;}
.tag .hd{color: #999; clear: both; overflow: hidden; font-size: 12px; line-height: 40px;}
.tag .bd{clear: both; overflow: hidden;}
.tag .bd li{float: left; margin-right: 10px; margin-bottom: 10px}
.tag .fd{clear: both; overflow: hidden;}
.tag .fd li{margin-bottom: 10px; clear: both; overflow: hidden;}
.tag .fd li span{border:1px #dbdbdb solid; line-height: 26px; height: 26px; display: block; float: left; border-radius: 13px; font-size: 14px; padding-left:10px; padding-right: 3px;}
.tag .fd li span i{background: #ccc; color: #fff; font-size: 12px; line-height: 20px; width: 20px; border-radius: 50%; text-align: center; display:inline-block; font-style: normal; margin-left:10px}
.tag .ad{clear: both; overflow: hidden;}
.tag .ad .selectBtn{background: #7507c2; color: #fff; width: 80px; margin: auto; line-height: 40px; border-radius: 20px; text-align: center; font-size: 14px}
.custom-text{padding-left: 5px;}
</style>

<template>
    <div class="wrap">
        <van-nav-bar title="新增地址" left-arrow @click-left="onClickLeft"/>

        <van-field
            v-model="formData.name"
            clearable
            label="姓名"
            placeholder="收货人姓名"
        />
        <van-field
            v-model="formData.mobile"
            clearable
            label="电话"
            placeholder="收货人手机号码"
        />
        <van-field
            v-model="area"
            clearable
            label="地区"
            @click="onClickArea"
            placeholder="选择省/市/区"
        />
        <van-field
            v-model="formData.address"
            clearable
            label="详细地址"
            placeholder="街道门牌、楼层房间号等信息"
        />
        <van-field
            v-model="formData.sn"
            clearable
            label="身份证号码"
            placeholder="选填"
        />
        <div class="sn">
            <li>
                <van-uploader
                    :after-read="onReadFront"
                    accept="image/gif, image/jpeg, image/png"
                    style="width:100%">
                    <div class="face" v-if="formData.front!=''"><img :src="formData.front" /></div>
                    <div class="face" v-else=""><img src="../../assets/image/sn1.png" /></div>
                </van-uploader>                
            </li>
            <li>
                <van-uploader
                    :after-read="onReadBack"
                    accept="image/gif, image/jpeg, image/png"
                    style="width:100%">
                    <div class="face" v-if="formData.back!=''"><img :src="formData.back" /></div>
                    <div class="face" v-else=""><img src="../../assets/image/sn2.png" /></div>
                </van-uploader>
            </li>
        </div>        
        <van-switch-cell v-model="checked" title="设为默认地址" />

        <div class="btn">
            <van-button size="large" class="my-btn" @click="onSave">保存</van-button>
        </div>

        <van-popup v-model="show" position="bottom">
        <van-area :area-list="areaList" @confirm="onConfirm" @cancel="onCancel"/>
        </van-popup>
    </div>
</template>

<script>
import area from "../../area.js";
import user from '../chat/auth'
export default {
    data() {
        return {
            areaList:area,
            area:'',
            formData:{
                name:'',
                mobile:'',
                province:'',
                city:'',
                area:'',
                address:'',
                sn:'',
                front:'',
                back:'',
            },
            checked:false,
            show:false,
            front :''
        };
    },
    watch:{
    	$route(to,from){
		    if (to.path=='/store/addressAdd') {
                this.formData = {
                    front:'',
                    back:''
                }
		    }
		}
    },
    created() {

    },
    methods: {
        onClickLeft() {
            this.$router.go(-1);
        },
        onClickArea(){
            this.show = true;
        },
        onConfirm(value){
            this.area = value[0]['name']+" "+value[1]['name']+" "+value[2]['name'];
            this.formData.province = value[0]['name'];
            this.formData.city = value[1]['name'];
            this.formData.area = value[2]['name'];
            this.show = false;
        },
        onCancel(){
            this.show = false;
        },
        onReadFront(file){
            var that = this;
            that.compressImage(file,800,0,function(res){                    
                file.content = res;
                that.formData.front = file.content;         
            });           
        },
        onReadBack(file){
            var that = this;
            that.compressImage(file,800,0,function(res){                    
                file.content = res;
                that.formData.back = file.content;         
            });           
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
        onSave(content) {
            var that = this;
            if (that.formData.name == "") {
                that.$toast('请输入真实姓名');
                return false;
            }
            if (that.formData.mobile == "") {
                that.$toast('请输入手机号码');
                return false;
            }
            if(!that.config.checkCnMobile(that.formData.mobile)){
                that.$toast('手机号码格式错误');
                return false;
            }
            if (that.formData.province == "" || that.formData.city == "" || that.formData.area == "") {
                that.$toast('请选择地区');
                return false;
            }
            if (that.formData.address == "") {
                that.$toast('请输入详细地址');
                return false;
            }
            if(that.checked){
                that.formData.def = 1;
            }
            that.formData.token = user.token;
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/v1/store/addressPub",that.formData).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    this.$dialog.alert({title:'提示',message:res.desc});
                    this.$router.push({path:'/store/address',query:{token:user.token}});
                }else if(res.code==999) {
                    that.$dialog.alert({title:'错误信息',message:res.desc}).then(() => {
                        window.location.href = 'app://login';
                    });
                }else{
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #fff;}
.van-nav-bar {background-color: #05c1af; color: #fff}
.van-nav-bar__title{color: #fff}
.van-nav-bar__text{color: #fff}
.sn{clear: both; overflow: hidden;}
.sn li{float: left; width: 40%;padding: 20px; box-sizing: border-box}
.btn{padding: 10px; width: 100%; box-sizing: border-box}
.my-btn{background: #05c1af; color: #fff;}
</style>

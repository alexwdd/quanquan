<template>
    <div class="wrap">
        <van-nav-bar title="举报" left-arrow @click-left="onClickLeft"/>
   
        <div class="write">
            <p>联系方式</p>
            <van-field
                v-model="formData.content"
                type="textarea"
                rows="5"
                autosize
            />
            <p>补充说明</p>
            <van-field
                clearable
                placeholder='输入您的邮箱，我们会尽快联系您'
                v-model="formData.contact"
            />        
        </div>
        <div style="padding: 10px;">
            <van-button class="my-btn" size="large" @click="submit">提交</van-button>
        </div>
    </div>
</template>

<script>
import user from './auth'
export default {
    data() {
        return {
            infoID:'',
            formData:{}
        };
    },
    watch: {
        $route(to) {
            if (to.name == "jubao") {
                this.init();
            }
        }
    },
    created() { 
    },
    methods: {   
        init(){
            this.formData = {};
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        submit(){//关注
            var that = this;            
            if(that.formData.content==''){
                that.$dialog.alert({title:'错误信息',message:'请输入举报内容'});
                return false;
            }
            if(that.formData.contact==''){
                that.$dialog.alert({title:'错误信息',message:'请输入联系方式'});
                return false;
            }
            that.formData.infoID = that.$route.params.id
            this.$toast.loading({mask: true,duration:0});
            that.$http.post("/v1/chat/feedback",that.formData).then(result => {
                this.$toast.clear();
                let res = result.data;
                if (res.code == 0) {              
                    this.$dialog.alert({title:'提示',message:res.desc});
                    that.init();
                } else {
                    that.$dialog.alert({title:'错误信息',message:res.desc});
                }
            });
        }
    }
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.write{padding: 10px;}
.write p{font-size: 14px; color: #999; margin: 10px 0;}
.my-btn{color: #fff;background-color: #05c1af;border: 1px solid #05c1af;}
</style>

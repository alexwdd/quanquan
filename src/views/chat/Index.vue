<template>
    <div class="wrap">
        <van-nav-bar fixed left-arrow @click-right="onClickRight">
            <div slot="title">
                <div class="tab">
                    <li class="active">话题</li>
                    <li @click="focus">关注</li>
                </div>
            </div>
            <van-icon name="photograph" slot="right"/>
        </van-nav-bar>

        <div class="topCate">
            <div class="cateTab">
                <van-tabs color="#05c1af" v-model="cateActive">
                    <van-tab v-for="vo in cate" :title="vo.title" :key="vo.id">
                        <div class="tab-title" slot="title" @click="changeCate(vo.id)">{{vo.title}}</div>
                    </van-tab>
                </van-tabs>
            </div>
            <div class="cateBar" @click="show"><van-icon name="bars"></van-icon></div>
        </div>

        <div class="cateList" v-show="cateShow">
            <div class="hd">全部分类 <van-icon name="cross" @click="show"></van-icon></div>
            <swipe class="my-swipe" :auto="0">
				<swipe-item v-for="vo in quick">
                    <div class="quick">
                        <li v-for="f in vo" :key="f.id" @click="changeCate1(f)"><img :src="f.icon"><p>{{f.title}}</p></li>
                    </div>
                </swipe-item>
			</swipe>               
        </div>

        <div style="height:92px"></div>

        <div class="chat">
            <div class="user">
                <div class="face"><img src="https://img.52z.com/upload/news/image/20180213/20180213062638_50905.jpg"></div>
                <div class="name"><p>小雨点</p><span>3分钟前</span></div>
                <div class="focus">关注</div>
            </div>
            <div class="say">阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬</div>
            <div class="photo single">
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
            </div>
            <div class="action">
                <li><van-icon class-prefix="icon" name="dianzan" /> 10</li>
                <li><van-icon class-prefix="icon" name="pinglun1" /> 10</li>
                <li><van-icon class-prefix="icon" name="fenxiang" /></li>
            </div>
        </div>
        <div class="chat">
            <div class="user">
                <div class="face"><img src="https://img.52z.com/upload/news/image/20180213/20180213062640_13061.jpg"></div>
                <div class="name"><p>小雨点</p><span>3分钟前</span></div>
                <div class="focus focused">已关注</div>
            </div>
            <div class="say">阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬</div>
            <div class="photo">
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
                <li><img src="https://img.52z.com/upload/news/image/20180213/20180213062639_34859.jpg"></li>
            </div>
        </div>
        <div class="chat">
            <div class="user">
                <div class="face"><img src="https://img.52z.com/upload/news/image/20180213/20180213062640_13061.jpg"></div>
                <div class="name"><p>小雨点</p><span>3分钟前</span></div>
                <div class="focus">关注</div>
            </div>
            <div class="say">阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬阿斯蒂芬阿萨德阿斯蒂芬阿斯蒂芬阿斯蒂芬</div>
            <div class="photo"></div>
        </div>
        
    </div>
</template>

<script>
import user from './auth'
export default {
    data() {
        return {
            token:'',

            cateShow:true,
            cate:[{title:'全部',id:0,checked:true}],
            quick:[],
            cateActive:1,
        };
    },
    watch: {

    },
    created() {        
        if(user.status==true){
            this.token = user.token;
        }
    },
    methods: {
        onClickRight(){
            this.$router.push({'path':'/write',query:{token:this.token}});
        },
        show(){
            this.cateShow = !this.cateShow;
        },
        focus(){
            this.$router.push({'path':'/focus',query:{token:this.token}});
        }
    },
    mounted:function(){
        this.show();
    },
};
</script>
<style scoped>
.wrap >>> .van-nav-bar .van-icon {color: #05c1af;}
.tab{clear: both;overflow: hidden;}
.tab li{display: inline-block; font-size: 14px; padding:0 10px;}
.tab li.active{color: #05c1af;}

.topCate{position: fixed; top: 46px; width: 100%; display: flex;background: #fff}
.cateTab{flex: 1}
.cateBar{width: 40px; height: 44px; text-align: center}
.cateBar i{line-height: 44px;color: #05c1af;}
.cateList{position: fixed; top:46px; width: 100%; z-index: 999; background: #fff}
.cateList .hd{height: 44px; line-height: 44px; text-align: center; position: relative; background: #05c1af; color: #fff}
.cateList i{position: absolute;right: 5px; top: 15px}
.my-swipe{height: 250px;width: 100vw; border-bottom: 1px #f1f1f1 solid}
.wrap >>> .mint-swipe-indicator.is-active {background: #f00;}
.quick{clear: both; overflow: hidden;}
.quick li{float: left; width:20%; text-align: center;font-size: 12px; padding: 10px 0}
.quick li img{display: block; margin: auto; height: 40px}
.custom-indicator {position: absolute;left: 0px;bottom:10px;width: 100%;height: 20px;text-align: center}
.custom-indicator li{display: inline-block; padding: 0 3px}
.custom-indicator li span{display: block; width: 6px; height: 6px; border-radius:3px; background: #ccc}
.custom-indicator li span.active{background: #f60; width: 14px}

.chat{background: #fff; clear: both; overflow: hidden; border-bottom: 1px #f1f1f1 solid; padding: 10px 0}
.chat .user{clear: both; margin-bottom: 10px; overflow: hidden; padding: 0 10px}
.chat .user .face{float: left; margin-right: 10px}
.chat .user .face img{display: block; width: 50px; height: 50px; border-radius: 50%;}
.chat .user .name{float: left;font-size: 12px; line-height:20px; padding: 5px 0}
.chat .user .name p{ margin: 0;}
.chat .user .name span{color: #999}
.chat .user .focus{float: right; font-size: 12px; height: 24px; line-height: 24px; border-radius: 12px; background-color: #c00; width: 60px; text-align: center; color: #fff; margin-top: 10px}
.chat .user .focused{background-color: #ccc; color: #fff;}
.chat .say{clear: both; font-size: 14px; margin-bottom: 10px; padding: 0 10px}
.chat .photo{clear: both; padding-left: 10px}
.chat .photo li{float: left; width: 33.333%; padding-right: 10px; box-sizing: border-box; padding-bottom: 10px}
.chat .photo li img{display: block}
.chat .single li{width: 60%}
.chat .action{clear: both;}
.chat .action li{float: left; width: 33.333%; text-align: center; font-size: 12px; line-height: 20px; color: #999}
.chat .action li i{font-size: 16px; display: inline;}
</style>

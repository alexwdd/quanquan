<template>
    <div class="wrap" id="wrap">
        <van-nav-bar fixed :title="cateName" left-arrow @click-left="onClickLeft"/>

        <div class="paramMenu">
            <li @click="showSubway">地铁站 <van-icon name="arrow-down" /></li>
            <li @click="showTypes">出租类型 <van-icon name="arrow-down" /></li>
        </div>

        <div class="paramBox" v-show="param1">
            <div class="subwayList">
                <div class="left">				
                    <li :class="{active:vo.checked}" v-for="vo in subwayList" @click="changeSubway(vo)">{{vo.text}}<van-icon name="arrow" /></li>
                </div>
                <div class="right">
                    <li :class="{active:vo.checked}" v-for="vo in line" @click="changeLine(vo)">{{vo.text}}</li>
                </div>
            </div>
            <div class="action">
                <li @click="resetSubway">重置</li>
                <li class="active" @click="search">确认</li>
            </div>
        </div>

        <div class="paramBox" v-show="param2">
            <div class="typeList">
                <li :class="{active:vo.checked}" v-for="vo in typeList" @click="changeType(vo)">{{vo.name}}</li>
            </div>
            <div class="action">
                <li @click="resetType">重置</li>
                <li class="active" @click="search">确认</li>
            </div>
        </div>
        <div class="masker" v-show="masker" @click="closeAll"></div>

        <div style="height:92px"></div>

        <van-list v-model="loading" :finished="finished" finished-text="没有更多了" @load="onLoad">
            <van-row class="news" v-for="vo in info" :key="vo.articleid">
                <van-col span="8"><div class="img" @click="detail(vo.articleid)"><img v-lazy="vo.thumb_s"></div></van-col>
                <van-col span="16">
                    <div class="info" @click="detail(vo.articleid)">
                        <div class="title">
                        <h1>{{vo.title}}</h1>
                        </div>
                        <div class="address"><van-icon class-prefix="icon" name="weizhi" /> {{vo.address|empty}}</div>
                        <div class="bottom">
                            <div class="price"><van-icon class-prefix="icon" name="meiyuan" /> {{vo.price}}</div>
                            <div class="date">
                            {{vo.createTime}}
                            </div>
                        </div>
                    </div>
                </van-col>
            </van-row>
        </van-list>
    </div>
</template>

<script>
import Vue from 'vue';
import { Lazyload } from 'vant';
Vue.use(Lazyload,{
    loading:'../static/image/default_320.jpg'
});
export default {
    data() {
        return {
            cateName:'租房',
            sort:0,
            info:[],
            loading: false,
            finished: false,
            canPost:true,
            type:'zf',
            page:1,
            param1:false,
			param2:false,
			masker:false,	
			subwayList:[],
			typeList:[
				{name:'不限',checked:true},
				{name:'床位出租',checked:false},
				{name:'普通房',checked:false},
				{name:'主人房',checked:false},
				{name:'保姆房',checked:false},
				{name:'工作室',checked:false},
				{name:'车库',checked:false},
				{name:'储藏室',checked:false},
				{name:'厅房/隔间',checked:false}
			],
			line:[],
			subwayStr:'',
			typeStr:'',
        };
    },
    watch: {
        $route(to) {
            if (to.name == "list") {
                this.info = [];
                this.page = 1;
                this.sort = 0;
                this.onLoad();
            }
        },
        masker(val) {			
            let h = document.body.clientHeight;
            if(val){
                document.getElementById("wrap").style.height=(h-46)+"px";
            }else{
                document.getElementById("wrap").style.height="auto";
            }
        }
    },
    created() {
        var that = this;
        let data = {cityID:this.config.CITYID};
        that.$http.post("V1/Category/subway",data).then(result => {
            let res = result.data;
            if (res.code == 0) {
                // 加载状态结束
                data = res.body.subway;
                for(var i in data){
                    for(var j in data[i]['children']){
                        data[i]['children'][j]['checked'] = false;
                    }
                    data[i]['checked'] = false;
                }
                data[0]['checked'] = true;
                that.subwayList = data;	
                that.line = data[0]['children'];
            }else{
                that.$dialog.alert({title:'错误信息',message:res.desc});
            }
        });
    },
    methods: {
        closeAll(){
            this.param1 = false;
            this.param2 = false;
            this.masker = false;
        },
        showSubway(){
            if (this.param1){
                this.param1 = false;
                this.param2 = false;
                this.masker = false;
            }else{
                this.param1 = true;
                this.param2 = false;
                this.masker = true;
            }				
        },
        showTypes(){
            if (this.param2){
                this.param1 = false;
                this.param2 = false;
                this.masker = false;
            }else{
                this.param1 = false;
                this.param2 = true;
                this.masker = true;
            }
        },
        changeSubway(e){
            this.line = e.children;
            for(var i in this.subwayList){			
                if (this.subwayList[i]['value']==e.value){
                    this.subwayList[i]['checked'] = true;
                }else{
                    this.subwayList[i]['checked'] = false;
                }
            }
        },
        changeLine(e){
            var data = this.subwayList;
            this.subwayStr = '';
            for(var i in data){
                for(var j in data[i]['children']){
                    if (data[i]['children'][j]['value']==e.value){
                        data[i]['children'][j]['checked'] = !data[i]['children'][j]['checked'];
                    }
                    if (data[i]['children'][j]['checked']){
                        if (this.subwayStr==''){
                            this.subwayStr = data[i]['children'][j]['text'];
                        }else{
                            this.subwayStr += ','+data[i]['children'][j]['text'];
                        }
                    }
                }
            }
        },
        changeType(e){
            var data = this.typeList;	
            this.typeStr = '';			
            for(var i in data){
                if (data[i]['name']==e.name){
                    data[i]['checked'] = !data[i]['checked'];
                }else{
                    data[i]['checked'] = false
                }
                if (data[i]['checked']){
                    this.typeStr = data[i]['name'];
                }
            }
        },
        resetSubway(){
            var data = this.subwayList;
            this.subwayStr = '';
            for(var i in data){
                for(var j in data[i]['children']){					
                    data[i]['children'][j]['checked'] = false;
                }
            }
        },
        resetType(){
            var data = this.typeList;
            this.typeStr = '';
            for(var i in data){
                data[i]['checked'] = false;
            }
        },
        search(){
            this.closeAll();
            this.info = [];
            this.page = 1;
            this.onLoad();
        },
        onClickLeft() {
            this.$router.go(-1);
        },
        detail(infoid){
            let type = this.type;
            this.$router.push({name:'detail',params:{type: type,id:infoid}})
        },
        onLoad() {
            var that = this;            
            if(!that.canPost){
                return false;
            }
            that.canPost = false;
            let data = {
                sort : that.sort,
                cityID : that.config.CITYID,
                type : that.type,
                page : that.page,
            };
            if (that.typeStr!='' && that.typeStr!='不限'){
                data.singleType = that.typeStr;
            }
            if (that.subwayStr!=''){
                data.subway = that.subwayStr;
            }
            that.$http.post("V3/weixin/infolist",data).then(result => {
                let res = result.data;
                if (res.code == 0) {
                    // 加载状态结束
                    that.loading = false;
                    that.canPost = true;                 
                    that.info = that.info.concat(res.body.data);  
                    that.page++;          
                    if(res.body.next==0){
                        that.finished = true;
                    }
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
.wrap{overflow: hidden;}
.topCate{position: fixed; top: 46px; width: 100%;}
.news{clear: both; overflow: hidden; display: flex; padding: 10px; border-bottom:1px #dbdbdb dashed;background:#fff}
.news .info{padding-left:5px}
.news .info h1{font-size: 15px;text-overflow: -o-ellipsis-lastline;overflow: hidden;text-overflow: ellipsis;display: -webkit-box;-webkit-line-clamp: 2;-webkit-box-orient: vertical;}
.news .info .title{height:40px; margin-bottom: 10px}
.news .info .address{ overflow:hidden;  text-overflow:ellipsis; white-space:nowrap; width: 100%; font-size: 14px;color: #999}
.news .info .bottom .price{float: left; font-size: 14px;color: #7507c2}
.news .info .bottom .date{font-size: 12px; text-align: right; color: #999; line-height: 20px; float: right;}
.news .info i{color: #7507c2}

/*tab菜单*/
.paramMenu{text-align: center; background: #fff; height: 44px; line-height: 44px; position: fixed; left: 0; top:46px; width: 100%;z-index: 999;}
.paramMenu li{float: left; width: 50%; font-size: 14px; color: #999}
.paramMenu li i{font-size: 12px}
.paramBox{position: fixed; left: 0; top: 44px; width: 100%; background: #fff;z-index: 999;}
.subwayList{clear: both; overflow: hidden;}
.subwayList .left{float: left; width: 40%; text-align: center; overflow: auto;max-height: 200px;}
.subwayList .left li{line-height: 40px; font-size: 14px;position: relative;}
.subwayList .left li.active{border-left: 3px #7507c2 solid}
.subwayList .left li i{right: 15px;content:"\F00A";position: absolute;top: 50%;display: inline-block;
    color: #bbb;
    text-decoration: none;
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
    -webkit-font-smoothing: antialiased;}
.subwayList .left li.active i{color:#7507c2}
.subwayList .right{float: left; width:60%; overflow: auto;max-height: 200px;}
.subwayList .right li{line-height: 40px;font-size: 14px;}
.subwayList .right li.active{color: #7507c2}
.action{clear: both; height: 40px; width: 100%; line-height: 40px; border-top: 1px #f1f1f1 solid}
.action li{float: left; width: 50%; text-align: center;}
.action li.active{background: #7507c2; color: #fff;}
.masker{width: 100%; height:100%;position: fixed;left: 0; top: 0; background: rgba(0,0,0,0.2); z-index: 1}
.typeList{clear: both;}
.typeList li{width: 33.333%; float: left; line-height: 40px; font-size: 14px; text-align: center;}
.typeList li.active{color: #7507c2}
</style>

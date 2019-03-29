<template>
    <div class="container-water-fall">
        <waterfall
            :col="col"
            :width="itemWidth"
            :gutterWidth="gutterWidth"
            :data="data"
        >
            <template>
                <div class="cell-item" v-for="(item,index) in data">
                    <img :src="item.thumb_b">
                    <div class="item-body">
                        <div class="item-desc">{{item.title}}</div>
                        <div class="item-footer">
                            <div class="avatar" :style="{backgroundImage : `url(${item.avatar})` }"></div>
                            <div class="name">{{item.user}}</div>
                            <div class="like" :class="item.liked?'active':''">
                                <i></i>
                                <div class="like-total">{{item.liked}}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </template>
        </waterfall>
    </div>
</template>

<script>
import Vue from "vue";
import waterfall from "vue-waterfall2";
Vue.use(waterfall);
export default {
    data() {
        return {
            data: [],
            col: 2,
            page:1
        };
    },
    computed: {
        itemWidth() {
            //return 138 * 0.5 * (document.documentElement.clientWidth / 375); //rem布局 计算宽度
            return document.documentElement.clientWidth / 2 - 5;
        },
        gutterWidth() {
            //return 9 * 0.5 * (document.documentElement.clientWidth / 375); //rem布局 计算x轴方向margin(y轴方向的margin自定义在css中即可)
            return 10;
        }
    },
    created(){ 
        var that = this; 
        let data = {
            cityID : that.config.CITYID,
            type : 'sp',
            page : that.page,
        };
        that.$http.post("V3/weixin/infolist",data).then(result => {
            let res = result.data;
            if (res.code == 0) {              
                that.data = that.data.concat(res.body.data);
                that.page++;          
            }else{
                that.$dialog.alert({title:'错误信息',message:res.desc});
            }
        });

    },
    methods: {
        scroll(scrollData) {
            console.log(scrollData);
        },
        mix() {
            this.$waterfall.mix();
        },
        switchCol(col) {
            this.col = col;
            console.log(this.col);
        },
        loadmore(index) {
            this.data = this.data.concat(this.data);
        }
    }
};
</script>

<style>
</style>

import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import List from './views/List.vue'
import Detail from './views/Detail.vue'
import News from './views/News.vue'
import View from './views/View.vue'
import Job from './views/Job.vue'
import House from './views/House.vue'
import Commend from './views/Commend.vue'

import Test from './views/Test.vue'



Vue.use(Router)

export default new Router({
    mode: 'history',
    base: process.env.BASE_URL,
    routes: [
        {
            path: '/',
            name: 'home',
            meta:{index:0},
            component: Home
        },
        {
            path: "/news",
            name: "news",
            meta:{index:1},
            component: News
        },
        {
            path: "/view/:id",
            name: "view",
            meta:{index:2},
            component: View
        },
        {
            path: "/list/:type",
            name: "list",
            meta:{index:1},
            component: List
        },
        {
            path: "/job",
            name: "job",
            meta:{index:1},
            component: Job
        },
        {
            path: "/house",
            name: "house",
            meta:{index:1},
            component: House
        },
        {
            path: "/detail/:type/:id",
            name: "detail",
            meta:{index:2},
            component: Detail
        },
        {
            path: "/commend",
            name: "commend",
            meta:{index:1},
            component: Commend
        },
        {
            path: "/test",
            name: "test",
            meta:{index:1},
            component: Test
        },
    ]
})

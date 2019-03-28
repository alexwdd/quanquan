import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import List from './views/List.vue'
import Detail from './views/Detail.vue'
import News from './views/News.vue'
import View from './views/View.vue'


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
            path: "/detail/:type/:id",
            name: "detail",
            meta:{index:2},
            component: Detail
        },
    ]
})

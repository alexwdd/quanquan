import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import List from './views/List.vue'
import Detail from './views/Detail.vue'
import Cate from './views/Cate.vue'
import News from './views/News.vue'
import View from './views/View.vue'
import Job from './views/Job.vue'
import House from './views/House.vue'
import Commend from './views/Commend.vue'

import Chat from './views/chat/Index.vue'
import Focus from './views/chat/Focus.vue'
import Write from './views/chat/Write.vue'
import Comment from './views/chat/Comment.vue'
import MyChat from './views/chat/MyChat.vue'
import Reply from './views/chat/Reply.vue'
import More from './views/chat/More.vue'
import ChatSearch from './views/chat/Search.vue'

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
            path: "/cate/:cid",
            name: "cate",
            meta:{index:1},
            component: Cate
        },
        {
            path: "/news/:cid",
            name: "news",
            meta:{index:2},
            component: News
        },
        {
            path: "/view/:id",
            name: "view",
            meta:{index:3},
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
            meta:{index:2},
            component: Commend
        },
        {
            path: "/chat",
            name: "chat",
            meta:{index:1},
            component: Chat
        },
        {
            path: "/focus",
            name: "focus",
            meta:{index:2},
            component: Focus
        },
        {
            path: "/write",
            name: "write",
            meta:{index:3},
            component: Write
        },
        {
            path: "/comment",
            name: "comment",
            meta:{index:3},
            component: Comment
        },
        {
            path: "/mychat",
            name: "mychat",
            meta:{index:2},
            component: MyChat
        },
        {
            path: "/reply",
            name: "reply",
            meta:{index:2},
            component: Reply
        },
        {
            path: "/more",
            name: "more",
            meta:{index:3},
            component: More
        },
        {
            path: "/chat/search",
            name: "chatSearch",
            meta:{index:3},
            component: ChatSearch
        },



        {
            path: "/test",
            name: "test",
            meta:{index:1},
            component: Test
        },
    ]
})

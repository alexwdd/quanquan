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
import Jubao from './views/chat/Jubao.vue'
import User from './views/chat/User.vue'

//代购商城
import Store from './views/store/Index.vue'
import StoreAddress from './views/store/Address.vue'
import StoreAddressAdd from './views/store/AddressAdd.vue'
import StoreAddressEdit from './views/store/AddressEdit.vue'
import StoreDetail from './views/store/Detail.vue'
import StoreCart from './views/store/Cart.vue'



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
            path: "/chat/focus",
            name: "focus",
            meta:{index:2},
            component: Focus
        },
        {
            path: "/chat/write",
            name: "write",
            meta:{index:3},
            component: Write
        },
        {
            path: "/chat/comment",
            name: "comment",
            meta:{index:3},
            component: Comment
        },
        {
            path: "/chat/mychat",
            name: "mychat",
            meta:{index:2},
            component: MyChat
        },
        {
            path: "/chat/reply",
            name: "reply",
            meta:{index:2},
            component: Reply
        },
        {
            path: "/chat/more",
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
            path: "/chat/jubao/:id",
            name: "jubao",
            meta:{index:9},
            component: Jubao
        },
        {
            path: "/chat/user",
            name: "user",
            meta:{index:9},
            component: User
        },



        {path: "/store",name: "store",meta:{index:1},component: Store},
        {path: "/store/address",name: "storeAddress",meta:{index:1},component: StoreAddress},
        {path: "/store/addressAdd",name: "storeAddressAdd",meta:{index:2},component: StoreAddressAdd},
        {path: "/store/addressEdit/:id",name: "storeAddressEdit",meta:{index:2},component: StoreAddressEdit},
        
        {path: "/store/detail/:id",name: "storeDetail",meta:{index:2},component: StoreDetail},
        {path: "/store/cart",name: "storeCart",meta:{index:2},component: StoreCart},
    ]
})

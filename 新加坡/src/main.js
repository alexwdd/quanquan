import Vue from 'vue';
import App from './App.vue';
import router from "./router";
import store from "./store";
import config from "./config";
import axios from './httpConfig/http.js'
import Vant from 'vant';
import 'vant/lib/index.css';

Vue.use(Vant);

Vue.config.productionTip = false
Vue.prototype.config = config
Vue.prototype.$http = axios

router.afterEach((to,from,next) => {
	window.scrollTo(0,0);
})

new Vue({
	router,
	store,
	render: h => h(App)
}).$mount('#app')

Vue.filter('empty', function (value) {
	if (value == '' || value == null || value == undefined) {
		return '详情请咨询'
	} else {
		return value
	}
})

Vue.filter('emptyImg', function (value) {
	if (value == '' || value == null || value == undefined) {
		return '../static/image/default_320.jpg'
	} else {
		return value
	}
})
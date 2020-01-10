import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)
export default new Vuex.Store({
	state: {
		token:window.sessionStorage.getItem('token'),
		user:window.sessionStorage.getItem('userinfo'),
	},
	mutations: {
		SET_TOKEN(state,data) {
    		state.token = data;
    		window.sessionStorage.setItem('token', data);
    	},
    	SET_USER(state,data) {
    		state.user = data;
    		window.sessionStorage.setItem('userinfo', data);
    	},
    	SIGN_OUT(state){
    		state.token = '';
    		state.user = [];
    		window.sessionStorage.removeItem('token');
    		window.sessionStorage.removeItem('userinfo');    		
    	}
	},
	actions: {}
})

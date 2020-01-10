/**
 * ajax请求配置
 */
import axios from 'axios'
import apiURL from './api.js'
//import Qs from 'qs'

// axios默认配置
axios.defaults.timeout = 10000;   // 超时时间
axios.defaults.baseURL = apiURL;  // 默认地址

//整理数据
// axios.defaults.transformRequest = function (data) {
// data = JSON.stringify(data);
//   return data;
// };

axios.defaults.transformRequest = function (data) { 
    let ret = '';
    for (let it in data) { 
        ret += encodeURIComponent(it) + '=' + encodeURIComponent(data[it]) + '&' 
    } 
    return ret
}

export default axios;
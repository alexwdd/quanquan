const global = {
    DOMAIN:'http://wx.worldmedia.top/singapore/',
    LOGO:'http://wx.worldmedia.top/singapore/logo.jpg',
    APP_NAME: '新加坡生活圈',
    CITYID: 39,
    SCHEME:'ausSingapore://startapp',
    IOS:'https://itunes.apple.com/cn/app/id1437373175?l=zh&ls=1&mt=8',
    ANDROIDS:'https://play.google.com/store/apps/details?id=com.ldw.singapore',
    DOWNLOAD:'http://www.worldmedia.top/download/singapore.apk',
    //判断是否是微信浏览器的函数
    isWeiXin : function(){
        //window.navigator.userAgent属性包含了浏览器类型、版本、操作系统类型、浏览器引擎类型等信息，这个属性可以用来判断浏览器类型
        var ua = window.navigator.userAgent.toLowerCase();
        //通过正则表达式匹配ua中是否含有MicroMessenger字符串
        if(ua.match(/MicroMessenger/i) == 'micromessenger'){
            return true;
        }else{
            return false;
        }
    },
    isIOS : function(){
        if (navigator.userAgent.match(/(iPhone|iPod|iPad);?/i)) {
            return true;
        }
    },
    isApp : function(){
        //window.navigator.userAgent属性包含了浏览器类型、版本、操作系统类型、浏览器引擎类型等信息，这个属性可以用来判断浏览器类型
        var ua = window.navigator.userAgent.toLowerCase();
        //通过正则表达式匹配ua中是否含有MicroMessenger字符串
        if(ua.match(/AustraliaApp/i) == 'australiaapp'){
            return true;
        }else{
            if(this.getQueryString('isApp')){
                return true;
            }else{
                return false;
            }
        }
    },
    getQueryString: function(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if(r!=null)return  unescape(r[2]); return null;
    },
    checkMobile: function (checkVal) {
        var reg = /^[0-9]{8}$/;
        if (!reg.test(checkVal)) {
            return false;
        } else {
            return true;
        }
    },
    getModelName: function (py) {
        switch (py) {
            case 'tc':
                return '同城活动';
            case 'zf':
                return '租房/卖房';
            case 'sp':
                return '二手商品';
            case 'zp':
                return '招聘/求职';
            case 'esc':
                return '二手车';
            case 'ms':
                return '美食/外卖';
            case 'sh':
                return '生活服务';
            case 'xp':
                return '新品上架';
            case 'news':
                return '时事热点';
            case 'marriage':
                return '征婚';
            default:
                break;
        }
    }
};
export default global
const global = {
    APP_NAME: '阿德莱德眼',
    CITYID: 9,
    IOS:'https://itunes.apple.com/cn/app/id1386824572?l=zh&ls=1&mt=8',
    ANDROIDS:'https://play.google.com/store/apps/details?id=com.ldw.life',

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
                return '同城活动'
                break;
            case 'zf':
                return '租房/卖房'
                break;
            case 'sp':
                return '二手商品'
                break;
            case 'zp':
                return '招聘/求职'
                break;
            case 'esc':
                return '二手车'
                break;
            case 'ms':
                return '美食/外卖'
                break;
            case 'sh':
                return '生活服务'
                break;
            case 'xp':
                return '新品上架'
                break;
            case 'news':
                return '时事热点'
                break;
            default:
                break;
        }
    }
};
export default global
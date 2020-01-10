let user = {
    status : false,
    token : ''
};

let token = GetQueryString('token');
if(token!=''){
    user.status = true;
    user.token = token;
}

function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        return unescape(r[2]);
    return "";
}
export default user
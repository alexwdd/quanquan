let user = {
    status : false,
    token : ''
};

let token = GetQueryString('token');
let agentid = GetQueryString('agentid');
if(token!=''){
    user.status = true;
    user.token = token;
}
if(agentid!=''){
    user.agentid = agentid;
}

function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        return unescape(r[2]);
    return "";
}
export default user
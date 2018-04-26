<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>WhysuMall后台管理系统</title>
    <link rel="Shortcut Icon" href="icon/favicon.ico"/>
    <!-- Meta tag Keywords -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="keywords" content="WhysuMall后台管理系统 v1.0,XMall,XMall购物商城后台管理系统">
    <meta name="description" content="WhysuMall后台管理系统 v1.0，是一款电商后台管理系统，适合中小型CMS后台系统。">

    <script type="text/javascript" src="lib/jquery/jquery-2.1.4.min.js"></script>
    <%--弹出框--%>
    <script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
    <%--验证码--%>
    <script src="whysu/jquery.idcode.js"></script>

    <!--[if lt IE 9]>
    <script type="text/javascript" src="lib/html5shiv.js"></script>
    <script type="text/javascript" src="lib/respond.min.js"></script>
    <![endif]-->

    <link href="static/h-ui/css/H-ui.min.css" rel="stylesheet" type="text/css"/>
    <link href="static/h-ui.admin/css/H-ui.login.css" rel="stylesheet" type="text/css"/>
    <link href="static/h-ui.admin/css/style.css" rel="stylesheet" type="text/css"/>
    <link href="lib/Hui-iconfont/1.0.8/iconfont.css" rel="stylesheet" type="text/css"/>
    <%--弹出框--%>
    <link rel="stylesheet" href="lib/layer/2.4/skin/layer.css"> <!-- Font-Awesome-Icons-CSS -->
    <%--验证码--%>
    <link href="whysu/jquery.idcode.css" rel="stylesheet" type="text/css"/>


    <!--[if IE 6]>
    <script type="text/javascript" src="lib/DD_belatedPNG_0.0.8a-min.js"></script>
    <script>DD_belatedPNG.fix('*');</script>
    <![endif]-->


</head>
<body>
<!---->
<div class="header"></div>
<div class="loginWraper">
    <div id="loginform" class="loginBox">
        <form class="form form-horizontal" action="" method="post">
            <div class="row cl">
                <label class="form-label col-xs-3"><i class="Hui-iconfont">&#xe60d;</i></label>
                <div class="formControls col-xs-8">
                    <input id="username" name="username" type="text" placeholder="用户名" class="input-text size-L">
                </div>
            </div>
            <div class="row cl">
                <label class="form-label col-xs-3"><i class="Hui-iconfont">&#xe60e;</i></label>
                <div class="formControls col-xs-8">
                    <input id="password" name="password" type="password" placeholder="密码" class="input-text size-L">
                </div>
            </div>
            <div class="row cl">
                <div class="formControls col-xs-8 col-xs-offset-3">
                    <input type="text" id="Txtidcode" class="txtVerification" placeholder="请输入验证码" style="padding-left: 6px; line-height: 12px;letter-spacing: 2px;"/>
                    <span id="idcode"></span>
                </div>
            </div>
            <div class="row cl">
                <div class="formControls col-xs-8 col-xs-offset-3">
                    <label for="rememberPwd">
                        <input type="checkbox" name="rememberPwd" id="rememberPwd"/>
                        记住密码
                    </label>
                </div>
            </div>
            <div class="row cl">
                <div class="formControls col-xs-8 col-xs-offset-3">
                    <input id="loginBtn" type="button" class="btn btn-success radius size-L"
                           value="&nbsp;登&nbsp;&nbsp;&nbsp;&nbsp;录&nbsp;">
                    <input id="cancelBtn" type="reset" class="btn btn-default radius size-L"
                           value="&nbsp;取&nbsp;&nbsp;&nbsp;&nbsp;消&nbsp;">
                </div>
            </div>
        </form>
    </div>
</div>
<div class="footer">2018 WhysuMall. All rights reserved | Design by Suwei</div>


<script type="text/javascript">
    $(function () {
        //验证码
        $.idcode.setCode();
        //如果之前勾选了“记住密码”，将信息显示出来
        if(getCookie("userid") != null){
            $("#rememberPwd").attr("checked","checked");
            $("#username").val(getCookie("userid"));
            $("#password").val(getCookie("upwd"));
        }

        $("#loginBtn").click(function () {
            var name = $("#username").val();
            var pass = $("#password").val();
            var code = $("#Txtidcode").val();
            if(name == "" || pass == ""){
                layer.msg("用户名和密码不能为空",{time:1000,icon:7});
                return;
            }
            if(code == ""){
                layer.msg("验证码不能为空",{time:1000,icon:7});
                return;
            }
            var IsBy = $.idcode.validateCode();  //调用返回值，返回值结果为true或者false
            if(IsBy){
                $.ajax({
                    url: '${URL}/user/login?t='+ new Date().getTime(),//加随机数防止缓存
                    type: 'post',
                    dataType: 'json',
                    data: {
                        username: name,
                        password: pass
                    },
                    success: function(data){
                        if(data.success == true){
                            //检查是否勾选“记住密码”
                            if($("#rememberPwd").is(':checked')){
                                setCookie("userid",$("#username").val(),60);
                                setCookie("upwd",$("#password").val(),60);
                            }else{
                                delCookie("userid");
                                delCookie("upwd");
                            }
                            //转到首页
                            window.location.href = "${URL}/";
                        }else{
                            layer.msg(data.msg,{time:2000, icon:2});
                        }
                    },
                    error: function (XMLHttpRequest) {
                        layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status + ' 错误信息:' + JSON.parse(XMLHttpRequest.responseText).message, {
                            title: '错误信息',
                            icon: 2
                        });
                    }
                });
            }else {
                layer.msg("验证码错误",{time:1000,icon:2});
                $.idcode.setCode();
            }
        });

        //写cookie
        function setCookie(name,value) {
            var Days = 30;
            var exp = new Date();
            exp.setTime(exp.getTime() + Days*24*60*60*1000);
            document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
        }

        //读取cookies
        function getCookie(name) {
            var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
            return (arr=document.cookie.match(reg))?unescape(arr[2]):null;
        }
        //删除cookies
        function delCookie(name) {
            var exp = new Date();
            exp.setTime(exp.getTime() - 1);
            var cval=getCookie(name);
            if(cval!=null)
                document.cookie= name + "="+cval+";expires="+exp.toGMTString();
        }
    });
</script>
</body>
</html>

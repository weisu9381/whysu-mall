<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8"> <!--告知浏览器用什么编码格式-->
    <link rel="Shortcut Icon" href="icon/favicon.ico"/><!--浏览器小图标-->
    <meta name="renderer" content="webkit|ie-comp|ie-stand"> <!--告诉360浏览器该用哪个内核渲染-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> <!--IE=edge告诉IE使用最新的引擎渲染网页，chrome=1则可以激活Chrome Frame-->
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" /> <!--自动适应手机屏幕-->
    <meta http-equiv="Cache-Control" content="no-siteapp" />  <!--禁止百度转码-->

    <!---如果IE9以下的IE浏览器使用Html5会被忽略，使用国内的html5shiv.js包来兼容Html5->
    <!--respond.min.js可以让IE6-8支持 css的media query 响应式方案。-->
    <!--[if lt IE 9]>
        <script type="text/javascript" src="lib/html5shiv.js"></script>
        <script type="text/javascript" src="lib/respond.min.js"></script>
    <![endif]-->

    <!--引入H-ui前端框架-->
    <link rel="stylesheet" type="text/css" href="static/h-ui/css/H-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/H-ui.admin.css" />
    <link rel="stylesheet" type="text/css" href="lib/Hui-iconfont/1.0.8/iconfont.css" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/skin/default/skin.css" id="skin" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/style.css" />

    <!--使用DD_belatedPNG让IE6支持PNG透明图片-->
    <!--[if IE 6]>
    <script type="text/javascript" src="lib/DD_belatedPNG_0.0.8a-min.js" ></script>
    <script>DD_belatedPNG.fix('*');</script>
    <![endif]-->

    <title>Whysu后台管理系统</title>
    <!--为搜索引擎提供的关键字列表-->
    <meta name="keywords" content="WhysuMall后台管理系统 v1.0,WhysuMall,WhysuMall购物商城后台管理系统">
    <!--Description用来告诉搜索引擎你的网站主要内容-->
    <meta name="description" content="WhysuMall后台管理系统 v1.0，是一款电商后台管理系统，适合中小型CMS后台系统。">
</head>
<body>
<!--导航条-->
<header class="navbar-wrapper">
    <!--使用navbar-fixed-top可以将导航条固定在网页顶部-->
    <div class="navbar navbar-fixed-top">
        <div class="container-fluid cl">
            <a class="logo navbar-logo f-l mr-10 hidden-xs" href="${URL}/">WhysuMall后台管理系统</a>
            <a class="logo navbar-logo-m f-l mr-10 visible-xs" href="${URL}/">H-ui</a>
            <span class="logo navbar-slogan f-l mr-10 hidden-xs">v1.0</span>
            <a aria-hidden="false" class="nav-toggle Hui-iconfont visible-xs" href="javascript:;">&#xe667;</a>
            <!--导航条：左上角部分-->
            <nav class="nav navbar-nav">
                <ul class="cl">
                    <!--下拉菜单-->
                    <%--<li class="dropDown dropDown_hover">
                        <!--一级菜单-->
                        <a href="javascript:;" class="dropDown_A">
                            <i class="Hui-iconfont">&#xe600;</i>新增<i class="Hui-iconfont">&#xe6d5;</i>
                        </a>
                        <!--二级菜单，鼠标移到【新增】上，会弹出如下【菜单】-->
                        <ul class="dropDown-menu menu radius box-shadow">
                            <li>
                                <a href="javascript:;" onclick="product_add('添加商品','product-add','1000','600')">
                                    <i class="Hui-iconfont">&#xe620;</i> 商品
                                </a>
                            </li>
                            <li>
                                <a href="javascript:;" onclick="member_add('添加用户','member_add','','510')">
                                    <i class="Hui-iconfont">&#xe60d;</i> 用户
                                </a>
                            </li>
                        </ul>
                    </li>--%>
                    <li class="navbar-levelone current"><a href="javascript:;">平台</a></li>
                    <li class="navbar-levelone"><a href="javascript:;">财务</a></li>
                    <li><a href="http://whysumall.top.whysu" target="_blank">商城前台</a></li>
                </ul>
            </nav>
            <!--导航条：右上角部分-->
            <nav id="Hui-userbar" class="nav navbar-nav navbar-userbar hidden-xs">
                <ul class="cl">
                    <!--角色-->
                    <li style="right:5px" id="role"></li>
                    <!--下拉菜单-->
                    <li class="dropDown dropDown_hover">
                        <a href="#" class="dropDown_A">
                            <span id="username"></span>
                            <i class="Hui-iconfont">&#xe6d5;</i>
                        </a>
                        <ul class="dropDown-menu menu radius box-shadow">
                            <li><a href="javascript:;" onclick="myselfinfo()">个人信息</a></li>
                            <%--<li><a onclick="logout()">切换账号</a></li>--%>
                            <li><a onclick="logout()">退出</a></li>
                        </ul>
                    </li>
                    <li id="LockScreen">
                        <a href="lock-screen" title="锁屏">
                            <i class="Hui-iconfont" style="font-size:18px">&#xe60e;</i>
                        </a>
                    </li>
                    <li id="Hui-msg">
                        <a onclick="thanks()" title="消息">
                            <span class="badge badge-danger">3</span>
                            <i class="Hui-iconfont" style="font-size:18px">&#xe68a;</i>
                        </a>
                    </li>
                    <li id="Hui-skin" class="dropDown right dropDown_hover">
                        <a href="javascript:;" class="dropDown_A" title="换肤">
                            <i class="Hui-iconfont" style="font-size: 18px;">&#xe62a;</i>
                        </a>
                        <ul class="dropDown-menu menu radius box-shadow">
                            <li><a href="javascript:;" data-val="default" title="默认(蓝色)">默认(蓝色)</a></li>
                            <li><a href="javascript:;" data-val="black" title="黑色">黑色</a></li>
                            <li><a href="javascript:;" data-val="green" title="绿色">绿色</a></li>
                            <li><a href="javascript:;" data-val="red" title="红色">红色</a></li>
                            <li><a href="javascript:;" data-val="yellow" title="黄色">黄色</a></li>
                            <li><a href="javascript:;" data-val="orange" title="橙色">橙色</a></li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</header>

<!--侧边栏-->
<aside class="Hui-aside">
    <!--点击【平台】显示的侧边栏-->
    <div class="menu_dropdown bk_2">
        <div id="menu-article">
            <dl>
                <dt><i class="Hui-iconfont">&#xe616;</i> 商城管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
                <dd>
                    <ul>
                        <li><a data-href="content-panel" data-title="首页板块管理" href="javascript:void(0)">首页板块管理</a></li>
                        <li><a data-href="content-banner-list" data-title="首页轮播图管理" href="javascript:void(0)">首页轮播图管理</a></li>
                        <li><a data-href="content-index-list" data-title="首页板块内容管理" href="javascript:void(0)">首页板块内容管理</a></li>
                        <li><a data-href="content-other-panel" data-title="其它板块管理" href="javascript:void(0)">其它板块管理</a></li>
                        <li><a data-href="content-other-list" data-title="其它板块内容管理" href="javascript:void(0)">其它板块内容管理</a></li>
                    </ul>
                </dd>
            </dl>
        </div>
        <dl id="menu-picture">
            <dt><i class="Hui-iconfont">&#xe634;</i> 缓存管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="refresh-index-redis" data-title="首页缓存管理" href="javascript:void(0)">首页缓存管理</a></li>
                    <li><a data-href="refresh-other-redis" data-title="其它板块缓存管理" href="javascript:void(0)">其它板块缓存管理</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-product">
            <dt><i class="Hui-iconfont">&#xe620;</i> 商品管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="product-category" data-title="分类管理" href="javascript:void(0)">分类管理</a></li>
                    <li><a data-href="product-list" data-title="商品列表" href="javascript:void(0)">商品列表</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-order">
            <dt><i class="Hui-iconfont">&#xe627;</i> 订单管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="order-list" data-title="订单列表" href="javascript:void(0)">订单列表</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-search">
            <dt><i class="Hui-iconfont">&#xe665;</i> 搜索管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="refresh-index" data-title="同步索引" href="javascript:void(0)">同步索引</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-comments">
            <dt><i class="Hui-iconfont">&#xe622;</i> 评论管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="http://changyan.kuaizhan.com/" data-title="畅言评论管理" href="javascript:void(0)">畅言评论管理</a>
                    </li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-member">
            <dt><i class="Hui-iconfont">&#xe60d;</i> 会员管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="member-list" data-title="会员列表" href="javascript:;">会员列表</a></li>
                    <li><a data-href="member-remove" data-title="移除的会员" href="javascript:;">移除的会员</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-admin">
            <dt><i class="Hui-iconfont">&#xe62d;</i> 管理员管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="admin-role" data-title="角色管理" href="javascript:void(0)">角色管理</a></li>
                    <li><a data-href="admin-permission" data-title="权限管理" href="javascript:void(0)">权限管理</a></li>
                    <li><a data-href="admin-user" data-title="管理员列表" href="javascript:void(0)">管理员列表</a></li>
                </ul>
            </dd>
        </dl>
        <dl id="menu-system">
            <dt><i class="Hui-iconfont">&#xe62e;</i> 系统管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="system-shiro" data-title="权限配置" href="javascript:void(0)">权限配置</a></li>
                    <li><a data-href="system-base" data-title="基本设置" href="javascript:void(0)">基本设置</a></li>
                    <li><a data-href="system-log" data-title="系统日志" href="javascript:void(0)">系统日志</a></li>
                </ul>
            </dd>
        </dl>
    </div>

    <!--点击【财务】显示的侧边栏，默认隐藏-->
    <div class="menu_dropdown bk_2" style="display: none">
        <dl id="menu-thank">
            <dt><i class="Hui-iconfont">&#xe6b7;</i> 捐赠管理<i class="Hui-iconfont menu_dropdown-arrow">&#xe6d5;</i></dt>
            <dd>
                <ul>
                    <li><a data-href="thanks-list" data-title="捐赠列表" href="javascript:void(0)">捐赠列表</a></li>
                </ul>
            </dd>
        </dl>
    </div>
</aside>

<!--点击收起侧边栏-->
<div class="dislpayArrow hidden-xs">
    <a class="pngfix" href="javascript:void(0);" onClick="displaynavbar(this)"></a>
</div>

<!--中间部分-->
<section class="Hui-article-box">
    <!--标签栏 tab-->
    <div id="Hui-tabNav" class="Hui-tabNav hidden-xs">
        <div class="Hui-tabNav-wp">
            <ul id="min_title_list" class="acrossTab cl">
                <li class="active">
                    <span title="我的首页" data-href="welcome">我的首页</span><em></em>
                </li>
            </ul>
        </div>
        <!--######################################################这部分不太懂是干嘛的###################################################################-->
        <div class="Hui-tabNav-more btn-group">
            <a id="js-tabNav-prev" class="btn radius btn-default size-S" href="javascript:;">
                <i class="Hui-iconfont">&#xe6d4;</i>
            </a>
            <a id="js-tabNav-next" class="btn radius btn-default size-S" href="javascript:;">
                <i class="Hui-iconfont">&#xe6d7;</i>
            </a>
        </div>
    </div>

    <div id="iframe_box" class="Hui-article">
        <div class="show_iframe">
            <div style="display:none" class="loading"></div>
            <iframe scrolling="yes" frameborder="0" src="welcome"></iframe>
        </div>
    </div>
</section>

<div class="contextMenu" id="Huiadminmenu">
    <ul>
        <li id="closethis">关闭当前 </li>
        <li id="closeall">关闭全部 </li>
    </ul>
</div>

<!--_footer 作为公共模板分离出去-->
<script type="text/javascript" src="lib/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="static/h-ui/js/H-ui.min.js"></script>
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script>
<!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<%--右键标签栏，会弹出“关闭当前，关闭全部，关闭其它”等选项--%>
<script type="text/javascript" src="lib/jquery.contextmenu/jquery.contextmenu.r2.js"></script>
<script type="text/javascript">

    if (window != top){
        top.location.href = location.href;
    }

    $(function(){
        $("body").Huitab({
            tabBar: ".navbar-wrapper .navbar-levelone",
            tabCon: ".Hui-aside .menu_dropdown",
            className: "current",
            index: 0
        });
    });

    /**导航条：个人信息*/
    function myselfinfo(){
        //H-ui提供的弹出层
        layer_show('管理员信息','index-admin-show',360,400);
    }

    /**新增--商品*/
    /*function product_add(title,url,w,h){
        /!*var index = layer.open({
            type: 2,
            title:title,
            content:url
        });
        layer.full(index);*!/
        layer_show(title,url,w,h);
    }*/

    /**新增--用户*/
    /*function member_add(title,url,w,h){
        layer_show(title,url,w,h);
    }*/

    var username="",description="",sex="",phone="",email="",address="",created="",file="";
    /**页面一加载完成就异步请求用户信息*/
    $.ajax({
        type: 'GET',
        url: '${URL}/user/userInfo',
        success: function(data){
            if(data.success == true){
                //右上角导航条显示用户的【角色】
                $("#role").html(data.result.description);
                //右上角导航条显示用户的【用户名】
                $("#username").html(data.result.username);
                username = data.result.username;
                description = data.result.description;
                sex = data.result.sex;
                phone = data.result.phone;
                email = data.result.email;
                address = data.result.address;
                created = data  .result.created;
                file = data.result.file;
            }else{
                layer.alert(data.message, {title: '错误信息', icon: 2});
            }
        },
        error: function (XMLHttpRequest) {
            layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status + ' 错误信息:' + JSON.parse(XMLHttpRequest.responseText).message,
                {
                    title: '错误信息', icon: 2
                });
        }
    });

    function logout(){
        $.ajax({
            type: 'GET',
            url: '${URL}/user/logout',
            success: function(data){
                window.location.href = "${URL}/login";
            },
            error: function(XMLHttpRequest){
                layer.alert("数据处理错误！错误码："+ XMLHttpRequest.status + " 错误信息："+ JSON.parse(XMLHttpRequest.responseText).message,
                    {
                        title: '错误信息', icon: 2
                    });
            }
        });
    }
</script>

</body>
</html>
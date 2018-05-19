<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <!--浏览器标签页小图标-->
    <link rel="shortcut icon" href="icon/favicon.ico" type="image/x-icon"/>
    <title>WhysuMall后台管理系统 v1.0</title>
    <meta name="keywords" content="WhysuMall后台管理系统 v1.0,WhysuMall,WhysuMall购物商城后台管理系统"/>
    <meta name="description" content="WhysuMall后台管理系统 v1.0，是一款电商后台管理系统，适合中小型CMS后台系统。"/>

    <!--引入flatlab所需要的样式-->
    <!-- Bootstrap core CSS -->
    <link href="lib/flatlab/css/bootstrap.min.css" rel="stylesheet">
    <link href="lib/flatlab/css/bootstrap-reset.css" rel="stylesheet">
    <!--external css-->
    <link href="lib/flatlab/assets/font-awesome/css/font-awesome.css" rel="stylesheet"/>
    <link href="lib/flatlab/assets/jquery-easy-pie-chart/jquery.easy-pie-chart.css" rel="stylesheet" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="lib/flatlab/css/owl.carousel.css" type="text/css">
    <!-- Custom styles for this template -->
    <link href="lib/flatlab/css/style.css" rel="stylesheet">
    <link href="lib/flatlab/css/style-responsive.css" rel="stylesheet"/>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 tooltipss and media queries -->
    <!--[if lt IE 9]>
    <script src="lib/flatlab/js/html5shiv.js"></script>
    <script src="lib/flatlab/js/respond.min.js"></script>
    <![endif]-->
</head>
<style>
    #main-content {
        margin-left: 20px;
        margin-top: -50px;
    }
</style>
<body>
<section id="container">
    <!--main content start-->
    <section id="main-content">
        <section class="wrapper">
            <!--state overview start-->
            <div class="row state-overview">
                <!--用户总数-->
                <div class="col-lg-3 col-sm-6">
                    <section class="panel">
                        <div class="symbol terques">
                            <i class="icon-user"></i>
                        </div>
                        <div class="value">
                            <h1 class="count">
                                ...
                            </h1>
                            <p>用户总数</p>
                        </div>
                    </section>
                </div>
                <!--商品总数-->
                <div class="col-lg-3 col-sm-6">
                    <section class="panel">
                        <div class="symbol red">
                            <i class="icon-tags"></i>
                        </div>
                        <div class="value">
                            <h1 class="count2">
                                ...
                            </h1>
                            <p>商品总数</p>
                        </div>
                    </section>
                </div>
                <!--订单总数-->
                <div class="col-lg-3 col-sm-6">
                    <section class="panel">
                        <div class="symbol yellow">
                            <i class="icon-shopping-cart"></i>
                        </div>
                        <div class="value">
                            <h1 class=" count3">
                                ...
                            </h1>
                            <p>订单总数</p>
                        </div>
                    </section>
                </div>
                <!--浏览量-->
                <div class="col-lg-3 col-sm-6">
                    <section class="panel">
                        <div class="symbol blue">
                            <i class="icon-bar-chart"></i>
                        </div>
                        <div class="value">
                            <h1 class=" count4">
                                ...
                            </h1>
                            <p>浏览量</p>
                        </div>
                    </section>
                </div>
            </div>
            <!--state overview end-->

            <div class="row">
                <div class="col-lg-4">
                    <!--天气 weather statement start-->
                    <section class="panel">
                        <div class="weather-bg">
                            <div class="panel-body">
                                <div class="col-xs-6">
                                    <i id="weather" class="icon-cloud"></i>
                                    <span id="city">...</span>
                                </div>
                                <div class="col-xs-6">
                                    <div class="degree">
                                        <span id="degree">...</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <footer class="weather-category">
                            <ul>
                                <li class="active">
                                    <h5>湿度</h5>
                                    <span id="humidity">...</span>
                                </li>
                                <li>
                                    <h5>空气质量</h5>
                                    <span id="airCondition">...</span>
                                </li>
                                <li>
                                    <h5>风力</h5>
                                    <span id="wind">...</span>
                                </li>
                            </ul>
                        </footer>
                    </section>
                    <!--weather statement end-->


                    <!--我的信息 user info table start-->
                    <section class="panel">
                        <div class="panel-body">
                            <img width="83px" height="83px" src="lib/flatlab/img/avatar1.jpg" alt="">
                            <div class="task-thumb-details">
                                <h1>苏伟</h1>
                                <p>Author</p>
                            </div>
                        </div>
                        <table class="table table-hover personal-task">
                            <tbody>
                            <tr>
                                <td><i class="icon-weibo"></i></td>
                                <td><a target="_blank" href="https://weibo.com/suwei7012">新浪微博</a></td>
                                <td><span style="margin-top: -1px"
                                          class="label label-info pull-right r-activity">01</span></td>
                            </tr>
                            <tr>
                                <td><i class="icon-music"></i></td>
                                <td><a target="_blank" href="http://music.163.com/#/user/home?id=298905301">网易云音乐</a>
                                </td>
                                <td><span style="margin-top: -1px"
                                          class="label label-success pull-right r-activity">02</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <i class="icon-phone"></i>
                                </td>
                                <td>电话：185 5975 9381</td>
                                <td><span style="margin-top: -1px"
                                          class="label label-primary pull-right r-activity">03</span></td>
                            </tr>
                            <tr>
                                <td><i class="icon-envelope"></i></td>
                                <td>邮箱：1473040317@qq.com</td>
                                <td><span style="margin-top: -1px"
                                          class="label label-warning pull-right r-activity">04</span></td>
                            </tr>
                            </tbody>
                        </table>
                    </section>
                    <!--user info table end-->
                </div>

                <div class="col-lg-8">
                    <!--widget start-->
                    <section class="panel">
                        <header class="panel-heading tab-bg-dark-navy-blue">
                            <ul class="nav nav-tabs nav-justified ">
                                <li>
                                    <a href="#popular" data-toggle="tab">公告</a>
                                </li>
                                <%--<li class="active">
                                    <a href="#latestNotice" data-toggle="tab">最新通知</a>
                                </li>
                                <li>
                                    <a href="#suggestion" data-toggle="tab">意见反馈</a>
                                </li>--%>
                            </ul>
                        </header>
                        <div class="panel-body" style="height: 600px;">
                            <div class="tab-content tasi-tab">
                                <!--公告-->
                                <div class="tab-pane active" id="popular">
                                    <article class="media">
                                        <%--<a class="pull-left thumb p-thumb">
                                            <img src="lib/flatlab/img/product1.jpg">
                                        </a>--%>
                                        <div class="media-body">
                                            <div class="p-head" style="font-size: 20px;">
                                                尊敬的 <span id="username" ></span>
                                                <span id="hello"></span>
                                                现在时间是: <span id="currentTime">xx:xx:xx</span>
                                            </div>
                                            <div style="font-size: 15px;">
                                                <br/>
                                                本项目是基于SOA架构开发的的分布式电商B2C购物商城，前后端分离
                                                <br/><br/>
                                                后端使用到的技术：
                                                <br/><br/>
                                                （1）基于 Sping + SpringMVC + MyBatis 框架，数据库 MySql， 服务器 Tomcat
                                                <br/><br/>
                                                （2）页面基于 <a style="color: #5166c9; font-weight: bold;" href="http://www.h-ui.net/" target="_blank">H-ui框架</a>，使用到 JQuery插件： <a style="color: #5166c9; font-weight: bold;" href="http://www.treejs.cn/v3/main.php#_zTreeInfo" target="_blank">Ztree</a>，<a style="color: #5166c9; font-weight: bold;" href="http://www.datatables.club/" target="_blank">Datatables</a>，<a style="color: #5166c9; font-weight: bold;" href="http://layer.layui.com/" target="_blank">Layer</a>
                                                <br/><br/>
                                                （3）使用 <a style="color: #5166c9; font-weight: bold;" href="http://fex.baidu.com/webuploader/getting-started.html" target="_blank">WebUploader</a> 百度上传插件 ，使用 FastDFS 文件存储系统 + Nginx 反向代理
                                                <br/><br/>
                                                （4）使用 Dubbo2.5.6 + Zookeeper集群 分布式服务框架
                                                <br/><br/>
                                                （5）使用 ActiveMQ 面向消息中间件，以及为前端提供 Elasticsearch 搜索服务 和 Redis 缓存服务
                                                <br/><br/>
                                                （6）开发工具 IDEA，使用 Jrebel 实现热部署，使用 Swagger2 构建 RESTFul API文档
                                                <br/><br/>
                                                前台使用到的技术：(<a style="color: #5166c9; font-weight: bold;" href="http://www.h-ui.net/">前往前台</a>)
                                                <br/><br/>
                                                （1）基于<a style="color: #5166c9; font-weight: bold;" href="https://cn.vuejs.org/" target="_blank"> VUE框架 </a>，使用 <a style="color: #5166c9; font-weight: bold;" href="http://nodejs.cn/" target="_blank">Node.js</a>开发环境，页面使用  <a style="color: #5166c9; font-weight: bold;" href="http://element-cn.eleme.io/#/zh-CN" target="_blank"> Element UI </a>
                                                <br/><br/>
                                                （2）使用 Vuex 状态管理，使用 Vue Router 路由匹配，使用 webpack 模块打包器， 使用 axios 异步请求
                                                <br/><br/>
                                                （3）使用 极验验证码， 使用 Elasticsearch 实现商品搜索 以及 Redis 商品缓存
                                            </div>
                                        </div>
                                    </article>
                                </div>
                                <%--<!--最新通知-->
                                <div class="tab-pane" id="latestNotice">
                                    <div style="text-align: center;">最新通知：</div>
                                </div>
                                <!--意见反馈-->
                                <div class="tab-pane" id="suggestion"
                                     style="overflow-y: scroll;height: 320px;margin: -15px -15px 0 0">
                                    <article class="media">
                                        <div id="SOHUCS" sid="12345678"></div>
                                    </article>
                                </div>--%>
                            </div>
                        </div>
                    </section>
                    <!--widget end-->
                </div>
            </div>
        </section>
    </section>
</section>

<!--使用不蒜子计算网站访客数-->
<span id="busuanzi_container_site_uv">
    <span style="display: none;" id="busuanzi_value_site_uv"></span>
</span>

<!-- js placed at the end of the document so the pages load faster -->
<script src="lib/flatlab/js/jquery.js"></script>
<script src="lib/flatlab/js/jquery-1.8.3.min.js"></script>
<script src="lib/flatlab/js/bootstrap.min.js"></script>
<script src="lib/flatlab/js/jquery.scrollTo.min.js"></script>
<script src="lib/flatlab/js/jquery.nicescroll.js" type="text/javascript"></script>
<script src="lib/flatlab/js/jquery.sparkline.js" type="text/javascript"></script>
<script src="lib/flatlab/assets/jquery-easy-pie-chart/jquery.easy-pie-chart.js"></script>
<script src="lib/flatlab/js/owl.carousel.js"></script>
<script src="lib/flatlab/js/jquery.customSelect.min.js"></script>
<script src="lib/flatlab/js/respond.min.js"></script>

<script class="include" type="text/javascript" src="lib/flatlab/js/jquery.dcjqaccordion.2.7.js"></script>

<!--common script for all pages-->
<script src="lib/flatlab/js/common-scripts.js"></script>

<script charset="utf-8" type="text/javascript" src="lib/changyan.js"></script>
<script async src="lib/busuanzi.pure.mini.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>

<!--script for this page-->
<script src="lib/flatlab/js/sparkline-chart.js"></script>
<script src="lib/flatlab/js/easy-pie-chart.js"></script>
<script src="lib/flatlab/js/count.js"></script>


<script>

    $("#username").html(parent.username);

    var now = new Date(), hour = now.getHours();
    var hi = "您好！";
    if (hour < 6) {
        hi = "凌晨好！"
    } else if (hour < 9) {
        hi = "早上好！"
    } else if (hour < 12) {
        hi = "上午好！"
    } else if (hour < 14) {
        hi = "中午好!"
    } else if (hour < 17) {
        hi = "下午好！"
    } else if (hour < 19) {
        hi = "傍晚好！"
    } else if (hour < 22) {
        hi = "晚上好！"
    } else {
        hi = "深夜好!"
    }
    $("#hello").html(hi);

    $(function () {
        setInterval(function () {
            $("#currentTime").text(new Date().toLocaleString());
        }, 1000);
    });

    /*统计用户数*/
    $.ajax({
        type: 'GET',
        url: '${URL}/member/count',
        success: function (data) {
            countUp(data.recordsTotal);
        },
        error: function (XMLHttpRequest) {
            layer.alert('数据处理失败,错误码：' + XMLHttpRequest.status + ", 错误信息: " + JSON.parse(XMLHttpRequest.responseText).message, {
                title: '错误信息',
                icon: 2
            });
        }
    });
    /*统计商品数*/
    $.ajax({
        url: "${URL}/item/count",
        type: 'GET',
        success: function (result) {
            countUp2(result.recordsTotal);
        },
        error: function (XMLHttpRequest) {
            if (XMLHttpRequest.status != 200) {
                layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status + ' 错误信息:' + JSON.parse(XMLHttpRequest.responseText).message, {
                    title: '错误信息',
                    icon: 2
                });
            }
        }
    });

    /*统计订单数*/
    $.ajax({
        url: "${URL}/order/count",
        type: 'GET',
        success: function (data) {
            countUp3(data.result);
        },
        error: function (XMLHttpRequest) {
            if (XMLHttpRequest.status != 200) {
                layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status + ' 错误信息:' + JSON.parse(XMLHttpRequest.responseText).message, {
                    title: '错误信息',
                    icon: 2
                });
            }
        }
    });

    /*网站浏览量，通过pusuanzi*/
    setTimeout('count()', 2000);

    function count() {
        countUp4($("#busuanzi_value_site_uv").html());
    }

    /*天气*/
    $.ajax({
        type: "get",
        url: "${URL}/sys/weather",
        success: function (data) {
            if (data.result == null || data.result == "" || data.result.indexOf('错误') > 0) {
                layer.msg("无法获取您的IP,天气信息获取失败");
                return;
            }
            var json = JSON.parse(data.result);
            var param = json.result[0];
            var weather = param.weather;
            if (weather.indexOf("雨") >= 0) {
                $("#weather").removeAttr("class");
                $("#weather").attr("class", "icon-umbrella");
            } else if (weather.indexOf('晴') >= 0) {
                $("#weather").removeAttr("class");
                $("#weather").attr("class", "icon-sun");
            }
            $("#city").html(param.city);
            $("#degree").html(param.temperature);
            $("#humidity").html(param.humidity);
            $("#airCondition").html(param.airCondition);
            $("#wind").html(param.wind);
        },
        error: function (XMLHttpRequest) {
            layer.alert("数据处理错误！错误码:" + XMLHttpRequest.status + ",错误信息: " + JSON.parse(XMLHttpRequest.responseText).message, {
                title: '错误信息',
                icon: 2
            });
        }
    });
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <!--[if lt IE 9]>
    <script type="text/javascript" src="lib/html5shiv.js"></script>
    <script type="text/javascript" src="lib/respond.min.js"></script>
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="static/h-ui/css/H-ui.min.css"/>
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/H-ui.admin.css"/>
    <link rel="stylesheet" type="text/css" href="lib/Hui-iconfont/1.0.8/iconfont.css"/>
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/skin/default/skin.css" id="skin"/>
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/style.css"/>
    <!--[if IE 6]>
    <script type="text/javascript" src="lib/DD_belatedPNG_0.0.8a-min.js"></script>
    <script>DD_belatedPNG.fix('*');</script>
    <![endif]-->
    <title>添加用户</title>
</head>
<body>
<div class="page-container">
    <form id="form-member-add" class="form form-horizontal" action="" method="post">
        <input id="id" name="id" hidden type="text" class="input-text">
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>用户名：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="username" name="username" type="text" class="input-text" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>设置密码：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="password" name="password" type="password" class="input-text" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>确认密码：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="passwordConfim" name="passwordConfirm" type="password" class="input-text" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>性别：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal" >
                <%--注意如下，id虽然不一样，但name="sex"都是一样的--%>
                <div class="radio-box">
                    <input id="sex-male" name="sex" checked value="男" type="radio">
                    <label for="sex-male">男</label>
                </div>
                <div class="radio-box">
                    <input id="sex-female" name="sex" value="女" type="radio">
                    <label for="sex-female">女</label>
                </div>
                <div class="radio-box">
                    <input id="sex-secret" name="sex" value="保密" type="radio">
                    <label for="sex-secret">保密</label>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>手机：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="phone" name="phone" type="text" class="input-text" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"><span class="c-red">*</span>邮箱：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="email" name="email" type="text" class="input-text" value="" placeholder="@">
            </div>
        </div>
        <%--<div class="row cl">
            <label class="form-label col-xs-3 col-sm-2">头像：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <span class="btn-upload form-group">
                    <input id="uploadfile" class="input-text upload-url" type="text" name="uploadfile"  readonly nullmsg="请添加附件！" style="width:200px">
                    <a href="javascript:;" class="btn btn-primary radius upload-btn"><i class="Hui-iconfont">&#xe642;</i> 浏览文件</a>
                    <input type="file" multiple name="memberfile" class="input-file">
				</span>
            </div>
        </div>--%>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2">所在城市：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="distpicker1">
                    <select name="province" class="select" style="width:180px;height:31px;"></select>
                    <select name="city" class="select" style="width:180px;height:31px;"></select>
                    <select name="district" class="select" style="width:180px;height:31px;"></select>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2">备注：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <textarea name="description" class="textarea" placeholder="备注：最多输入100个字符"></textarea>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-3 col-sm-2"></label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="saveButton" class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;添加&nbsp;&nbsp;">
            </div>
        </div>
    </form>
</div>

<!--_footer 作为公共模版分离出去-->
<script type="text/javascript" src="lib/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="static/h-ui/js/H-ui.min.js"></script>
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script> <!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<%--表单验证--%>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/jquery.validate.js"></script>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/validate-methods.js"></script>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/messages_zh.js"></script>
<%--省市联级--%>
<script type="text/javascript" src="lib/province/distpicker.data.js"></script>
<script type="text/javascript" src="lib/province/distpicker.js"></script>
<script type="text/javascript">
    /*城市选择控件*/
    $("#distpicker1").distpicker();

    /*限制长度*/
    $(".textarea").Huitextarealength({
        minlength: 1,
        maxlength: 100
    });

    $('.skin-minimal input').iCheck({
        checkboxClass: 'icheckbox-blue',
        radioClass: 'iradio-blue',
        increaseArea: '20%'
    });

    /*validate校验*/
    $("#form-member-add").validate({
        rules: {
            username: {
                required: true,
                minlength: 2,
                maxlength: 16,
                remote: '${URL}/member/username'
            },
            password:{
                required:true,
                minlength:6
            },
            passwordConfirm:{
                required:true,
                minlength:6,
                equalTo: "#password"
            },
            phone:{
                required:true,
                isMobile:true,
                remote:"${URL}/member/phone"
            },
            email:{
                required:true,
                email:true,
                remote:"${URL}/member/email"
            },
            sex:{
                required:true
            },
            file:{
                required:false
            },
            province:{
                required:true
            }
        },
        messages: {
            username: {
                remote: "该用户名已被注册"
            },
            phone: {
                remote: "该手机号已被注册"
            },
            email: {
                remote: "该邮箱已被注册"
            }
        },
        onkeyup:false,
        focusCleanup:false,
        success:"valid",
        submitHandler:function(form){
            var index1 = layer.load(3);
            $(form).ajaxSubmit({
                url: '${URL}/member/add',
                type: 'POST',
                success: function(data) {
                    layer.close(index1);
                    if(data.success==true){
                        if(parent.location.pathname!='/'){
                            parent.member_count();
                            parent.refresh();
                            parent.msgSuccess("添加成功!");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        }else{
                            layer.confirm('添加成功!', {
                                btn: ['确认'],icon: 1
                            }, function(){
                                var index = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(index);
                            });
                        }
                    }else{
                        layer.close(index1);
                        layer.alert('添加失败! '+data.message, {title: '错误信息',icon: 2});
                    }
                },
                error:function(XMLHttpRequest) {
                    layer.close(index1);
                    layer.alert('添加用户失败! 错误码:'+XMLHttpRequest.status, {title: '错误信息',icon: 2});
                }
            });
        }
    });
</script>
</body>
</html>
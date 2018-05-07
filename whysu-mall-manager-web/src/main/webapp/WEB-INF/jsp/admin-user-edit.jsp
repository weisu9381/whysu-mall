<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <!--[if lt IE 9]>
    <script type="text/javascript" src="lib/html5shiv.js"></script>
    <script type="text/javascript" src="lib/respond.min.js"></script>
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="static/h-ui/css/H-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/H-ui.admin.css" />
    <link rel="stylesheet" type="text/css" href="lib/Hui-iconfont/1.0.8/iconfont.css" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/skin/default/skin.css" id="skin" />
    <link rel="stylesheet" type="text/css" href="static/h-ui.admin/css/style.css" />
    <!--[if IE 6]>
    <script type="text/javascript" src="lib/DD_belatedPNG_0.0.8a-min.js" ></script>
    <script>DD_belatedPNG.fix('*');</script>
    <![endif]-->
    <title>编辑管理员</title>
</head>
<body>
<div class="page-container">
    <form id="form-admin-user-edit" class="form form-horizontal">
        <input  id="id" name="id" type="text" hidden value="" placeholder="">
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>管理员：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="username" name="username" type="text" class="input-text" value="" placeholder="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>性别：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <div class="radio-box">
                    <input id="sex-male" name="sex" value="男" type="radio" checked>
                    <label for="sex-male">男</label>
                </div>
                <div class="radio-box">
                    <input id="sex-female" name="sex" value="女" type="radio">
                    <label for="sex-female">女</label>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>手机：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="phone" name="phone" type="text" class="input-text" placeholder="" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>邮箱：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input id="email" name="email" type="text" class="input-text" placeholder="@" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">角色：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <span class="select-box" style="width:150px;">
                    <select id="select" name="roleId" class="select" size="1"></select>
			    </span>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">备注：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <textarea id="description" name="description" class="textarea" cols="" rows="" placeholder="备注...100个字符以内"></textarea>
            </div>
        </div>
        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <input id="saveButton" class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
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
<script type="text/javascript">
    $("#id").val(parent.userId);
    $("#username").val(parent.username);
    $("#phone").val(parent.phone);
    $("#email").val(parent.email);
    $("#description").val(parent.description);
    var roleNames=parent.roleNames;
    var sex=parent.sex;
    if(sex=='男'){
        $("#sex-male").attr('checked', 'checked');
    }else{
        $("#sex-female").attr('checked', 'checked');
    }

    /*文本输入限制*/
    $(".textarea").Huitextarealength({
        minlength:0,
        maxlength:100
    });

    /*获取角色下拉框*/
    var index = layer.load(3);
    $.ajax({
        url: '${URL}/user/getAllRoles',
        type: 'GET',
        success: function(data){
            layer.close(index);
            if(data.success == true){
                var size = data.result.length;
                for(var i = 0; i < size; i++){
                    if(data.result[i].name == roleNames.trim()){
                        $("#select").append('<option selected value="'+ data.result[i].id+'">'+ data.result[i].name+'</option>');
                    }else{
                        $("#select").append('<option value="'+ data.result[i].id+'">'+ data.result[i].name+'</option>');
                    }
                }
            }else{
                layer.alert(data.message, {title: '错误信息', icon: 2});
            }
        },
        error:function(XMLHttpRequest){
            layer.close(index);
            layer.alert('获取角色下拉框失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
        }
    });

    $(function(){
        $('.skin-minimal input').iCheck({
            checkboxClass: 'icheckbox-blue',
            radioClass: 'iradio-blue',
            increaseArea: '20%'
        });

        $("#form-admin-user-edit").validate({
            rules:{
                username:{
                    required:true,
                    minlength:1,
                    maxlength:16,
                    remote: "${URL}/user/edit/username/"+parent.userId
                },
                sex:{
                    required:true,
                },
                phone:{
                    required:true,
                    isPhone:true,
                    remote: "${URL}/user/edit/phone/"+parent.userId
                },
                email:{
                    required:true,
                    email:true,
                    remote: "${URL}/user/edit/email/"+parent.userId
                },
                roleId:{
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
                    url: "${URL}/user/updateUser",
                    type: "POST",
                    success: function (data) {
                        layer.close(index1);
                        if (data.success == true) {
                            parent.refresh();
                            parent.msgSuccess("编辑成功!");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        } else {
                            layer.alert(data.message, {title: '错误信息', icon: 2});
                        }
                    },
                    error: function (XMLHttpRequest) {
                        layer.close(index1);
                        layer.alert('管理员编辑失败! 错误码:' + XMLHttpRequest.status, {
                            title: '错误信息',
                            icon: 2
                        });
                    }
                });
            }
        });
    });
</script>
</body>
</html>
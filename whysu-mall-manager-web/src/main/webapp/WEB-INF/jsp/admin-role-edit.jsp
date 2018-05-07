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
    <title>新建角色</title>
</head>
<style>
    .permission-list > dd > dl > dd {
        margin-left: 0px;
    }
</style>
<body>
<div class="page-container">
    <form id="form-admin-role-edit" class="form form-horizontal" method="post" action="">
        <input type="text" hidden value="" placeholder="" id="id" name="id">
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>角色名称：</label>
            <div class="formControls col-xs-7 col-sm-8">
                <input id="name" name="name" type="text" class="input-text" placeholder="" value="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">描述：</label>
            <div class="formControls col-xs-7 col-sm-8">
                <input type="text" class="input-text" value="" placeholder="" id="description" name="description">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">拥有权限：</label>
            <div class="formControls col-xs-7 col-sm-8">
                <dl class="permission-list">
                    <dt>
                        <label>
                            <input type="checkbox" value="" name="checkAll" id="checkAll"> 全选
                        </label>
                    </dt>
                    <dd>
                        <dl class="cl permission-list1">
                            <dd id="permissions"></dd>
                        </dl>
                    </dd>
                </dl>
            </div>
        </div>
        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <button id="saveButton" type="submit" class="btn btn-success radius" id="admin-role-save" name="admin-role-save"><i class="icon-ok"></i> 确定</button>
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

    $("#id").val(parent.roleId);
    $("#name").val(parent.name);
    $("#description").val(parent.description);

    var permissions = parent.permissions;
    var array = new Array();
    array = permissions.split("|");

    var index = layer.load(3);
    $.ajax({
        url: '${URL}/user/permissionList',
        type: 'GET',
        success: function(data){
            layer.close(index);
            if(data.success == true){
                var size = data.data.length;
                for(var i = 0; i < size; i++){
                    var flag = false;
                    for(var j = 0; j < array.length; j++){
                        if(array[j] == data.data[i].name){
                            flag = true;
                            break;
                        }
                    }
                    if(flag){
                        $("#permissions").append('<label><input type="checkbox" checked name="roles" id="roles" value="'+ data.data[i].id+'">'+ data.data[i].name+'</label>');
                    }else{
                        $("#permissions").append('<label><input type="checkbox" name="roles" id="roles" value="'+ data.data[i].id+'">'+ data.data[i].name+'</label>');
                    }
                }
            }else{
                layer.alert(data.message, {title: '错误信息',icon: 2});
            }
        },
        error:function(XMLHttpRequest){
            layer.close(index);
            layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
        }
    });

    $(function () {
        $("#checkAll").click(function () {         //全选/取消全选
            $(":checkbox").prop("checked", this.checked);
        });
    });

    $("#form-admin-role-edit").validate({
        rules: {
            name: {
                required: true,
                minlength: 1,
                maxlength: 20,
                remote: '${URL}/user/edit/roleName/' + parent.roleId
            }
        },
        messages: {
            name: {
                remote: '该角色名已经被使用'
            }
        },
        onkeyup:false,
        focusCleanup:false,
        success:"valid",
        submitHandler:function(form){
            var index = layer.load(3);
            $(form).ajaxSubmit({
                type: 'POST',
                url: '${URL}/user/updateRole',
                success: function(data){
                    layer.close(index);
                    if(data.success == true){
                        parent.refresh();
                        parent.msgSuccess("编辑成功！");
                        //关闭这个弹窗回到父页面
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    }else{
                        layer.alert(data.message, {title: '错误信息',icon: 2});
                    }
                },
                error:function(XMLHttpRequest) {
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        }
    });
</script>
</body>
</html>
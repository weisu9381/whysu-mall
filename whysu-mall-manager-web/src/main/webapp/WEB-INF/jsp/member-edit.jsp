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
    <title>title</title>
</head>
<body>
<div class="page-container">
    <form action="" method="post" class="form form-horizontal" id="form-member-edit">
        <input type="password" name="password" hidden>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>用户名：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="text" class="input-text" value="" placeholder="" id="username" name="username">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>性别：</label>
            <div class="formControls col-xs-8 col-sm-9 skin-minimal">
                <div class="radio-box">
                    <input type="radio" id="sex-male" name="sex" value="男"  checked>
                    <label for="sex-male">男</label>
                </div>
                <div class="radio-box">
                    <input type="radio" id="sex-female" name="sex" value="女">
                    <label for="sex-female">女</label>
                </div>
                <div class="radio-box">
                    <input type="radio" id="sex-secret" name="sex" value="保密">
                    <label for="sex-secret">保密</label>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>手机：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="text" class="input-text" value="" placeholder="" id="phone" name="phone">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>邮箱：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <input type="text" class="input-text" placeholder="@" name="email" id="email">
            </div>
        </div>
        <%--<div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">头像：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <span class="btn-upload form-group">
                    <input class="input-text upload-url" type="text" name="uploadfile" id="uploadfile" readonly nullmsg="请添加附件！" style="width:200px">
                    <a href="javascript:void();" class="btn btn-primary radius upload-btn"><i class="Hui-iconfont">&#xe642;</i> 浏览文件</a>
                    <input type="file" multiple name="memberfile" class="input-file">
				</span>
            </div>
        </div>--%>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">所在城市：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <div id="distpicker1">
                    <select id="province" name="province" class="select" style="width:180px;height:31px;"></select>
                    <select id="city" name="city" class="select" style="width:180px;height:31px;"></select>
                    <select id="district" name="district" class="select" style="width:180px;height:31px;"></select>
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-3">备注：</label>
            <div class="formControls col-xs-8 col-sm-9">
                <textarea name="description" id="description" cols="" rows="" class="textarea"  placeholder="备注...最多输入100个字符"></textarea>
            </div>
        </div>
        <div class="row cl">
            <div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
                <input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;保存&nbsp;&nbsp;">
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

    var id=parent.Id;

    $("#username").val(parent.username);
    $("#phone").val(parent.phone);
    $("#email").val(parent.email);
    $("#description").val(parent.description);

    if(parent.sex=='男'){
        $("#sex-male").attr('checked', 'checked');
    }else if(parent.sex=='女'){
        $("#sex-female").attr('checked', 'checked');
    }else if(parent.sex=='保密'){
        $("#sex-secret").attr('checked', 'checked');
    }

    var arr,a,b,c;
    if(parent.address!=null){
        arr = parent.address.split(" ");
        a=arr[0];
        b=arr[1];
        c=arr[2];
    }
    if(a==null){
        a='北京市';
    }

    /*城市选择控件*/
    $("#distpicker1").distpicker({
        province: a,
        city: b,
        district: c
    });

    /*文本输入限制*/
    $(".textarea").Huitextarealength({
        minlength:0,
        maxlength:100
    });


    $(function(){
        $('.skin-minimal input').iCheck({
            checkboxClass: 'icheckbox-blue',
            radioClass: 'iradio-blue',
            increaseArea: '20%'
        });

        $("#form-member-edit").validate({
            rules:{
                username:{
                    required:true,
                    minlength:2,
                    maxlength:16,
                    remote: "${URL}/member/edit/"+id+"/username"
                },
                phone:{
                    required:true,
                    isMobile:true,
                    remote: "${URL}/member/edit/"+id+"/phone"
                },
                email:{
                    required:true,
                    email:true,
                    remote: "${URL}/member/edit/"+id+"/email"
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
                    url: "${URL}/member/update/"+id,
                    type: "POST",
                    success: function(data) {
                        layer.close(index1);
                        if(data.success==true){
                            parent.refresh();
                            parent.msgSuccess("编辑成功!");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        }else{
                            layer.alert('修改失败! '+data.message, {title: '错误信息',icon: 2});
                        }
                    },
                    error:function(XMLHttpRequest) {
                        layer.close(index1);
                        layer.alert('编辑用户信息失败! 错误码:' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                    }
                });
            }
        });
    });


</script>
</body>
</html>
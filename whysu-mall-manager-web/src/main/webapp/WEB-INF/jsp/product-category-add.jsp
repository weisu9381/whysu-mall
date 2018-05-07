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
    <title>添加商品分类</title>
</head>
<body>
<div class="page-container">
    <form id="category-add" action="" method="post" class="form form-horizontal ">
        <span id="parentName"></span>
        <input hidden id="parentId" name="parentId" type="text" class="input-text" value="0">
        <input hidden id="isParent" name="isParent" type="text" class="input-text" value="true">
        <%--默认是开启的状态 status为1--%>
        <input hidden id="status" name="status" type="text" class="input-text" value="1">
        <%--默认排序优先值是1，添加的时候要查询子节点最大的排序优先值，然后排序值加 1--%>
        <input hidden id="sortOrder" name="sortOrder" type="text" class="input-text" value="1">
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>分类名称：</label>
            <div class="formControls col-xs-6 col-sm-6">
                <input id="name" name="name" type="text" class="input-text" value="" placeholder="">
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-2">是否为父节点：</label>
            <div class="formControls col-xs-6 col-sm-6">
                <div id="parentSwitch" class="switch" data-on-label="是" data-on="info" data-off-label="否">
                    <input type="checkbox" checked />
                </div>
            </div>
        </div>
        <div class="row cl">
            <label class="form-label col-xs-4 col-sm-2">备注：</label>
            <div class="formControls col-xs-6 col-sm-6">
                <textarea name="remark" id="remark" cols="" rows="" class="textarea"  placeholder="备注...最多输入100个字符"></textarea>
            </div>
        </div>
        <div class="row cl">
            <div class="col-7 col-offset-4">
                <input id="saveButton" class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;保存并提交&nbsp;&nbsp;">
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

    /*textarea文本限制*/
    $(".textarea").Huitextarealength({
        minlength: 0,
        maxlength: 100
    });

    //因为： 是否是根节点【是/否】刚开始都是选中“是”，所以默认是“父节点”
    $('#isParent').val(true);

    /*如果是新建根节点的话,parentId必须是0*/
    if(parent.isRoot){
        $("#parentId").val(0);
        $("#parentName").html('当前位于根目录');
    }else{
        if(parent.id == ""){
            $("#parentId").val(0);
            $("#parentName").html('当前位于根目录');
        }else{
            //得到选中的节点
            $("#parentId").val(parent.id);
            $("#parentName").html('将为【'+ parent.name+'】添加节点：');
        }
    }

    /*手动点击switch，在数据库中是用1表示是父节点，但在TbItemCat中是boolean类型*/
    $('#parentSwitch').on('switch-change',function(e, data){
        if(data.value == true){
            $('#isParent').val(true);
        }else{
            $('#isParent').val(false);
        }
    });


    $('#category-add').validate({
        rules: {
            name: {
                required: true,
                minlength: 1,
                maxlength: 25
            }
        },
        onkeyup:false,
        focusCleanup:false,
        success:"valid",
        submitHandler: function(form){
            var index = layer.load(3);
            $(form).ajaxSubmit({
                url: '${URL}/item/cat/add',
                type: 'POST',
                success: function(data){
                    layer.close(index);
                    if(data.success==true){
                        parent.initZtree();
                        parent.msgSuccess("添加成功!");
                        var index = parent.layer.getFrameIndex(window.name);//获取窗口索引
                        parent.layer.close(index);//关闭弹出的子页面窗口
                    }else{
                        layer.alert('添加失败! '+data.message, {title: '错误信息',icon: 2});
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
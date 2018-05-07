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
    <title>商品分类</title>

    <link rel="stylesheet" href="lib/zTree/v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
</head>
<body>
<%--首页 > 商品管理 > 商品分类--%>
<nav class="breadcrumb">
    <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 商品管理 &gt; 商品分类
</nav>
<table class="table">
    <tr>
        <td width="180px" class="va-t" style="padding-left: 50px;padding-top: 30px;">
            <ul id="treeDemo" class="ztree"></ul>
        </td>
        <td class="va-t">
            <div class="page-container">
                <div style="margin-left: 10px;margin-right: 10px" class="cl pd-5 bg-1 bk-gray">
                    <span class="l">
                        <a href="javascript:;" onclick="categoryDel()" class="btn btn-danger radius"><i class="Hui-iconfont">&#xe6e2;</i> 删除所选节点</a>
                        <a class="btn btn-primary radius" onclick="categoryAdd('添加节点','product-category-add')" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i> 添加节点</a>
                        <a class="btn btn-primary radius" onclick="categoryRootAdd('添加根节点','product-category-add')" href="javascript:;"><i class="Hui-iconfont">&#xe600;</i> 添加根节点</a>
                        <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新"><i class="Hui-iconfont">&#xe68f;</i> 刷新</a>
                    </span>
                </div>

                <form id="category-edit" class="form form-horizontal" method="post" action="">
                    <%-- -1表示所有商品，-2表示未选择任何分类 --%>
                    <input type="text" hidden class="input-text" id="id" name="id" value="-2"/>
                    <input type="text" hidden class="input-text" value="0" id="parentId" name="parentId" />
                    <input type="text" hidden class="input-text" value="1" id="status" name="status" />
                    <input type="text" hidden class="input-text" value="true" id="isParent" name="isParent" />
                    <div class="row cl">
                        <label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>分类名称：</label>
                        <div class="formControls col-xs-6 col-sm-6">
                            <input id="name" name="name" type="text" class="input-text" placeholder="请选择左侧要修改的类别" value="">
                        </div>
                    </div>
                    <div class="row cl">
                        <label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>是否为父节点</label>
                        <div class="formControls col-xs-6 col-sm-6">
                            <div id="switch_isparent" class="switch" data-on-label="是" data-on="info" data-off-label="否">
                                <input type="checkbox" checked />
                            </div>
                        </div>
                    </div>
                    <div class="row cl" id="choose-parent">
                        <label class="form-label col-xs-4 col-sm-2">更改父节点：</label>
                        <div class="formControls col-xs-8 col-sm-9">
                            <input id="parentName" name="parentName" type="text" onclick="changeParent()" readonly class="input-text" value="" placeholder="请点击选择其父节点" style="width:48%">
                            <input type="button" onclick="changeParent()" class="btn btn-secondary radius" value="更改父节点">
                        </div>
                    </div>
                    <div class="row cl">
                        <label class="form-label col-xs-4 col-sm-2">
                            <span class="c-red">*</span>排序优先值：</label>
                        <div class="formControls col-xs-6 col-sm-6">
                            <input id="sortOrder" name="sortOrder" type="text" class="input-text" value="" placeholder="请输入0~9999，值越小排序越前" >
                        </div>
                    </div>
                    <div class="row cl">
                        <label class="form-label col-xs-4 col-sm-2"><span class="c-red">*</span>是否启用：</label>
                        <div class="formControls col-xs-6 col-sm-6">
                            <div id="switch_status" class="switch" data-on-label="启用" data-on="info" data-off-label="禁用">
                                <input type="checkbox" checked />
                            </div>
                        </div>
                    </div>
                    <div class="row cl">
                        <label class="form-label col-xs-4 col-sm-2">备注：</label>
                        <div class="formControls col-xs-6 col-sm-6">
                            <textarea id="remark" name="remark" cols="" rows="" class="textarea"  placeholder="备注...最多输入100个字符"></textarea>
                        </div>
                    </div>
                    <div class="row cl">
                        <div class="col-9 col-offset-2">
                            <input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交修改&nbsp;&nbsp;">
                        </div>
                    </div>
                </form>
            </div>
        </td>
    </tr>
</table>

<!--_footer 作为公共模版分离出去-->
<script type="text/javascript" src="lib/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="static/h-ui/js/H-ui.min.js"></script>
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script> <!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<%--ztree--%>
<script type="text/javascript" src="lib/zTree/v3/js/jquery.ztree.all-3.5.min.js"></script>
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

    function changeParent(){
        layer_show("更改父节点","choose-category-isparent",300,510);
    }
    /*与“更改父节点”弹出的choose-category页面，使用parent调用该方法*/
    function getCidAndName(cid, cname) {
        $("#parentId").val(cid);
        $("#parentName").val(cname);
    }

    /*ztree属性*/
    var isParent = false,id="",name="";
    var index = layer.load(3);
    /*ztree配置*/
    var settings = {
        view: {
            dblClickExpand: true,
            showLine: false,
            selectedMulti: false
        },
        data: {
            simpleData: {
                enable:true,
                idKey: "id",
                pIdKey: "pId",
                rootPId: ""
            }
        },
        async: {
            enable: true,
            url: "${URL}/item/cat/list",
            type: "GET",
            contentType: "application/json",
            autoParam: ["id"]
        },
        callback: {
            onAsyncSuccess: function(){
                layer.close(index);
            },
            beforeClick: function(treeId, treeNode){
                /*节点名字*/
                $("#name").val(treeNode.name);
                $("#id").val(treeNode.id);
                $("#sortOrder").val(treeNode.sortOrder);
                /*备注*/
                $("#remark").val(treeNode.remark);
                $("#parentId").val(treeNode.pId);
                if($("#parentId").val()==""){
                    $("#parentId").val(0);
                }
                if(treeNode.pId!=0){
                    $("#parentName").val(treeNode.getParentNode().name);
                }else{
                    $("#parentName").val("");
                }
                changeStatusSwitch(treeNode.status);
                id = treeNode.id;
                name = treeNode.name;
                if(treeNode.isParent){
                    isParent = true;
                    changeIsParentSwitch(1);
                }else{
                    isParent = false;
                    changeIsParentSwitch(0);
                }
                return true;
            }
        }
    };

    function changeStatusSwitch(value){
        if(value == 1){
            $("#switch_status").bootstrapSwitch('setState',true);
        }else{
            $("#switch_status").bootstrapSwitch('setState',false);
        }
    }

    /*switch手动点击的话修改状态*/
    $("#switch_status").on('switch-change',function(e, data){
        if(data.value == true){
            $('#status').val(1);
        }else{
            $('#status').val(0);
        }
    });

    function changeIsParentSwitch(value){
        if(value == 1){
            $("#switch_isparent").bootstrapSwitch('setState',true);
            $('#isParent').val(true);
        }else{
            $("#switch_isparent").bootstrapSwitch('setState',false);
            $('#isParent').val(false);
        }
    }

    /*switch手动点击的话修改状态*/
    $('#switch_isparent').on('switch-change',function (e, data) {
        if(data.value == true){
            $('#isParent').val(true);
        }else{
            $('#isParent').val(false);
        }
    });

    /*显示ztree*/
    initZtree();

    function initZtree(){
        var t = $("#treeDemo");
        t = $.fn.zTree.init(t, settings);
        var zTree = $.fn.zTree.getZTreeObj("tree");
    }

    $("#category-edit").validate({
        rules: {
            name:{
                required:true,
                minlength:1,
                maxlength:25
            },
            sortOrder:{
                required:true,
                digits:true,
                maxlength:4
            }
        },
        onkeyup:false,
        focusCleanup:false,
        success:"valid",
        submitHandler:function(form){
            if($("#id").val()==null||$("#id").val()=="-2"){
                layer.alert('请点击 [左侧] 选择要修改的分类！请勿自己填写! ', {title: '错误信息',icon: 0});
                return;
            }
            var index = layer.load(3);
            $(form).ajaxSubmit({
                type: 'POST',
                url: '${URL}/item/cat/update',
                success: function(data){
                    layer.close(index);
                    if(data.success == true){
                        initZtree();
                        layer.msg('更新成功',{icon: 1,time: 1000});
                    }else{
                        layer.alert('更新失败!'+data.message,{title: '错误信息',icon: 2});
                    }
                },
                error: function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败!错误码：'+ XMLHttpRequest.status, {title: '错误信息',icon: 2});
                }
            });
        }
    });

    /*是否是根节点（在最顶层的节点）*/
    var isRoot = false;
    /*添加节点*/
    function categoryAdd(title, url){
        if(!isParent){
            layer.alert('请先选择一个父节点！',{title: '错误信息',icon: 0});
            return false;
        }
        isRoot = false;
        layer_show(title,url,700,350);
    }

    /*添加根节点*/
    function categoryRootAdd(title,url){
        isRoot=true;
        layer_show(title,url,700,350);
    }

   /*删除节点*/
   function categoryDel(){
       var id = $('#id').val();
       console.log("id="+id);
       if(id == -2 ){
           layer.alert('请选择要删除的节点!',{title: '错误信息',icon: 0});
           return;
       }
       if(id == -1){
           layer.alert('抱歉，该节点不能删除!',{title: '错误信息',icon: 0});
           return;
       }
       layer.confirm(isParent?'确定要删除[ '+ name + ' ]吗？<div style="color:red;">警告：这将删除其所有子节点！</div>':'确定要删除[ ' + name + ']吗？',{icon: 0}, function(){
           var index = layer.load(3);
           $.ajax({
               type: 'POST',
               url: '${URL}/item/cat/del/'+id,
               dataType: 'json',
               success: function(data){
                   layer.close(index);
                   if(data.success == true){
                       initZtree();
                       layer.msg('删除成功！',{icon: 1, time: 1000});
                   }else{
                       layer.alert('删除失败！'+data.msg,{title: '错误信息',icon: 2});
                   }
               },
               error: function(XMLHttpRequest){
                   layer.close(index);
                   layer.alert('数据处理错误！错误码：'+ XMLHttpRequest.status,{title: '错误信息', icon: 2});
               }
           });
       });
   }

   /*回调结果显示，这里是product-categiry-add.jsp调用*/
    function msgSuccess(content){
        layer.msg(content, {icon: 1,time:3000});
    }
</script>
</body>
</html>
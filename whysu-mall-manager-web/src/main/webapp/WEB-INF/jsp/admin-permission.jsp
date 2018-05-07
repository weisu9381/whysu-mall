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
    <title>权限管理</title>
</head>
<style>
    .table > tbody > tr > td {
        text-align: center;
    }
</style>
<body>
<div>
    <%--首页 > 管理员管理 > 权限管理 --%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 管理员管理 &gt; 权限管理
    </nav>
    <form class="page-container">
        <%--批量删除，添加权限--%>
        <div class="cl pd-5 bg-1 bk-gray">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a href="jaavscript:;" onclick="permission_add('添加角色','admin-permission-add',500,250)" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe600;</i> 添加权限
                </a>
                 <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新">
                     <i class="Hui-iconfont">&#xe68f;</i> 刷新
                 </a>
            </span>
            <span class="r">共有数据：<strong id="totalCount">0</strong> 条</span>
        </div>
        <%--DataTable--%>
        <div class="mt-15">
            <table class="table table-border table-bordered table-bg table-hover table-sort" width="100%">
                <thead>
                <tr class="text-c">
                    <th width="25"><input type="checkbox" value="" name=""></th>
                    <th width="40">ID</th>
                    <th width="200">权限名称</th>
                    <th>字段名</th>
                    <th width="70">操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </form>
</div>

<!--_footer 作为公共模版分离出去-->
<script type="text/javascript" src="lib/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="static/h-ui/js/H-ui.min.js"></script>
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script> <!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<%--jquery的表格DataTables--%>
<script type="text/javascript" src="lib/datatables/1.10.0/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="lib/datatables/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="lib/laypage/1.2/laypage.js"></script>
<script type="text/javascript" src="lib/common.js"></script>
<script type="text/javascript">

    $(document).ready(function(){
        $(".table").DataTable({
            "processing": true,//加载显示提示
            "ajax": {
                url: "${URL}/user/permissionList",
                type: "GET"
            },
            "columns": [
                {
                    "data": null,
                    render: function(data, type, row, meta){
                        return '<input type="checkbox" name="checkbox" value="'+ row.id+'">';
                    }
                },
                {"data": "id"},
                {"data": "name"},
                {"data": "permission"},
                {
                    "data": null,
                    render: function(data, type, row, meta){
                        return '<a style="text-decoration: none;" class="ml-5" onclick="permission_edit(\'权限编辑\',\'admin-permission-edit\','+ row.id+',500,250)" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> ' +
                            '<a style="text-decoration: none;" class="ml-5" onclick="permission_del('+row.id+')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                    }
                }
            ],
            "aaSorting": [[ 1, "desc" ]],//默认第几个排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                {"orderable":false,"aTargets":[0,4]}// 制定列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    });

    /*显示“共有数据：X 条*/
    permissionCount();

    function permissionCount(){
        $.ajax({
            type: 'GET',
            url: '${URL}/user/permissionCount',
            success: function(data){
                $("#totalCount").html(data.result);
            },
            error:function(XMLHttpRequest){
                if(XMLHttpRequest.status!=200){
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            }
        });
    }

    /*添加权限*/
    function permission_add(title,url,w,h){
        layer_show(title,url,w,h);
    }

    var permId=-1,name="",permission="";
    /*编辑权限*/
    function permission_edit(title,url,id,w,h){
        permId=id;
        var table = $('.table').DataTable();
        $('.table tbody').on( 'click', 'tr', function () {
            name = table.row(this).data().name;
            permission = table.row(this).data().permission;
        });
        layer_show(title,url,w,h);
    }

    /*删除权限*/
    function permission_del(id){
        layer.confirm('确定要删除id为 '+ id + ' 的权限吗？',{icon: 0}, function(){
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delPermission/'+ id,
                dataType: 'json',
                success: function(data){
                    layer.close(index);
                    if(data.success == true){
                        layer.msg('删除成功!',{icon:1,time:1000});
                        permissionCount();
                        refresh();
                    }else{
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                    }
                },
                error: function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        })
    }

    /*批量删除*/
    function dataDel(){
        var count = 0, ids = "";
        var cks = document.getElementsByName("checkbox");
        for(var i = 0; i < cks.length; i++){
            if(cks[i].checked){
                count++;
                ids += cks[i].value + ",";
            }
        }
        if(count == 0){
            layer.confirm('您还未勾选任何数据!', {
                btn: ['知道了'], icon: 2
            });
            return;
        }
        /*去除末尾逗号*/
        if(ids.length>0){
            ids=ids.substring(0,ids.length-1);
        }
        layer.confirm('确定要删除所选的 '+ count + '条数据吗？',{icon: 0},function(){
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delPermission/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    layer.msg('删除成功！',{icon:1,time:1000});
                    permissionCount();
                    refresh();
                },
                error:function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });

    }

    function msgSuccess(content){
        layer.msg(content, {icon: 1,time:3000});
    }
</script>
</body>
</html>
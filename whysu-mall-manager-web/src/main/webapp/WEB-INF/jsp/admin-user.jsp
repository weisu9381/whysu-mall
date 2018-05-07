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
    <title>管理员列表</title>
</head>
<style>
    .table > tbody > tr > td {
        text-align: center;
    }
</style>
<body>
<div>
    <%--首页 > 管理员管理 > 管理员列表 --%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> <a data-href="">首页</a> &gt; 管理员管理 &gt; 管理员列表
    </nav>
    <form class="page-container">
        <%--批量删除，添加商品--%>
        <div class="cl pd-5 bg-1 bk-gray">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a href="jaavscript:;" onclick="admin_add('添加管理员','admin-user-add')" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe600;</i> 添加管理员
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
                    <th width="25"><input type="checkbox" name="" value=""></th>
                    <th width="40">ID</th>
                    <th width="150">登录名</th>
                    <th width="50">性别</th>
                    <th width="90">手机</th>
                    <th width="150">邮箱</th>
                    <th width="130">角色</th>
                    <th width="100">备注</th>
                    <th width="130">创建时间</th>
                    <th width="130">更新时间</th>
                    <th width="100">是否已启用</th>
                    <th width="100">操作</th>
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

    $(document).ready(function () {
        /*DataTables配置*/
        $(".table").dataTable({
            "processing": true,//加载的时候显示提示
            "ajax": {
                url: '${URL}/user/userList',
                type: 'GET'
            },
            "columns": [
                {
                    "data": null,//第一列，显示checkbox
                    render: function (data, type, row, meta) {
                        return '<input name="checkbox" type="checkbox" value="' + row.id + '" >';
                    }
                },
                {"data": "id"},
                { "data": "username"},
                { "data": "sex"},
                { "data": "phone"},
                { "data": "email"},
                { "data": "roleNames"},
                { "data": "description"},
                {
                    "data": "created",
                    render: function(data, type, row, meta){
                        return date(data);
                    }
                },
                { "data": "updated",
                    render : function(data,type, row, meta) {
                        return date(data);
                    }
                },
                {
                    data: "state",
                    render: function (data, type, row, meta) {
                        if (data == 0) {
                            return '<span class="label label-defant radius td-status">已停用</span>';
                        } else if (data == 1) {
                            return '<span class="label label-success radius td-status">已启用</span>';
                        } else {
                            return '<span class="label label-warning radius td-status">其它状态</span>';
                        }
                    }
                },
                {
                    "data": null,
                    render: function (data, type, row, meta) {
                        if(row.state == 1){
                            //已启用的话，显示“停用”标签
                            return '<a id="td-manager" style="text-decoration: none;" class="ml-5" onclick="admin_stop(' + row.id + ')" href="javascript:;" title="停用"><i class="Hui-iconfont">&#xe631;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="admin_edit(\'编辑\',\'admin-user-edit\',' + row.id + ',800,500)" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a>' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="change_password(\'修改密码\',\'admin-user-change-password\',' + row.id + ',600,270)" href="javascript:;" title="修改密码"><i class="Hui-iconfont">&#xe63f;</i></a>' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="admin_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        }else{
                            //未启用的话，显示“启用”标签
                            return '<a id="td-manager" style="text-decoration: none;" class="ml-5" onclick="admin_start(' + row.id + ')" href="javascript:;" title="启用"><i class="Hui-iconfont">&#xe6e1;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="admin_edit(\'编辑\',\'admin-user-edit\',' + row.id + ',800,500)" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a>' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="change_password(\'修改密码\',\'admin-user-change-password\',' + row.id + ',600,270)" href="javascript:;" title="修改密码"><i class="Hui-iconfont">&#xe63f;</i></a>' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="admin_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        }
                    }
                }
            ],
            "aaSorting": [[8, "desc"]],//默认第几个排序,按照“创建时间”倒序排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                {"orderable": false, "aTargets": [0,11]}// 制定哪些列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    });

    /*显示“共有数据： X 条”*/
    userCount();
    function userCount() {
        $.ajax({
            url:"${URL}/user/userCount",
            type: 'GET',
            success:function (data) {
                if(data.success!=true){
                    layer.alert(data.message,{title: '错误信息',icon: 2});
                    return;
                }
                $("#totalCount").html(data.result);
            },
            error:function(XMLHttpRequest){
                if(XMLHttpRequest.status!=200){
                    layer.alert('获取管理员总数失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            }
        });
    }

    /*管理员-增加*/
    function admin_add(title,url,w,h){
        layer_show(title,url,w,h);
    }

    /*管理员-编辑*/
    var username="",userId=-1,phone="",email="",roleNames="",sex="",description="";
    function admin_edit(title,url,id,w,h){
        userId = id;
        var table = $(".table").DataTable();
        $(".table tbody").on("click","tr",function(){
            username = table.row(this).data().username;
            phone = table.row(this).data().phone;
            email = table.row(this).data().email;
            roleNames = table.row(this).data().roleNames;
            sex = table.row(this).data().sex;
            description = table.row(this).data().description;
        });
        layer_show(title,url,w,h);
    }

    /*管理员-停用*/
    function admin_stop(id){
        layer.confirm('确认要停用ID为\''+id+'\'的用户吗？',{icon:0},function(){
            var index1 = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/stop/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('已停用!',{icon: 1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*管理员-启用*/
    function admin_start(id){
        layer.confirm('确认要启用ID为\''+id+'\'的用户吗？',{icon:3},function(index){
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/start/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('已启用!',{icon: 1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*密码-修改*/
    function change_password(title,url,id,w,h){
        userId=id;
        var table = $('.table').DataTable();
        $('.table tbody').on( 'click', 'tr', function () {
            username = table.row(this).data().username;
        });
        layer_show(title,url,w,h);
    }

    /*管理员-删除*/
    function admin_del(id){
        layer.confirm('确认要删除ID为\''+id+'\'的用户吗？',{icon:0},function(){
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delUser/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    userCount();
                    refresh();
                    layer.msg('已删除!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
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
            layer.confirm('您还未勾选任何数据！',{btn: ['知道了'],icon: 2});
            return;
        }
        /*去除末尾否好*/
        if(ids.length > 0){
            ids = ids.substring(0, ids.length - 1);
        }
        layer.confirm('确定要删除所选的 '+ count + '条数据吗?', {icon: 0}, function(){
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delUser/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    layer.msg('已删除!',{icon:1,time:1000});
                    userCount();
                    refresh();
                },
                error:function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    function msgSuccess(content) {
        layer.msg(content, {icon: 1, time: 3000});
    }

</script>
</body>
</html>
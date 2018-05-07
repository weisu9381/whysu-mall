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
    <title>角色管理</title>
</head>
<style>
    .table > tbody > tr > td {
        text-align: center;
    }
</style>
<body>
<div>
    <%--首页 > 管理员管理 > 角色管理 --%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 管理员管理 &gt; 角色管理
    </nav>
    <form class="page-container">
        <%--批量删除，添加商品--%>
        <div class="cl pd-5 bg-1 bk-gray">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a href="jaavscript:;" onclick="admin_role_add('添加角色','admin-role-add')" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe600;</i> 添加角色
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
                    <th width="200">角色名</th>
                    <th width="600">拥有权限</th>
                    <th width="300">描述</th>
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
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script>
<!--/_footer 作为公共模版分离出去-->

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
                url: '${URL}/user/roleList',
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
                {"data": "name"},
                {"data": "permissions"},
                {"data": "description"},
                {
                    "data": null,
                    render: function (data, type, row, meta) {
                        return '<a style="text-decoration: none;" class="ml-5" onclick="admin_role_edit(\'角色编辑\',\'admin-role-edit\',' + row.id + ')" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> <a style="text-decoration: none;" class="ml-5" onclick="admin_role_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                    }
                }
            ],
            "aaSorting": [[1, "asc"]],//默认第几个排序,序号从0开始数，这里按id排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                {"orderable": false, "aTargets": [0, 3, 5]}// 制定哪些列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    });

    /*加载页面时，显示“共有数据：0 条”*/
    roleCount();

    function roleCount() {
        $.ajax({
            type: 'GET',
            url: '${URL}/user/roleCount',
            success: function (data) {
                $('#totalCount').html(data.result);
            },
            error: function (XMLHttpRequest) {
                if (XMLHttpRequest.status != 200) {
                    layer.alert('数据处理错误，错误码：' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                }
            }
        });
    }

    /*管理员角色添加*/
    function admin_role_add(title, url, w, h) {
        layer_show(title, url, w, h);
    }

    var roleId = -1, name = "", description = "", permissions = "";

    /*角色编辑,注意这里多加了一个参数 id */
    function admin_role_edit(title, url, id, w, h) {
        roleId = id;
        var table = $(".table").DataTable();
        $(".table tbody").on('click', 'tr', function () {
            name = table.row(this).data().name;
            description = table.row(this).data().description;
            permissions = table.row(this).data().permissions;
        });
        layer_show(title, url, w, h);
    }

    /*角色删除*/
    function admin_role_del(id) {
        layer.confirm('确定要删除ID为 ' + id + '的角色吗？', {icon: 0}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delRole/' + id,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success == true) {
                        layer.msg('删除成功！', {icon: 1, time: 1000});
                        roleCount();
                        refresh();
                    } else {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                    }
                },
                error: function (XMLHttpRequest) {
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                }
            });
        });
    }

    /*批量删除角色*/
    function dataDel() {
        var cks = document.getElementsByName("checkbox");
        var count = 0, ids = "";
        for (var i = 0; i < cks.length; i++) {
            if (cks[i].checked) {
                count++;
                ids += cks[i].value + ",";
            }
        }
        if (count == 0) {
            layer.confirm('您还未勾选任何数据!', {
                btn: ['知道了'], icon: 2
            });
            return;
        }
        /*去除末尾逗号*/
        if (ids.length > 0) {
            ids = ids.substring(0, ids.length - 1);
        }
        layer.confirm('确认要删除所选的 ' + count + ' 条数据吗？', {icon: 0}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/user/delRole/' + ids,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success == true) {
                        layer.msg('删除成功!', {icon: 1, time: 1000});
                        roleCount();
                        refresh();
                    } else {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                    }
                },
                error: function (XMLHttpRequest) {
                    layer.close(index);
                    layer.alert('数据处理失败! 错误码:' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
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
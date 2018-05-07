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
    <title>用户列表</title>
</head>
<style>
    .table > tbody > tr > td {
        text-align: center;
    }
</style>
<body>
<div>
    <%--首页 > 用户中心 > 用户管理--%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 用户中心 &gt; 用户管理
    </nav>
    <div class="page-container">
        <%--按日期搜索--%>
        <form id="form-search" class="text-c">
            创建日期：
            <input type="text" onfocus="WdatePicker({ maxDate:'#F{$dp.$D(\'maxDate\')||\'%y-%M-%d\'}' })" id="minDate"
                   name="minDate" class="input-text Wdate" style="width:120px;"/>
            -
            <input type="text" onfocus="WdatePicker({ minDate:'#F{$dp.$D(\'minDate\')}',maxDate:'%y-%M-%d' })"
                   id="maxDate" name="maxDate" class="input-text Wdate" style="width:120px;"/>
            <input type="text" name="searchKey" id="searchKey" placeholder=" 输入会员名称、电话、邮箱等信息" style="width:250px"
                   class="input-text"/>
            <button id="searchButton" type="submit" class="btn btn-success">
                <i class="Hui-iconfont">&#xe665;</i>搜索用户
            </button>
        </form>
        <%--批量移除，添加用户--%>
        <div class="cl pd-5 bg-1 bk-gray mt-20">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量移除
                </a>
                <a href="jaavscript:;" onclick="member_add('添加用户','member-add','',630)" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe600;</i> 添加用户
                </a>
                 <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新">
                     <i class="Hui-iconfont">&#xe68f;</i> 刷新
                 </a>
            </span>
            <span class="r">共有数据：<strong id="memberListCount">0</strong> 条</span>
        </div>
        <%--DataTable--%>
        <div class="mt-20">
            <table class="table table-border table-bordered table-bg table-hover table-sort" width="100%">
                <thead>
                <tr class="text-c">
                    <th width="30"><input type="checkbox" name="" value=""></th>
                    <th width="40">ID</th>
                    <th width="80">用户名</th>
                    <th width="40">性别</th>
                    <th width="90">手机</th>
                    <th width="100">邮箱</th>
                    <th width="120">地址</th>
                    <th width="90">创建时间</th>
                    <th width="90">更新时间</th>
                    <th width="50">状态</th>
                    <th width="110">操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<!--_footer 作为公共模版分离出去-->
<script type="text/javascript" src="lib/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="lib/layer/2.4/layer.js"></script>
<script type="text/javascript" src="static/h-ui/js/H-ui.min.js"></script>
<script type="text/javascript" src="static/h-ui.admin/js/H-ui.admin.js"></script> <!--/_footer 作为公共模版分离出去-->

<!--请在下方写此页面业务相关的脚本-->
<%--My97DatePicker日期控件--%>
<script type="text/javascript" src="lib/My97DatePicker/4.8/WdatePicker.js"></script>
<%--jquery的表格DataTables--%>
<script type="text/javascript" src="lib/datatables/1.10.0/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="lib/datatables/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="lib/laypage/1.2/laypage.js"></script>
<script type="text/javascript" src="lib/common.js"></script>
<%--表单验证--%>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/jquery.validate.js"></script>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/validate-methods.js"></script>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/messages_zh.js"></script>
<script type="text/javascript">

    $(function(){
        $(".table").dataTable({
            serverSide: true,//开启服务器模式
            "processing": true,//加载显示提示
            "ajax": {
                url: '${URL}/member/list',
                type: 'GET',
                data: {
                    "searchKey": "",
                    "minDate": "",
                    "maxDate": ""
                }
            },
            "columns": [
                {
                    "data": null,
                    render: function(data, type, row, meta){
                        return '<input name="checkbox" value="' + row.id + '" type="checkbox" >';
                    }
                },
                { "data": "id"},
                { "data": "username"},
                { "data": "sex"},
                { "data": "phone"},
                { "data": "email"},
                { "data": "address"},
                {
                    "data": "created",
                    render : function(data,type, row, meta) {
                        return date(data);
                    }
                },
                {
                    "data": "updated",
                    render : function(data,type, row, meta) {
                        return date(data);
                    }
                },
                {
                    "data": "state",
                    render : function(data,type, row, meta) {
                        if(data==0){
                            return "<span class=\"label label-defant radius td-status\">已停用</span>";
                        }else if(data==1){
                            return "<span class=\"label label-success radius td-status\">已启用</span>";
                        }else{
                            return "<span class=\"label label-warning radius td-status\">其它态</span>";
                        }
                    }
                },
                {
                    "data": null,
                    render: function(data,type, row, meta) {
                        if(row.state == 1){
                            //用户已启用，显示“停用”标签
                            return '<a style="text-decoration: none;" onclick="member_stop(' + row.id + ')" href="javascript:;" title="停用"><i class="Hui-iconfont">&#xe6de;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="member_edit(\'编辑\',\'member-edit\',' + row.id + ',800,500)" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="change_password(\'修改密码\',\'member-change-password\',' + row.id + ',600,270)" href="javascript:;" title="修改密码"><i class="Hui-iconfont">&#xe63f;</i></a>'+
                                '<a style="text-decoration: none;" class="ml-5" onclick="member_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        }else{
                            //用户未启用，显示“启用”标签
                            return '<a style="text-decoration: none;" onclick="member_start(' + row.id + ')" href="javascript:;" title="启用"><i class="Hui-iconfont">&#xe603;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="member_edit(\'编辑\',\'member-edit\',' + row.id + ',800,500)" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="change_password(\'修改密码\',\'member-change-password\',' + row.id + ',600,270)" href="javascript:;" title="修改密码"><i class="Hui-iconfont">&#xe63f;</i></a>'+
                                '<a style="text-decoration: none;" class="ml-5" onclick="member_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        }
                    }
                }
            ],
            "aaSorting": [[ 7, "desc" ]],//默认第几个排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                //{"bVisible": false, "aTargets": [ 3 ]} //控制列的隐藏显示
                {"orderable":false,"aTargets":[0,10]}// 制定列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    });

    member_count();

    /!*统计用户数*!/
    function member_count(){
        $.ajax({
            url:"${URL}/member/count",
            type:"GET",
            success:function (data) {
                $("#memberListCount").html(data.recordsTotal);
            },
            error:function(XMLHttpRequest){
                layer.alert('获取用户数失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
            }
        });
    }

    /*多条件查询*/
    $("#form-search").validate({
        rules: {
            minDate: {
                required: true
            },
            maxDate: {
                required: true
            },
            searchKey: {
                required: false
            }
        },
        onkeyup:false,
        focusCleanup:false,
        success:"valid",
        submitHandler:function(form){
            var searchKey= $('#searchKey').val();
            var minDate= $('#minDate').val();
            var maxDate= $('#maxDate').val();
            var param = {
                "searchKey": searchKey,
                "minDate": minDate,
                "maxDate":maxDate
            };
            var table = $('.table').DataTable();
            table.settings()[0].ajax.data = param;
            table.ajax.reload();
        }
    });

    /*添加用户*/
    function member_add(title, url,w,h){
        layer_show(title,url,w,h);
    }

    /*用户-停用*/
    function member_stop(id){
        layer.confirm('确认要停用ID为\''+id+'\'的会员吗？',{icon:0},function(index){
            var index = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/stop/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('已停用!',{icon: 1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index);
                    layer.alert('用户停用失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*用户-启用*/
    function member_start(id){
        layer.confirm('确认要启用ID为\''+id+'\'的会员吗？',{icon:3},function(index){
            var index1 = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/start/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('已启用!',{icon: 6,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('用户启用失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    var Id="",username="",phone="",email="",description="",sex="",address="",created="",balance="",points="",file="";
    /*用户-编辑*/
    function member_edit(title,url,id,w,h){
        Id=id;
        var table = $('.table').DataTable();
        $('.table tbody').on( 'click', 'tr', function () {
            username = table.row(this).data().username;
            phone = table.row(this).data().phone;
            email = table.row(this).data().email;
            description = table.row(this).data().description;
            sex = table.row(this).data().sex;
            address = table.row(this).data().address;
        });
        layer_show(title,url,w,h);
    }

    /*密码-修改*/
    function change_password(title,url,id,w,h){
        Id=id;
        var table = $('.table').DataTable();
        $('.table tbody').on( 'click', 'tr', function () {
            username = table.row(this).data().username;
        });
        layer_show(title,url,w,h);
    }

    /*用户-移除(只是将状态变为“已移除”状态)*/
    function member_del(id){
        layer.confirm('确认要删除ID为\''+id+'\'的会员吗？',{icon:0},function(index){
            var index1 = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/remove/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    member_count();
                    refresh();
                    layer.msg('已移除!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('移除用户失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*批量移除*/
    function dataDel() {
        var cks=document.getElementsByName("checkbox");
        var count=0,ids="";
        for(var i=0;i<cks.length;i++){
            if(cks[i].checked){
                count++;
                ids+=cks[i].value+",";
            }
        }
        if(count==0){
            layer.confirm('您还未勾选任何数据!',{btn: ['知道了'] ,icon: 0});
            return;
        }
        /*去除末尾逗号*/
        if(ids.length>0){
            ids=ids.substring(0,ids.length-1);
        }
        layer.confirm('确认要移除所选的'+count+'条数据吗？',{icon:0},function(index){
            var index1 = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/remove/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    layer.msg('已移除!',{icon:1,time:1000});
                    member_count();
                    refresh();
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('批移除用户失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    function msgSuccess(content){
        layer.msg(content, {icon:1, time: 3000});
    }
</script>
</body>
</html>
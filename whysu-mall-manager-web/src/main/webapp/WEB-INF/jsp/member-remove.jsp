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
    <title>移除的会员</title>
</head>
<style>
    .table > tbody > tr > td {
        text-align: center;
    }
</style>
<body>
<div>
    <%--首页 > 会员管理 > 移除的会员--%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 会员管理 &gt; 移除的会员
    </nav>
    <div class="page-container">
        <%--按日期搜索--%>
        <form id="form-search" class="text-c">
            创建日期：
            <input type="text" onfocus="WdatePicker({ startDate:'%y-%M-%d 00:00:00',maxDate:'#F{$dp.$D(\'maxDate\')||\'%y-%M-%d\'}' })" id="minDate"
                   name="minDate" class="input-text Wdate" style="width:120px;"/>
            -
            <input type="text" onfocus="WdatePicker({ startDate:'%y-%M-%d 23:59:59',minDate:'#F{$dp.$D(\'minDate\')}',maxDate:'%y-%M-%d' })"
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
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a href="jaavscript:;" onclick="restoreAll()" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe66b;</i> 批量还原
                </a>
                 <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新">
                     <i class="Hui-iconfont">&#xe68f;</i> 刷新
                 </a>
            </span>
            <span class="r">共有数据：<strong id="memberRemoveListCount">0</strong> 条</span>
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
                    <th width="110">邮箱</th>
                    <th width="130">地址</th>
                    <th width="100">创建时间</th>
                    <th width="50">状态</th>
                    <th width="100">操作</th>
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
        $('.table').dataTable({
            serverSide: true,//开启服务器模式
            "processing": true,//加载显示提示
            "ajax": {
                url:"${URL}/member/list/remove",
                type: 'GET',
                data:{
                    "searchKey": "",
                    "minDate": "",
                    "maxDate": ""
                },
                error:function(XMLHttpRequest){
                    layer.alert('获取移除用户列表失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            },
            "columns": [
                { "data": null,
                    render : function(data,type, row, meta) {
                        return "<input name=\"checkbox\" value=\""+row.id+"\" type=\"checkbox\" value=\"\">";
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
                { "data": "state",
                    render : function(data,type, row, meta) {
                        if(data==2){
                            return "<span class=\"label label-danger radius td-status\">已移除</span>";
                        }else{
                            return "<span class=\"label label-warning radius td-status\">其它态</span>";
                        }
                    }
                },
                { "data": null,
                    render : function(data,type, row, meta) {
                        return "<a style=\"text-decoration:none\" href=\"javascript:;\" onClick=\"member_restore("+row.id+")\" title=\"还原\"><i class=\"Hui-iconfont\">&#xe66b;</i></a> " +
                            "<a title=\"彻底删除\" href=\"javascript:;\" onclick=\"member_del("+row.id+")\" class=\"ml-5\" style=\"text-decoration:none\"><i class=\"Hui-iconfont\">&#xe6e2;</i></a>";
                    }
                }
            ],
            "aaSorting": [[ 1, "desc" ]],//默认第几个排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                //{"bVisible": false, "aTargets": [ 3 ]} //控制列的隐藏显示
                {"orderable":false,"aTargets":[0,8,9]}// 制定列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });

    });

    memberRemoveCount();

    /*统计移除用户数*/
    function memberRemoveCount(){
        $.ajax({
            url:"${URL}/member/count/remove",
            type:"GET",
            success:function (data) {
                $("#memberRemoveListCount").html(data.recordsTotal);
            },
            error:function(XMLHttpRequest){
                layer.alert('获取移除用户总数失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
            }
        });
    }

    /*多条件查询*/
    $("#form-search").validate({
        rules:{
            minDate:{
                required:true
            },
            maxDate:{
                required:true
            },
            searchKey:{
                required:false
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
            table.ajax.url('${URL}/member/list/remove').load();
        }
    });

    /*用户-还原*/
    function member_restore(id){
        layer.confirm('确认要还原ID为\''+id+'\'的会员吗？',{icon:3},function(){
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/start/'+id,
                dataType: 'json',
                success: function(data){
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return ;
                    }
                    memberRemoveCount();
                    refresh();
                    layer.msg('已还原!',{icon: 6,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.alert('还原用户失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*用户-删除*/
    function member_del(id){
        layer.confirm('确认要彻底删除ID为\''+id+'\'的会员吗？',{icon:0},function(index){
            $.ajax({
                type: 'POST',
                url: '${URL}/member/del/'+id,
                dataType: 'json',
                success: function(data){
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return ;
                    }
                    memberRemoveCount();
                    refresh();
                    layer.msg('已彻底删除!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.alert('用户删除失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*批量删除*/
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
            layer.confirm('您还未勾选任何数据!',{btn: ['知道了'],icon:0});
            return;
        }
        /*去除末尾逗号*/
        if(ids.length>0){
            ids=ids.substring(0,ids.length-1);
        }
        layer.confirm('确认要彻底删除所选的'+count+'条数据吗？',{icon:0},function(){
            var index1 = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/member/del/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    memberRemoveCount();
                    refresh();
                    layer.msg('已删除!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('批量删除用户失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*批量还原*/
    function restoreAll(){
        var cks=document.getElementsByName("checkbox");
        var count=0,ids="";
        for(var i=0;i<cks.length;i++){
            if(cks[i].checked){
                count++;
                ids+=cks[i].value+",";
            }
        }
        if(count==0){
            layer.confirm('您还未勾选任何数据!',{btn: ['知道了'],icon:0});
            return;
        }
        /*去除末尾逗号*/
        if(ids.length>0){
            ids=ids.substring(0,ids.length-1);
        }
        layer.confirm('确认要还原所选的'+count+'条数据吗？',{icon:0},function(){
            var index1 = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/member/start/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    memberRemoveCount();
                    refresh();
                    layer.msg('已还原!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });

        });
    }
</script>
</body>
</html>
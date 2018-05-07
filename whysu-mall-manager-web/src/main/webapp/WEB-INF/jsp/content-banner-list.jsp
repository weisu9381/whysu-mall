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
    <title>首页轮播图板块</title>
</head>
<style>
    .table>tbody>tr>td{
        text-align:center;
    }
</style>

<body>
<div>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 商城管理 &gt; 首页轮播图管理
    </nav>
    <form id="form-content-banner-list" class="page-container">
        <div class="cl pd-5 bg-1 bk-gray mt-20">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a class="btn btn-primary radius" onclick="content_banner_add('添加轮播图','content-banner-add')" href="javascript:;">
                    <i class="Hui-iconfont">&#xe600;</i> 添加轮播图
                </a>
                <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新">
                    <i class="Hui-iconfont">&#xe68f;</i> 刷新
                </a>
            </span>
            <span class="r">最大容纳商品数：<strong id="limitNum"></strong></span>
        </div>
        <div class="mt-20">
            <div class="mt-20" style="margin-bottom: 70px">
                <table class="table table-border table-bordered table-bg table-hover table-sort" width="100%">
                    <thead>
                    <tr class="text-c">
                        <th width="30"><input name="" type="checkbox" value=""></th>
                        <th width="40">ID</th>
                        <th width="50">类型</th>
                        <th width="100">图片1</th>
                        <th width="100">图片2</th>
                        <th width="100">图片3</th>
                        <th width="100">跳转链接</th>
                        <th width="100">展示商品ID</th>
                        <th width="150">商品名称</th>
                        <th width="60">排序值</th>
                        <th width="95">创建日期</th>
                        <th width="95">更新日期</th>
                        <th width="90">操作</th>
                    </tr>
                    </thead>
                </table>
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
<%--DataTables--%>
<script type="text/javascript" src="lib/datatables/1.10.0/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="lib/datatables/dataTables.colReorder.min.js"></script>
<script type="text/javascript" src="lib/laypage/1.2/laypage.js"></script>
<script type="text/javascript" src="lib/common.js"></script>
<script type="text/javascript">

    function imageShow(data){
        if(data==""||data==null){
            return "";
        }
        var images= new Array(); //定义一数组
        images=data.split(","); //字符分割
        if(images.length>0){
            return images[0];
        }else{
            return data;
        }
    }

    /*获取轮播图的ID, 最大限制数量limitCount，以及当前的数量currentCount*/
    var panelId=1,limitCount=0,currentCount=0,name="",position=0,panelType=0;
    $.ajax({
        type: 'GET',
        url: '${URL}/panel/indexBanner/list',
        dataType: 'json',
        success: function(data){
            if(data.length<=0||data==""){
                return;
            }
            panelId = data[0].id;
            $("#limitNum").html(data[0].limitNum);
            limitCount=data[0].limitNum;
            name=data[0].name;
            panelType=data[0].type;
            /*初始化表格*/
            initTable("${URL}/content/list/"+panelId);
            /*更新当前轮播图数,不能超过limitNum*/
            updateCurrentCount("${URL}/content/list/"+panelId);
        },
        error:function(XMLHttpRequest) {
            layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
        }
    });

    function updateCurrentCount(url) {
        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: function(data){
                currentCount=data.data.length;
            },
            error:function(XMLHttpRequest) {
                layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
            }
        });
    }

    /*datatables配置*/
    function initTable(url){
        $('.table').dataTable({
            "processing": true,//加载显示提示
            "ajax": {
                url: url,
                type: 'GET'
            },
            "columns": [
                { "data": null,
                    render : function(data,type, row, meta) {
                        return "<input name=\"checkbox\" value=\""+row.id+"\" type=\"checkbox\" value=\"\">";
                    }
                },
                { "data": "id"},
                { "data": "type",
                    render : function(data,type, row, meta) {
                        if(data==0){
                            return "<span class=\"label label-success radius td-status\">关联商品</span>";
                        }else if(data==1){
                            return "<span class=\"label label-warning radius td-status\">其他链接</span>";
                        }else if(data==2){
                            return "<span class=\"label label-primary radius td-status\">关联商品(封面)</span>";
                        }
                    }
                },
                { "data": "picUrl",
                    render: function(data, type, row, meta) {
                        return '<img src="'+imageShow(data)+'" style="width: 80px;height: 60px" alt="" />';
                    }
                },
                { "data": "picUrl2",
                    render: function(data, type, row, meta) {
                        return '<img src="'+imageShow(data)+'" style="width: 80px;height: 60px" alt="" />';
                    }
                },
                { "data": "picUrl3",
                    render: function(data, type, row, meta) {
                        return '<img src="'+imageShow(data)+'" style="width: 80px;height: 60px" alt="" />';
                    }
                },
                { "data": "fullUrl"},
                { "data": "productId"},
                { "data": "productName"},
                { "data": "sortOrder"},
                { "data": "created",
                    render : function(data,type, row, meta) {
                        return date(data);
                    }
                },
                { "data": "updated",
                    render : function(data,type, row, meta) {
                        return date(data);
                    }
                },
                {
                    "data": null,
                    render: function (data, type, row, meta) {
                        return "<a style=\"text-decoration:none\" class=\"ml-5\" onClick=\"content_banner_edit('内容编辑','content-banner-edit')\" href=\"javascript:;\" title=\"编辑\"><i class=\"Hui-iconfont\">&#xe6df;</i></a> " +
                            "<a style=\"text-decoration:none\" class=\"ml-5\" onClick=\"content_banner_del("+row.id+")\" href=\"javascript:;\" title=\"删除\"><i class=\"Hui-iconfont\">&#xe6e2;</i></a>";
                    }
                }
            ],
            "aaSorting": [[ 9, "asc" ]],//默认第几个排序
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                {"orderable":false,"aTargets":[0,3,11]}// 制定列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    }

    /*添加轮播图*/
    function content_banner_add(title,url){
        if(currentCount >= limitCount){
            layer.alert('当前板块内容数量已达上限,您可以前往[首页板块管理]修改', {title: '错误信息', icon: 0});
            return;
        }
        var index = layer.open({
            type: 2,
            title: title,
            content: url
        });
        layer.full(index);
    }

    var id=0,productId=0,productName="",fullUrl="",type=0,sortOrder=1;
    /*编辑*/
    function content_banner_edit(title,url){
        var table = $('.table').DataTable();
        $('.table tbody').on( 'click', 'tr', function () {
            id = table.row(this).data().id;
            productId = table.row(this).data().productId;
            productName = table.row(this).data().productName;
            fullUrl = table.row(this).data().fullUrl;
            type = table.row(this).data().type;
            sortOrder = table.row(this).data().sortOrder;
        });
        var index = layer.open({
            type: 2,
            title: title,
            content: url
        });
        layer.full(index);
    }

    /*删除*/
    function content_banner_del(id){
        layer.confirm('确认要删除ID为\''+id+'\'的数据吗？',{icon:0},function(){
            var index1 = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/content/del/'+id,
                dataType: 'json',
                success: function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('成功删除!',{icon:1,time:1000});
                },
                error:function(XMLHttpRequest) {
                    layer.close(index1);
                    layer.alert('数据处理失败! 错误码:'+XMLHttpRequest.status,{title: '错误信息',icon: 2});
                }
            });
        });
    }

    /*批量删除*/
    function dataDel(){
        var cks=document.getElementsByName("checkbox");
        var count=0,ids="";
        for(var i=0;i<cks.length;i++){
            if(cks[i].checked){
                count++;
                ids+=cks[i].value+",";
            }
        }
        if(count==0){
            layer.alert('您还未勾选任何数据!',{icon:0});
            return;
        }
        /*去除末尾逗号*/
        if(ids.length>0){
            ids=ids.substring(0,ids.length-1);
        }
        layer.confirm('确认要删除所选的'+count+'条数据吗？',{icon:0},function(){
            var index1 = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/content/del/'+ids,
                dataType: 'json',
                success:function(data){
                    layer.close(index1);
                    if(data.success!=true){
                        layer.alert(data.message,{title: '错误信息',icon: 2});
                        return;
                    }
                    layer.msg('成功删除!',{icon:1,time:1000});
                    refresh();
                },
                error:function(XMLHttpRequest){
                    layer.close(index1);
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

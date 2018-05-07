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
    <title>商品列表</title>

    <link rel="stylesheet" href="lib/zTree/v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
</head>

<style>
    /*表格全部居中显示(不要写成.table > thead > tr > td)*/
    .table > tbody > tr > td {
        text-align: center;
    }
</style>

<body class="pos-r">
<div class="pos-a" style="width: 200px;background-color:#f5f5f5; overflow:auto;height: 100%;">
    <ul style="margin-left: 20px;margin-top:15px;"><i class="Hui-iconfont Hui-iconfont-fenlei"> 商品分类</i></ul>
    <ul id="treeDemo" class="ztree" style="margin-left: 10px;"></ul>
</div>
<div style="margin-left: 200px">
    <%--首页 > 商品管理 > 商品列表 > 所有商品--%>
    <nav class="breadcrumb">
        <i class="Hui-iconfont">&#xe67f;</i> 首页 &gt; 商品管理 &gt; 商品列表 &gt;
        <span id="category">所有商品</span>
    </nav>
    <form id="form-search" class="page-container">
        <%--按日期搜索--%>
        <div class="text-c">
            创建日期：
            <input type="text" onfocus="WdatePicker({ maxDate:'#F{$dp.$D(\'maxDate\')||\'%y-%M-%d\'}' })" id="minDate"
                   name="minDate" class="input-text Wdate" style="width:120px;"/>
            -
            <input type="text" onfocus="WdatePicker({ minDate:'#F{$dp.$D(\'minDate\')}',maxDate:'%y-%M-%d' })"
                   id="maxDate" name="maxDate" class="input-text Wdate" style="width:120px;"/>
            <input type="text" name="searchKey" id="searchKey" placeholder=" 商品名称、商品描述、价格" style="width:250px"
                   class="input-text"/>
            <button id="searchButton" type="submit" class="btn btn-success">
                <i class="Hui-iconfont">&#xe665;</i>搜索商品
            </button>
        </div>
        <%--批量删除，添加商品--%>
        <div class="cl pd-5 bg-1 bk-gray mt-20">
            <span class="l">
                <a href="javascript:;" onclick="dataDel()" class="btn btn-danger radius">
                    <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
                </a>
                <a href="jaavscript:;" onclick="product_add('添加商品','product-add')" class="btn btn-primary radius">
                    <i class="Hui-iconfont">&#xe600;</i> 添加商品
                </a>
                 <a class="btn btn-secondary radius" href="javascript:location.replace(location.href);" title="刷新">
                     <i class="Hui-iconfont">&#xe68f;</i> 刷新
                 </a>
            </span>
            <span class="r">共有数据：<strong id="itemListCount">0</strong> 条</span>
        </div>
        <%--table--%>
        <div class="mt-20">
            <table class="table table-border table-bordered table-bg table-hover table-sort" width="100%">
                <thead>
                    <tr class="text-c">
                        <th width="30"><input name="" type="checkbox" value=""></th>
                        <th width="40">ID</th>
                        <th width="70">缩略图</th>
                        <th width="150">商品名称</th>
                        <th width="100">描述</th>
                        <th width="60">单价</th>
                        <th width="95">创建日期</th>
                        <th width="95">更新日期</th>
                        <th width="60">发布状态</th>
                        <th width="90">操作</th>
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
<%--ztree--%>
<script type="text/javascript" src="lib/zTree/v3/js/jquery.ztree.all-3.5.min.js"></script>
<%--My97DatePicker日期控件--%>
<script type="text/javascript" src="lib/My97DatePicker/4.8/WdatePicker.js"></script>
<%--jquery的表格DataTables--%>
<script type="text/javascript" src="lib/datatables/1.10.0/jquery.dataTables.min.js"></script>
<%--分页插件laypage--%>
<script type="text/javascript" src="lib/laypage/1.2/laypage.js"></script>
<%----%>
<script type="text/javascript" src="lib/datatables/dataTables.colReorder.min.js"></script>
<%--jquery的数据校验validate--%>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/jquery.validate.js"></script>
<script type="text/javascript" src="lib/jquery.validation/1.14.0/validate-methods.js"></script>
<script type="text/javascript" src="lib/common.js"></script>
<script type="text/javascript">

    var index = layer.load(3);

    var cid = -1;//-1表示“所有商品”

    /*ztree设置*/
    var setting = {
        view: {
            dblClickExpand: true,
            showLine: false,
            selectedMulti: false
        },
        data: {
            simpleData: {
                enable: true,//开启
                idKey: "id",//如此指定的话，json格式为{"id":1, "pId":0, "name":"test1"}, {"id":11, "pId":1, "name":"test11"},
                pIdKey: "pId",
                rootPId: ""
            }
        },
        async: {//异步加载
            enable: true,//开启
            url: "${URL}/item/cat/list",
            type: "GET",
            contentType: "application/json",
            autoParam: ["id"]//异步加载时，自动提交的参数
        },
        callback: {
            onAsyncSuccess: function () {
                layer.close(index);
            },
            beforeClick: function (treeId, treeNode) {
                if (treeNode.isParent) {
                    return false;//如果返回 false，zTree 将不会选中节点，也无法触发 onClick 事件回调函数
                } else {
                    cid = treeNode.id;
                    //显示：首页 > 商品管理 > 商品列表 > XX
                    $("#category").html(treeNode.name);
                    //重新加载表格
                    var table = $(".table").DataTable();
                    var param = {
                        "cid": treeNode.id
                    };
                    table.settings()[0].ajax.data = param;
                    table.ajax.reload();
                    return true;
                }
            }
        }
    };
    /*ztree初始化*/
    $(document).ready(function () {
        var t = $("#treeDemo");
        t = $.fn.zTree.init(t, setting);
        var zTree = $.fn.zTree.getZTreeObj("tree");
    });

    /*DataTables显示图片*/
    function imageShow(data) {
        if (data == null || data == "") {
            return "http://ow2h3ee9w.bkt.clouddn.com/nopic.jpg";
        }
        var images = data.split(",");
        if (images.length > 0) {
            return images[0];
        } else {
            return images;
        }
    }

    /*DataTables配置*/
    $(document).ready(function () {
        $(".table").DataTable({
            serverSide: true,//开启服务器模式
            "processing": true,//加载的时候显示提示
            "ajax": {
                url: "${URL}/item/list",
                type: "GET",
                data: {
                    cid: -1
                }
            },
            "columns": [
                {
                    "data": null,//第一列，显示checkbox
                    render: function (data, type, row, meta) {
                        return '<input name="checkbox" value="' + row.id + '" type="checkbox" >';
                    }
                },
                {
                    "data": "id"//商品id
                },
                {
                    "data": "image",//商品图片
                    render: function (data, type, row, meta) {
                        return '<img src="' + imageShow(data) + '" style="width=80px;height:70px;" alt="" />';
                    }
                },
                {
                    "data": "title",//商品标题
                    render: function (data, type, row, meta) {
                        if (type === "display") {
                            if (data.length > 30) {
                                return '<span title="' + data + '">' + data.substr(0, 30) + '...</span>';
                            } else {
                                return '<span title="' + data + '">' + data + '</span>';
                            }
                        }
                        return data;
                    }
                },
                {
                    data: "sellPoint",//商品描述
                    render: function (data, type, row, meta) {
                        if (type === "display") {
                            if (data.length > 25) {
                                return '<span title="' + data + '">' + data.substr(0, 25) + '</span>';
                            } else {
                                return '<span title="' + data + '">' + data + '</span>';
                            }
                        }
                        return data;
                    }
                },
                {
                    data: "price"//商品价格
                },
                {
                    data: "created",//商品创建时间
                    render: function (data, type, row, meta) {
                        return date(data);
                    }
                },
                {
                    data: "updated",//商品更新时间
                    render: function (data, type, row, meta) {
                        return date(data);
                    }
                },
                {
                    data: "status",//商品发布状态
                    render: function (data, type, row, meta) {
                        if (data == 0) {
                            return '<span class="label label-defant radius td-status">已下架</span>';
                        } else if (data == 1) {
                            return '<span class="label label-success radius td-status">已上架</span>';
                        } else {
                            return '<span class="label label-warning radius td-status">其它状态</span>';
                        }
                    }
                },
                {
                    data: null,//对商品操作：上架/下架，编辑，删除
                    render: function (data, type, row, meta) {
                        if (row.status == 1) {
                            //已发布状态，显示的是“下架”
                            return '<a style="text-decoration: none;" onclick="product_stop(' + row.id + ')" href="javascript:;" title="下架"><i class="Hui-iconfont">&#xe6de;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="product_edit(\'商品编辑\',\'product-edit\',' + row.id + ')" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> ' +
                                '<a style="text-decoration: none;" onclick="product_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        } else {
                            //已下架或其它状态，显示的是“上架”
                            return '<a style="text-decoration: none;" onclick="product_start(' + row.id + ')" href="javascript:;" title="发布"><i class="Hui-iconfont">&#xe603;</i></a> ' +
                                '<a style="text-decoration: none;" class="ml-5" onclick="product_edit(\'商品编辑\',\'product-edit\',' + row.id + ')" href="javascript:;" title="编辑"><i class="Hui-iconfont">&#xe6df;</i></a> ' +
                                '<a style="text-decoration: none;" onclick="product_del(' + row.id + ')" href="javascript:;" title="删除"><i class="Hui-iconfont">&#xe6e2;</i></a>';
                        }
                    }
                }
            ],
            "aaSorting": [[6, "desc"]],//默认第几个排序.（这里按照“更新时间”排序）
            "bStateSave": false,//状态保存
            "aoColumnDefs": [
                {"orderable": false, "aTargets": [0, 2, 9]}// 制定列不参与排序
            ],
            language: {
                url: 'lib/datatables/Chinese.json'
            },
            colReorder: true
        });
    });

    /*加载页面时，显示“共有数据：0 条”*/
    productCount();

    function productCount(){
        $.ajax({
            type: 'GET',
            url: '${URL}/item/count',
            success: function (data) {
                $("#itemListCount").html(data.recordsTotal);
            },
            error: function (XMLHttpRequest) {
                if (XMLHttpRequest.status != 200) {
                    layer.alert('数据处理失败！错误码' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                }
            }
        });
    }

    /*条件查询*/
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
        onkeyup: false,
        focusCleanup: false,
        success: "vaild",
        submitHandler: function (form) {
            var searchKey = $('#searchKey').val();
            var minDate = $('#minDate').val();
            var maxDate = $('#maxDate').val();
            var param = {
                "searchKey": searchKey,
                "minDate": minDate,
                "maxDate": maxDate,
                "cid": cid
            };
            var table = $('.table').DataTable();
            table.settings()[0].ajax.data = param;
            table.ajax.url('${URL}/item/listSearch').load();
        }
    });


    /*产品-添加*/
    function product_add(title, url) {
        var index = layer.open({
            type: 2,
            title: title,
            content: url
        });
        layer.full(index);
    }

    /*产品下架*/
    function product_stop(id) {
        layer.confirm('确认要下架该商品吗？', {icon: 0}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/item/stop/' + id,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success != true) {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                        return;
                    }
                    refresh();//刷新表格数据，分页信息不回重置
                    layer.msg('已下架', {icon: 6, time: 1000});
                },
                error: function (XMLHttpReqeust) {
                    layer.close(index);
                    layer.alert('数据处理错误!错误码' + XMLHttpReqeust.status, {title: '错误信息', icon: 2});
                }
            });
        });
    }

    /*产品-发布*/
    function product_start(id) {
        layer.confirm("确认要发布该商品吗？", {icon: 3}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/item/start/' + id,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success != true) {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                        return;
                    }
                    refresh();
                    layer.msg('已发布', {icon: 6, time: 1000});
                },
                error: function (XMLHttpReqeust) {
                    layer.close(index);
                    layer.alert('数据处理错误，错误码:' + XMLHttpReqeust.status, {title: '错误信息', icon: 2});
                }
            });
        });
    }

    /*产品-编辑*/
    function product_edit(title, url, id) {
        setId(id);
        var index = layer.open({
            type: 2,
            title: title,
            content: url
        });
        layer.full(index);
    }

    var ID = 0;

    function setId(id) {
        ID = id;
    }

    function getId() {
        return ID;
    }

    /*产品-删除*/
    function product_del(id) {
        layer.confirm('确认要删除该商品吗？', {icon: 0}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'PUT',
                url: '${URL}/item/del/' + id,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success != true) {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                        return;
                    }
                    //更新商品总数量
                    productCount();
                    refresh();
                    layer.alert('已删除', {icon: 1, time: 1000});
                },
                error: function (XMLHttpRequest) {
                    layer.close(index);
                    layer.alert('数据处理失败！错误码：' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                }
            });
        });
    }

    /*批量删除*/
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
        layer.confirm('确认要删除这' + count + '条数据吗？', {icon: 0}, function () {
            var index = layer.load(3);
            $.ajax({
                type: 'POST',
                url: '${URL}/item/del/' + ids,
                dataType: 'json',
                success: function (data) {
                    layer.close(index);
                    if (data.success != true) {
                        layer.alert(data.message, {title: '错误信息', icon: 2});
                        return;
                    }
                    productCount();
                    refresh();
                    layer.msg('成功删除', {icon: 1, time: 1000});
                },
                error: function (XMLHttpRequest) {
                    layer.close(index);
                    layer.alert('数据处理失败！错误码:' + XMLHttpRequest.status, {title: '错误信息', icon: 2});
                }
            });
        });
    }

    /*这个是给product-add.jsp调用的*/
    function msgSuccess(content) {
        layer.msg(content, {icon: 1, time: 3000});
    }
</script>
</body>
</html>
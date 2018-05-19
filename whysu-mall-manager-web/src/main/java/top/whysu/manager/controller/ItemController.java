package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.front.service.SearchItemService;
import top.whysu.manager.dto.ItemDto;
import top.whysu.manager.dto.front.EsInfo;
import top.whysu.manager.pojo.TbItem;
import top.whysu.manager.service.ItemService;

import java.io.UnsupportedEncodingException;

@RestController
@Api(description = "商品列表信息")
public class ItemController {

    private Logger logger = LoggerFactory.getLogger(ItemController.class);

    @Autowired
    private ItemService itemService;

    @Autowired
    private SearchItemService searchItemService;

    @RequestMapping(value = "/item/{itemId}", method = RequestMethod.GET)
    @ApiOperation(value = "通过Id获取商品")
    public Result<ItemDto> getItemById(@PathVariable long itemId) {
        ItemDto itemDto = itemService.getItemById(itemId);
        return new ResultUtil<ItemDto>().setData(itemDto);
    }

    @RequestMapping(value = "/item/count", method = RequestMethod.GET)
    @ApiOperation(value = "获得商品总数")
    public DataTablesResult getItemCount() {
        return itemService.getAllItemCount();
    }

    @RequestMapping(value = "/item/add", method = RequestMethod.POST)
    @ApiOperation(value = "添加商品")
    public Result<Object> itemAdd(ItemDto itemDto) {
        TbItem tbItem = itemService.addItem(itemDto);
        return new ResultUtil<Object>().setData(tbItem);
    }

    @RequestMapping(value = "/item/list",method = RequestMethod.GET)
    @ApiOperation(value = "获取商品列表")
    public DataTablesResult getItemList(int draw, int start, int length, int cid, @RequestParam("search[value]")String search,
                                        @RequestParam("order[0][column]")int orderCol,@RequestParam("order[0][dir]")String orderDir) throws UnsupportedEncodingException {
        //解决中文乱码问题(这里我修改了tomcat的serverl.xml中加入了URIEncoding="utf-8"，所以这里无需转码)
        /*search = new String(search.getBytes("ISO-8859-1"), "UTF-8");*/

        //表格点击“表头”，获取按照哪个字段排序（这里的值要和数据库对应）
        String[] cols = {"checkbox","id", "image", "title", "sell_point", "price", "created", "updated", "status"};
        String orderColumn = cols[orderCol];
        if(orderColumn == null){
            orderColumn = "created";
        }
        //获取排序方式，默认desc
        if(orderDir == null){
            orderDir = "desc";
        }
        DataTablesResult result = itemService.getItemList(draw,start,length,cid,search,orderColumn,orderDir);
        return result;
    }

    /*注意：search[value]是DataTable表格中的名为search列的值，而searchKey是自己在外面再定义的值*/
    @RequestMapping(value = "/item/listSearch",method = RequestMethod.GET)
    @ApiOperation(value = "多条件分页搜索排序获取商品列表")
    public DataTablesResult getItemSearchList(int draw, int start, int length,int cid,String searchKey,String minDate,String maxDate,
                                              @RequestParam("order[0][column]") int orderCol, @RequestParam("order[0][dir]") String orderDir) throws UnsupportedEncodingException {
        //解决中文乱码问题(这里我修改了tomcat的serverl.xml中加入了URIEncoding="utf-8"，所以这里无需转码)
        /*searchKey = new String(searchKey.getBytes("ISO-8859-1"), "UTF-8");*/

        //获取客户端需要排序的列
        String[] cols = {"checkbox","id", "image", "title", "sell_point", "price", "created", "updated", "status"};
        //默认排序列
        String orderColumn = cols[orderCol];
        if(orderColumn == null) {
            orderColumn = "created";
        }
        //获取排序方式 默认为desc(asc)
        if(orderDir == null) {
            orderDir = "desc";
        }
        DataTablesResult result=itemService.getItemSearchList(draw,start,length,cid,searchKey,minDate,maxDate,orderColumn,orderDir);
        return result;
    }

    @RequestMapping(value = "/item/stop/{id}",method = RequestMethod.PUT)
    @ApiOperation(value = "下架商品")
    public Result<TbItem> stopItem(@PathVariable Long id){

        TbItem tbItem = itemService.alertItemState(id,0);
        return new ResultUtil<TbItem>().setData(tbItem);
    }

    @RequestMapping(value = "/item/start/{id}",method = RequestMethod.PUT)
    @ApiOperation(value = "发布商品")
    public Result<TbItem> startItem(@PathVariable Long id){

        TbItem tbItem = itemService.alertItemState(id,1);
        return new ResultUtil<TbItem>().setData(tbItem);
    }

    @RequestMapping(value = "/item/del/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "删除商品")
    public Result<TbItem> deleteItem(@PathVariable Long[] ids){

        for(Long id:ids){
            itemService.deleteItem(id);
        }
        return new ResultUtil<TbItem>().setData(null);
    }

    @RequestMapping(value = "/item/update/{id}",method = RequestMethod.POST)
    @ApiOperation(value = "编辑商品")
    public Result<TbItem> updateItem(@PathVariable Long id, ItemDto itemDto){

        TbItem tbItem=itemService.updateItem(id,itemDto);
        return new ResultUtil<TbItem>().setData(tbItem);
    }

    @RequestMapping(value = "/item/importIndex",method = RequestMethod.GET)
    @ApiOperation(value = "导入商品索引至ES")
    public Result<Object> importIndex(){

        searchItemService.importAllItems();
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/es/getInfo",method = RequestMethod.GET)
    @ApiOperation(value = "获取ES信息")
    public Result<Object> getESInfo(){

        EsInfo esInfo=searchItemService.getEsInfo();
        return new ResultUtil<Object>().setData(esInfo);
    }
}

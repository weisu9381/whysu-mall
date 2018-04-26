package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.dto.ItemDto;
import top.whysu.manager.service.ItemService;

@RestController
@Api(description = "商品列表信息")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @RequestMapping(value = "/item/{itemId}",method = RequestMethod.POST)
    @ApiOperation(value = "通过Id获取商品")
    public Result<ItemDto> getItemById(@PathVariable long itemId) {
        ItemDto itemDto = itemService.getItemById(itemId);
        return new ResultUtil<ItemDto>().setData(itemDto);
    }

    @RequestMapping(value = "/item/count",method = RequestMethod.GET)
    @ApiOperation(value = "获得商品总数")
    public DataTablesResult getItemCount(){
        return itemService.getAllItemCount();
    }
}

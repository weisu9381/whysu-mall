package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.ZTreeNode;
import top.whysu.manager.service.ItemCatService;

import java.util.List;

@RestController
@Api(description = "商品分类信息")
public class ItemCatController {
    @Autowired
    private ItemCatService itemCatService;

    @RequestMapping(value = "/item/cat/list",method = RequestMethod.GET)
    @ApiOperation(value = "通过父Id获取商品分类列表")
    public List<ZTreeNode> getItemCatList(@RequestParam(name="id",defaultValue = "0")int parentId){
        //zTree写了AutoParam:['id','name']会将父节点的id和name属性一起带过来(需要设置setting.async.enable:true)，这里设置id的默认是0
        return itemCatService.getItemCatList(parentId);
    }
}

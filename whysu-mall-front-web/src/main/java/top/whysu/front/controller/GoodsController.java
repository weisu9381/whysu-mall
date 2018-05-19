package top.whysu.front.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.content.service.ContentService;
import top.whysu.front.service.SearchService;
import top.whysu.manager.dto.front.AllGoodsResult;
import top.whysu.manager.dto.front.ProductDet;
import top.whysu.manager.dto.front.SearchResult;
import top.whysu.manager.pojo.TbPanel;

import java.util.List;
import java.util.Objects;

@RestController
@Api(description = "商品页面展示")
public class GoodsController {

    private Logger log = LoggerFactory.getLogger(GoodsController.class);

    @Autowired
    private ContentService contentService;
    @Autowired
    private SearchService searchService;


    @RequestMapping(value = "/goods/home", method = RequestMethod.GET)
    @ApiOperation(value = "首页所有内容")
    public Result<List<TbPanel>> getHome(){
        List<TbPanel> list = contentService.getHome();
        return new ResultUtil<List<TbPanel>>().setData(list);
    }

    @RequestMapping(value = "/goods/getAllProduct", method = RequestMethod.GET)
    @ApiOperation(value = "获取所有商品")
    public Result<AllGoodsResult> getAllProduct(@RequestParam(defaultValue = "1")int pageNum,
                                        @RequestParam(defaultValue = "20")int size,
                                        @RequestParam(defaultValue = "")Long cid,
                                        @RequestParam(defaultValue = "-1")int minPrice,
                                        @RequestParam(defaultValue = "-1")int maxPrice,
                                        @RequestParam(defaultValue = "created")String orderCol,
                                        @RequestParam(defaultValue = "desc")String orderDir){
        //当时把 ContentService各自写在front和manager工程里，没有隔开，然后两个地方用到了同一个方法，但是redis打开了一个，另一个再想打开就会端口占用
        //于是只能抽离出来，这里没办法不想改动其它地方了，就这么把sort转换一下就好了。
        String sort;
        if(Objects.equals(orderCol, "price") && Objects.equals(orderDir, "desc")){
            sort = "-1";
        }else if(Objects.equals(orderCol, "price") && Objects.equals(orderDir, "asc")){
            sort = "1";
        }else{
            sort = "0";
        }
        AllGoodsResult allGoodsResult = contentService.getAllProduct(pageNum,size,sort,cid,minPrice,maxPrice);
        return new ResultUtil<AllGoodsResult>().setData(allGoodsResult);
    }

    @RequestMapping(value = "/goods/productDetail",method = RequestMethod.GET)
    @ApiOperation(value = "商品详情")
    public Result<ProductDet> getProductDet(Long productId){

        ProductDet productDet=contentService.getProductDet(productId);
        return new ResultUtil<ProductDet>().setData(productDet);
    }

    @RequestMapping(value = "/goods/search",method = RequestMethod.GET)
    @ApiOperation(value = "搜索商品ES")
    public Result<SearchResult> searchProduct(@RequestParam(defaultValue = "") String key,
                                              @RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "20") int size,
                                              @RequestParam(defaultValue = "1") String sort,
                                              @RequestParam(defaultValue = "-1") int priceGt,
                                              @RequestParam(defaultValue = "-1") int priceLte){

        SearchResult searchResult=searchService.search(key,page,size,sort,priceGt,priceLte);
        return new ResultUtil<SearchResult>().setData(searchResult);
    }

}

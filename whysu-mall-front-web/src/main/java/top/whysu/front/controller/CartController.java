package top.whysu.front.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.front.service.CartService;
import top.whysu.manager.dto.front.Cart;
import top.whysu.manager.dto.front.CartProduct;

import java.util.List;

@RestController
@Api(description = "购物车管理")
public class CartController {

    private Logger log = LoggerFactory.getLogger(CartController.class);

    @Autowired
    private CartService cartService;

    @RequestMapping(value = "/cart/addCart",method = RequestMethod.POST)
    @ApiOperation(value = "添加购物车商品")
    public Result<Object> addCart(@RequestBody Cart cart){
        log.debug("进入");
        int result=cartService.addCart(cart.getUserId(),cart.getProductId(),cart.getProductNum());
        log.debug("进入了，result="+result);
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/cart/cartList",method = RequestMethod.POST)
    @ApiOperation(value = "获取购物车商品列表")
    public Result<List<CartProduct>> getCartList(@RequestBody Cart cart){

        List<CartProduct> list=cartService.getCartList(cart.getUserId());
        return new ResultUtil<List<CartProduct>>().setData(list);
    }

    @RequestMapping(value = "/cart/cartEdit",method = RequestMethod.POST)
    @ApiOperation(value = "编辑购物车商品")
    public Result<Object> updateCartNum(@RequestBody Cart cart){

        int result=cartService.updateCartNum(cart.getUserId(),cart.getProductId(),cart.getProductNum(),cart.getChecked());
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/cart/editCheckAll",method = RequestMethod.POST)
    @ApiOperation(value = "是否全选购物车商品")
    public Result<Object> editCheckAll(@RequestBody Cart cart){

        int result=cartService.checkAll(cart.getUserId(),cart.getChecked());
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/cart/cartDel",method = RequestMethod.POST)
    @ApiOperation(value = "删除购物车商品")
    public Result<Object> deleteCartItem(@RequestBody Cart cart){

        int result=cartService.deleteCartItem(cart.getUserId(),cart.getProductId());
        return new ResultUtil<Object>().setData(result);
    }
}

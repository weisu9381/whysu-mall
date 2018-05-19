package top.whysu.front.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.front.service.OrderService;
import top.whysu.manager.dto.front.Order;
import top.whysu.manager.dto.front.OrderInfo;
import top.whysu.manager.dto.front.OrderStatus;
import top.whysu.manager.dto.front.PageOrder;
import top.whysu.manager.pojo.TbThanks;


@RestController
@Api(description = "订单管理")
public class OrderController {

    private Logger log = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private OrderService orderService;

    @RequestMapping(value = "/order/orderList",method = RequestMethod.GET)
    @ApiOperation(value = "获得用户所有订单")
    public Result<PageOrder> getOrderList(String userId,
                                          @RequestParam(defaultValue = "1") int currentPage,
                                          @RequestParam(defaultValue = "5") int pageSize){
        PageOrder pageOrder=orderService.getOrderList(Long.valueOf(userId), currentPage, pageSize);
        return new ResultUtil<PageOrder>().setData(pageOrder);
    }

    @RequestMapping(value = "/order/orderDetail",method = RequestMethod.GET)
    @ApiOperation(value = "通过id获取订单")
    public Result<Order> getOrder(String orderId){

        Order order=orderService.getOrder(Long.valueOf(orderId));
        return new ResultUtil<Order>().setData(order);
    }

    @RequestMapping(value = "/order/addOrder",method = RequestMethod.POST)
    @ApiOperation(value = "创建订单")
    public Result<Object> addOrder(@RequestBody OrderInfo orderInfo){

        Long orderId=orderService.createOrder(orderInfo);
        return new ResultUtil<Object>().setData(orderId.toString());
    }

    @RequestMapping(value = "/order/cancelOrder",method = RequestMethod.POST)
    @ApiOperation(value = "取消订单")
    public Result<Object> cancelOrder(@RequestBody Order order){

        int result=orderService.cancelOrder(order.getOrderId());
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/order/delOrder",method = RequestMethod.GET)
    @ApiOperation(value = "删除订单")
    public Result<Object> delOrder(Long orderId){

        int result=orderService.delOrder(orderId);
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/order/payOrder",method = RequestMethod.POST)
    @ApiOperation(value = "支付订单")
    public Result<Object> payOrder(@RequestBody TbThanks tbThanks){

        int result=orderService.payOrder(tbThanks);
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/order/setOrderStatus",method = RequestMethod.POST)
    @ApiOperation(value = "支付订单")
    public Result<Object> setOrderStatus(@RequestBody OrderStatus orderStatus){
        log.info("orderId="+orderStatus.getOrderId()+", status="+orderStatus.getStatus());
        int result=orderService.setOrderStatus(orderStatus.getOrderId(), orderStatus.getStatus());
        return new ResultUtil<Object>().setData(result);
    }
}

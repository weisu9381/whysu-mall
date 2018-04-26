package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.service.OrderService;

@RestController
@Api(description = "订单管理")
public class OrderController {

    private Logger log = LoggerFactory.getLogger(OrderController.class);

    @Autowired
    private OrderService orderService;

    @RequestMapping(value = "/order/count",method = RequestMethod.GET)
    @ApiOperation(value = "获得订单总数")
    public Result<Object> getOrderCount(){
        Long count = orderService.countOrder();
        return new ResultUtil<Object>().setData(count);
    }

}

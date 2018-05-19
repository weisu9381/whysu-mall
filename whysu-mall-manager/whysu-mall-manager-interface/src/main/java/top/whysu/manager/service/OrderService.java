package top.whysu.manager.service;

import top.whysu.common.pojo.DataTablesResult;

public interface OrderService {
    /**获得订单列表*/
    DataTablesResult getOrderList();
    /**
     * 获得订单列表
     */
    DataTablesResult getOrderList(int draw, int start, int length, String search, String orderCol, String orderDir);
    /**统计订单数*/
    Long countOrder();
    /**删除订单*/
    int deleteOrder(String id);
    /**取消订单*/
    int cancelOrder();
}

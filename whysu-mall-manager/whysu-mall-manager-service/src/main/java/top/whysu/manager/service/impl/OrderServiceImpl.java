package top.whysu.manager.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.mapper.TbOrderItemMapper;
import top.whysu.manager.mapper.TbOrderMapper;
import top.whysu.manager.mapper.TbOrderShippingMapper;
import top.whysu.manager.pojo.TbOrder;
import top.whysu.manager.pojo.TbOrderExample;
import top.whysu.manager.pojo.TbOrderItem;
import top.whysu.manager.pojo.TbOrderItemExample;
import top.whysu.manager.service.OrderService;

import java.util.Date;
import java.util.List;

@Service
public class OrderServiceImpl implements OrderService{
    @Autowired
    private TbOrderMapper tbOrderMapper;
    @Autowired
    private TbOrderItemMapper tbOrderItemMapper;
    @Autowired
    private TbOrderShippingMapper tbOrderShippingMapper;

    @Override
    public DataTablesResult getOrderList(int draw, int start, int length, String search, String orderCol, String orderDir) {

        DataTablesResult result=new DataTablesResult();
        //分页
        PageHelper.startPage(start/length+1,length);
        List<TbOrder> list = tbOrderMapper.selectByMulti("%"+search+"%",orderCol,orderDir);
        PageInfo<TbOrder> pageInfo=new PageInfo<>(list);

        result.setRecordsFiltered((int)pageInfo.getTotal());
        result.setRecordsTotal(Math.toIntExact(cancelOrder()));

        result.setDraw(draw);
        result.setData(list);
        return result;
    }

    @Override
    public DataTablesResult getOrderList() {
        DataTablesResult result = new DataTablesResult();
        TbOrderExample  example = new TbOrderExample();
        List<TbOrder> list = tbOrderMapper.selectByExample(example);
        if(list == null){
            throw new WhysuMallException("获取订单列表失败");
        }
        result.setSuccess(true);
        result.setData(list);
        return result;
    }

    @Override
    public Long countOrder() {
        TbOrderExample example = new TbOrderExample();
        return tbOrderMapper.countByExample(example);
    }

    @Override
    public int deleteOrder(String id) {
        if(tbOrderMapper.deleteByPrimaryKey(id)!= 1){
            throw new WhysuMallException("订单删除失败");
        }

        //删除订单商品
        TbOrderItemExample example = new TbOrderItemExample();
        TbOrderItemExample.Criteria criteria = example.createCriteria();
        criteria.andOrderIdEqualTo(id);
        List<TbOrderItem> list = tbOrderItemMapper.selectByExample(example);
        for(TbOrderItem tbOrderItem : list){
            if(tbOrderItemMapper.deleteByPrimaryKey(tbOrderItem.getId()) != 1){
                throw new WhysuMallException("删除订单商品失败");
            }
        }

        //删除物流
        if(tbOrderShippingMapper.deleteByPrimaryKey(id)!=1){
            throw new WhysuMallException("删除物流失败");
        }

        return 1;
    }

    @Override
    public int cancelOrder() {
        TbOrderExample example = new TbOrderExample();
        List<TbOrder> list = tbOrderMapper.selectByExample(example);
        for(TbOrder tbOrder : list){
            judgeOrder(tbOrder);
        }
        return 1;
    }

    /**
     * 判断订单是否超时未支付
     */
    public String judgeOrder(TbOrder tbOrder){
        String result = null;
        if(tbOrder.getStatus() == 0){
            //判断是否超过1天
            long diff = System.currentTimeMillis() -tbOrder.getCreateTime().getTime();
            long days = diff / (60 * 60 * 24 * 1000);
            if(days > 1){
                //设置失效
                tbOrder.setStatus(5);
                tbOrder.setCloseTime(new Date());
                if(tbOrderMapper.updateByPrimaryKey(tbOrder) != 1){
                    throw new WhysuMallException("设置订单失效，操作失败");
                }
            }else{
                //返回到期时间
                long time=tbOrder.getCreateTime().getTime()+1000 * 60 * 60 * 24;
                result= String.valueOf(time);
            }
        }
        return result;
    }
}

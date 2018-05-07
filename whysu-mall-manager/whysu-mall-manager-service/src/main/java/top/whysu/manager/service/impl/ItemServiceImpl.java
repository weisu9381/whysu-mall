package top.whysu.manager.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.jedis.JedisClient;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.utils.IDUtil;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.dto.ItemDto;
import top.whysu.manager.mapper.TbItemCatMapper;
import top.whysu.manager.mapper.TbItemDescMapper;
import top.whysu.manager.mapper.TbItemMapper;
import top.whysu.manager.pojo.TbItem;
import top.whysu.manager.pojo.TbItemCat;
import top.whysu.manager.pojo.TbItemDesc;
import top.whysu.manager.pojo.TbItemExample;
import top.whysu.manager.service.ItemService;

import javax.annotation.Resource;
import javax.jms.*;
import java.util.Date;
import java.util.List;

@Service
public class ItemServiceImpl implements ItemService{

    private final static Logger log= LoggerFactory.getLogger(ItemServiceImpl.class);

    @Autowired
    private TbItemMapper tbItemMapper;

    @Autowired
    private TbItemCatMapper tbItemCatMapper;

    @Autowired
    private TbItemDescMapper tbItemDescMapper;

    @Autowired
    private JmsTemplate jmsTemplate;

    @Resource
    private Destination topicDestination;

    @Autowired
    private JedisClient jedisClient;

    @Value("${REDIS_ITEM}")
    private String REDIS_ITEM;

    @Override
    public ItemDto getItemById(Long itemId) {
        ItemDto itemDto= new ItemDto();

        TbItem tbItem = tbItemMapper.selectByPrimaryKey(itemId);
        itemDto = DtoUtil.TbItem2ItemDto(tbItem);

        TbItemCat tbItemCat = tbItemCatMapper.selectByPrimaryKey(tbItem.getCid());
        itemDto.setCname(tbItemCat.getName());

        TbItemDesc tbItemDesc = tbItemDescMapper.selectByPrimaryKey(itemId);
        itemDto.setDetail(tbItemDesc.getItemDesc());

        return itemDto;
    }

    @Override
    public TbItem getNormalItemById(Long id) {
        return tbItemMapper.selectByPrimaryKey(id);
    }

    @Override
    public DataTablesResult getItemList(int draw, int start, int length, int cid, String search, String orderCol, String orderDir) {
        DataTablesResult result = new DataTablesResult();
        //分页执行查询返回结果
        PageHelper.startPage(start/length + 1, length);
        List<TbItem> list = tbItemMapper.selectItemByCondition(cid,"%"+search+"%",orderCol,orderDir);
        PageInfo<TbItem> pageInfo = new PageInfo<>(list);
        result.setRecordsFiltered((int) pageInfo.getTotal());
        result.setRecordsTotal(getAllItemCount().getRecordsTotal());
        result.setDraw(draw);
        result.setData(list);
        return result;
    }

    @Override
    public DataTablesResult getItemSearchList(int draw, int start, int length, int cid, String search, String minDate, String maxDate, String orderCol, String orderDir) {
        DataTablesResult result = new DataTablesResult();
        //分页执行查询结果
        PageHelper.startPage(start/length + 1,length);
        List<TbItem> list = tbItemMapper.selectItemByMultiCondition(cid,"%"+search+"%",minDate,maxDate,orderCol,orderDir);
        PageInfo<TbItem> pageInfo = new PageInfo<>(list);
        result.setRecordsFiltered((int) pageInfo.getTotal());
        result.setRecordsTotal(getAllItemCount().getRecordsTotal());
        result.setDraw(draw);
        result.setData(list);
        return result;
    }

    @Override
    public DataTablesResult getAllItemCount() {
        TbItemExample example = new TbItemExample();
        Long count  = tbItemMapper.countByExample(example);
        DataTablesResult result = new DataTablesResult();
        result.setRecordsTotal(Math.toIntExact(count));
        return result;
    }

    @Override
    public TbItem alertItemState(Long id, Integer state) {
        TbItem tbItem = getNormalItemById(id);
        tbItem.setStatus(state.byteValue());
        tbItem.setUpdated(new Date());

        if(tbItemMapper.updateByPrimaryKey(tbItem) != 1){
            throw new WhysuMallException("修改商品状态失败");
        }
        return getNormalItemById(id);
    }

    @Override
    public int deleteItem(Long id) {
        if(tbItemMapper.deleteByPrimaryKey(id) != 1){
            throw new WhysuMallException("删除商品失败");
        }
        if(tbItemDescMapper.deleteByPrimaryKey(id) != 1){
            throw new WhysuMallException("删除商品详情失败");
        }
        //发送消息同步索引库
        sendRefreshESMessage("delete",id);
        return 0;
    }

    @Override
    public TbItem addItem(ItemDto itemDto) {
        long id = IDUtil.getRandomId();
        TbItem tbItem = DtoUtil.ItemDto2TbItem(itemDto);
        tbItem.setId(id);
        tbItem.setStatus((byte) 1);
        tbItem.setCreated(new Date());
        tbItem.setUpdated(new Date());
        if(tbItem.getImage().isEmpty()){
            tbItem.setImage("http://ow2h3ee9w.bkt.clouddn.com/nopic.jpg");
        }
        if(tbItemMapper.insert(tbItem) != 1){
            throw new WhysuMallException("添加商品失败");
        }

        TbItemDesc tbItemDesc = new TbItemDesc();
        tbItemDesc.setItemId(id);
        tbItemDesc.setItemDesc(itemDto.getDetail());
        tbItemDesc.setCreated(new Date());
        tbItemDesc.setUpdated(new Date());
        if(tbItemDescMapper.insert(tbItemDesc) != 1){
            throw new WhysuMallException("添加商品详情失败");
        }
        /*//发送消息同步索引库
        try {
            sendRefreshESMessage("add",id);
        }catch (Exception e){
            log.error("同步索引出错");
        }*/
        return getNormalItemById(id);
    }

    @Override
    public TbItem updateItem(Long id, ItemDto itemDto) {
        TbItem oldTbItem = getNormalItemById(id);
        TbItem newTbItem = DtoUtil.ItemDto2TbItem(itemDto);
        if(itemDto.getImage().isEmpty()){
            newTbItem.setImage(oldTbItem.getImage());
        }
        newTbItem.setId(oldTbItem.getId());
        newTbItem.setCreated(oldTbItem.getCreated());
        newTbItem.setUpdated(new Date());
        newTbItem.setStatus((byte) 1);
        if(tbItemMapper.updateByPrimaryKey(newTbItem) != 1){
            throw new WhysuMallException("更新商品失败");
        }
        TbItemDesc tbItemDesc = tbItemDescMapper.selectByPrimaryKey(id);
        tbItemDesc.setItemId(id);
        tbItemDesc.setItemDesc(itemDto.getDetail());
        log.info("itemDto.getDetail()="+itemDto.getDetail());
        tbItemDesc.setCreated(oldTbItem.getCreated());
        tbItemDesc.setUpdated(new Date());
        if(tbItemDescMapper.updateByPrimaryKey(tbItemDesc) != 1){
            throw new WhysuMallException("更新商品详情失败");
        }
       /* //同步缓存
        deleteProductDetRedis(id);
        //发送消息同步索引库
        try {
            sendRefreshESMessage("add",id);
        }catch (Exception e){
            log.error("同步索引出错");
        }*/
        return getNormalItemById(id);
    }

    /**同步商品详情缓存*/
    public void deleteProductDetRedis(Long id){
        try {
            jedisClient.del(REDIS_ITEM+":"+id);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

   /**发送消息同步索引库*/
   public void sendRefreshESMessage(String type,Long id){
       jmsTemplate.send(topicDestination, new MessageCreator() {
           @Override
           public Message createMessage(Session session) throws JMSException {
               TextMessage textMessage = session.createTextMessage(type+","+String.valueOf(id));
               return textMessage;
           }
       });
   }
}

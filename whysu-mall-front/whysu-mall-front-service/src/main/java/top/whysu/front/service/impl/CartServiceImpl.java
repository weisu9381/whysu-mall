package top.whysu.front.service.impl;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import top.whysu.common.jedis.JedisClient;
import top.whysu.front.service.CartService;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.dto.front.CartProduct;
import top.whysu.manager.mapper.TbItemMapper;
import top.whysu.manager.pojo.TbItem;

import java.util.ArrayList;
import java.util.List;

@Service
public class CartServiceImpl implements CartService{

    private Logger log = LoggerFactory.getLogger(CartServiceImpl.class);

    @Autowired
    private JedisClient jedisClient;
    @Value("${CART_PRE}")
    private String CART_PRE;

    @Autowired
    private TbItemMapper itemMapper;

    @Override
    public int addCart(long userId, long itemId, int num) {
        log.info("addCart!!!!!");
        //查看用户userId是否已经将商品itemId添加到购物车中
        //hash: "key:用户id" field："商品id" value："商品信息"
        boolean isExist = jedisClient.hexists(CART_PRE + ":" + userId, itemId + "");
        //如果存在则更新数量（增加num个）
        if(isExist){
            log.info("存在购物车");
            String json = jedisClient.hget(CART_PRE + ":" + userId, itemId + "");
            if(json != null){
                CartProduct cartProduct = new Gson().fromJson(json, CartProduct.class);
                cartProduct.setProductNum(cartProduct.getProductNum() + num);
                jedisClient.hset(CART_PRE + ":" + userId, itemId + "", new Gson().toJson(cartProduct));
                return 1;
            }else{
                return 0;
            }
        }
        log.info("不存在购物车缓存");
        //如果不存在
        //根据商品itemId获得商品信息
        TbItem tbItem = itemMapper.selectByPrimaryKey(itemId);
        if(tbItem == null){
            return 0;
        }
        CartProduct cartProduct = DtoUtil.TbItem2CartProduct(tbItem);
        cartProduct.setProductNum((long) num);
        cartProduct.setChecked("1");
        jedisClient.hset(CART_PRE + ":" + userId, itemId + "", new Gson().toJson(cartProduct));
        return 1;
    }

    @Override
    public List<CartProduct> getCartList(long userId) {
        List<String> jsonList = jedisClient.hvals(CART_PRE + ":" + userId);
        log.debug("jsonList.size="+jsonList.size());
        List<CartProduct> list = new ArrayList<>();
        for(String json : jsonList){
            CartProduct cartProduct = new Gson().fromJson(json, CartProduct.class);
            list.add(cartProduct);
        }
        return list;
    }

    @Override
    public int updateCartNum(long userId, long itemId, int num, String checked) {
        String json = jedisClient.hget(CART_PRE + ":" + userId, itemId + "");
        if(json==null){
            return 0;
        }
        CartProduct cartProduct = new Gson().fromJson(json,CartProduct.class);
        cartProduct.setProductNum((long) num);
        cartProduct.setChecked(checked);
        jedisClient.hset(CART_PRE + ":" + userId, itemId + "", new Gson().toJson(cartProduct));
        return 1;
    }

    @Override
    public int deleteCartItem(long userId, long itemId) {
        jedisClient.hdel(CART_PRE + ":" + userId, itemId + "");
        return 1;
    }

    @Override
    public int checkAll(long userId, String checked) {
        List<String> jsonList = jedisClient.hvals(CART_PRE + ":" + userId);

        for (String json : jsonList) {
            CartProduct cartProduct = new Gson().fromJson(json,CartProduct.class);
            if("true".equals(checked)) {
                cartProduct.setChecked("1");
            }else if("false".equals(checked)) {
                cartProduct.setChecked("0");
            }else {
                return 0;
            }
            jedisClient.hset(CART_PRE + ":" + userId, cartProduct.getProductId() + "", new Gson().toJson(cartProduct));
        }

        return 1;
    }
}

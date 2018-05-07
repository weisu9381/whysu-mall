package top.whysu.manager.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.pojo.ZTreeNode;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.mapper.TbItemCatMapper;
import top.whysu.manager.pojo.TbItemCat;
import top.whysu.manager.pojo.TbItemCatExample;
import top.whysu.manager.service.ItemCatService;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class ItemCatServiceImpl implements ItemCatService{

    private Logger logger = LoggerFactory.getLogger(ItemCatServiceImpl.class);

    @Autowired
    private TbItemCatMapper tbItemCatMapper;

    @Value("${REDIS_ITEM}")
    private String REDIS_ITEM;

    @Override
    public TbItemCat getItemCatById(Long id) {
        TbItemCat tbItemCat = tbItemCatMapper.selectByPrimaryKey(id);
        if(tbItemCat == null){
            throw new WhysuMallException("通过id获取商品分类失败");
        }
        return tbItemCat;
    }

    @Override
    public List<ZTreeNode> getItemCatList(int parentId) {
        TbItemCatExample example = new TbItemCatExample();
        TbItemCatExample.Criteria criteria = example.createCriteria();
        //条件查询
        criteria.andParentIdEqualTo((long) parentId);
        //排序
        example.setOrderByClause("sort_order");
        List<TbItemCat> list = tbItemCatMapper.selectByExample(example);

        //转换成ZTreeNode
        List<ZTreeNode> zTreeNodeList = new ArrayList<>();
        for(TbItemCat tbItemCat : list){
            ZTreeNode node = DtoUtil.TbItemCat2ZTreeNode(tbItemCat);
            zTreeNodeList.add(node);
        }
        return zTreeNodeList;
    }

    @Override
    public int addItemCat(TbItemCat tbItemCat) {
        tbItemCat.setCreated(new Date());
        tbItemCat.setUpdated(new Date());
        //先获得父节点为parentId的所有子节点的最大的排序值，然后加 1
        //在数据库中使用了 SELECT IFNULL(MAX(sort_order),0) 如果是空表的话会返回null,使用IFNULL()函数设置为null时的值是0
        int biggestOrder = tbItemCatMapper.getTheBiggestSortOrder(tbItemCat.getParentId());
        tbItemCat.setSortOrder(biggestOrder + 1);

        if(tbItemCatMapper.insert(tbItemCat) != 1){
            throw new WhysuMallException("添加商品分类失败");
        }
        return 1;
    }

    @Override
    public int updateItemCat(TbItemCat tbItemCat) {
        TbItemCat old = getItemCatById(tbItemCat.getId());
        tbItemCat.setCreated(old.getCreated());
        tbItemCat.setUpdated(new Date());
        if(tbItemCatMapper.updateByPrimaryKey(tbItemCat) != 1){
            throw new WhysuMallException("添加商品分类失败");
        }
        return 1;
    }

    @Override
    public void deleteItemCat(Long id) {
        deleteZTree(id);
    }

    @Override
    public void deleteZTree(Long id) {
        //查询该节点的所有子节点
        List<ZTreeNode> list = getItemCatList(Math.toIntExact(id));
        if(list.size() > 0){
            for(int i = 0; i < list.size() ; i++){
                deleteItemCat((long) list.get(i).getId());
            }
        }
        //没有子节点直接删除
        if(tbItemCatMapper.deleteByPrimaryKey(id) != 1){
            throw new WhysuMallException("删除商品分类失败");
        }
    }


}

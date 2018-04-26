package top.whysu.manager.service;

import top.whysu.common.pojo.ZTreeNode;
import top.whysu.manager.pojo.TbItemCat;

import java.util.List;

public interface ItemCatService {
    /**
     * 通过id获得商品类目
     */
    TbItemCat getItemCatById(Long id);

    /**
     * 获得父id的所有商品
     */
    List<ZTreeNode> getItemCatList(int parentId);

    /**
     * 添加商品
     */
    int addItemCat(TbItemCat tbItemCat);

    /**
     * 更新商品
     */
    int updateItemCat(TbItemCat tbItemCat);

    /**
     * 删除商品
     */
    void deleteItemCat(Long id);

    /**
     * 删除ZTree
     */
    void deleteZTree(Long id);
}

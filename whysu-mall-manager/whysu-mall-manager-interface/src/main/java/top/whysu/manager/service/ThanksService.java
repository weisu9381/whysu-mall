package top.whysu.manager.service;

import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.pojo.TbThanks;

public interface ThanksService {
    /**获得捐赠列表*/
    DataTablesResult getThanksList();
    /**获取捐赠列表（分页）*/
    DataTablesResult getThanksListByPage(int page, int size);
    /**统计捐赠表数目*/
    Long countThanks();
    /**添加捐赠*/
    int addThanks(TbThanks tbThanks);
    /**更新捐赠*/
    int updateThanks(TbThanks tbThanks);
    /**删除捐赠*/
    int deleteThanks(int id);
    /**通过Id获取*/
    TbThanks getThankById(int id);
}

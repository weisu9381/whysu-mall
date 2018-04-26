package top.whysu.manager.service;

import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.pojo.TbBase;
import top.whysu.manager.pojo.TbLog;
import top.whysu.manager.pojo.TbOrderItem;
import top.whysu.manager.pojo.TbShiroFilter;

import java.util.List;

public interface SystemService {
    /**
     * 获得shiro过滤器配置
     */
    List<TbShiroFilter> getShiroFilter();
    /**
     * 统计过滤链数目
     */
    Long countShiroFilter();
    /**添加shiro过滤链*/
    int addShiroFilter(TbShiroFilter tbShiroFilter);
    /**
     *更新shiro过滤链
     */
    int updateShiroFilter(TbShiroFilter tbShiroFilter);
    /**
     * 删除shiro过滤链
     */
    int deleteShiroFilter(int id);
    /**
     * 获取网站基础设置
     */
    TbBase getBase();
    /**
     * 更新网站基础设置
     */
    int updateBase(TbBase tbBase);
    /**
     *获取本周销售商品
     */
    TbOrderItem getWeekHot();
    /**
     *添加日志
     */
    int addLog(TbLog tbLog);
    /**
     * 添加日志列表
     */
    DataTablesResult getLogList();
    /**
     * 统计日志数量
     */
    Long countLog();
    /**
     * 删除日志
     */
    int deleteLog(int id);
}

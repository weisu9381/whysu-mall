package top.whysu.front.service;

import top.whysu.manager.dto.front.EsInfo;

public interface SearchItemService {
    /**
     * 同步索引
     * @return
     */
    int importAllItems();

    /**
     * 获取ES基本信息
     * @return
     */
    EsInfo getEsInfo();
}

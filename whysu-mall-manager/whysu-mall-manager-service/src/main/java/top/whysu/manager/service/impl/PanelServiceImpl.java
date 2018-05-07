package top.whysu.manager.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.jedis.JedisClient;
import top.whysu.common.pojo.ZTreeNode;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.mapper.TbPanelMapper;
import top.whysu.manager.pojo.TbPanel;
import top.whysu.manager.pojo.TbPanelExample;
import top.whysu.manager.service.PanelService;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class PanelServiceImpl implements PanelService{

    private Logger log = LoggerFactory.getLogger(PanelServiceImpl.class);

    @Autowired
    private TbPanelMapper tbPanelMapper;

    @Autowired
    private JedisClient jedisClient;

    @Value("${PRODUCT_HOME}")
    private String PRODUCT_HOME;

    @Override
    public TbPanel getTbPanelById(int id) {
        TbPanel tbPanel=tbPanelMapper.selectByPrimaryKey(id);
        if(tbPanel==null){
            throw new WhysuMallException("通过id获得板块失败");
        }
        return tbPanel;
    }

    /**
     * 调用方法： 一： getPanelList(0,false);表示获取首页（不含轮播图）的板块
     * 二： getPanelList(0,true) 表示获取首页（含轮播图）的板块
     *  getPanelList(-1,true/false)仅含轮播图
     *
     * getPanelList(-2,true/false)获得其它板块（除了首页板块之外）
     *
     * getPanelList(1,true/false)获取商品推荐
     * getPanelList(2,true/false)获取“我要捐赠”
     */
    @Override
    public List<ZTreeNode> getPanelList(int position, boolean showAll) {
        TbPanelExample example=new TbPanelExample();
        TbPanelExample.Criteria criteria=example.createCriteria();
        if(position==0&&!showAll){
            //首页，不包含轮播
            criteria.andPositionEqualTo(0);
            criteria.andTypeNotEqualTo(0);
        }else if(position==0&&showAll){
            //首页，包含轮播
            criteria.andPositionEqualTo(0);
        }else if(position==-1){
            //首页，仅仅包含轮播
            criteria.andPositionEqualTo(0);
            criteria.andTypeEqualTo(0);
        }else if(position==-2){
            //获得其它板块的内容（不包含首页板块）
            criteria.andPositionNotEqualTo(0);
        }else{
            //获得指定的板块
            criteria.andPositionEqualTo(position);
        }
        example.setOrderByClause("sort_order");
        List<TbPanel> panelList=tbPanelMapper.selectByExample(example);

        List<ZTreeNode> list=new ArrayList<>();

        for(TbPanel tbPanel:panelList){
            ZTreeNode zTreeNode= DtoUtil.TbPanel2ZTreeNode(tbPanel);
            list.add(zTreeNode);
        }

        return list;
    }

    @Override
    public int addPanel(TbPanel tbPanel) {
        //如果类型是轮播图
        if(tbPanel.getType()==0){
            TbPanelExample example=new TbPanelExample();
            TbPanelExample.Criteria criteria=example.createCriteria();
            criteria.andTypeEqualTo(0);
            List<TbPanel> list = tbPanelMapper.selectByExample(example);
            if(list!=null&&list.size()>0){
                throw new WhysuMallException("已有轮播图板块,轮播图仅能添加1个!");
            }
        }
        tbPanel.setCreated(new Date());
        tbPanel.setUpdated(new Date());

        if(tbPanelMapper.insert(tbPanel)!=1){
            throw new WhysuMallException("添加板块失败");
        }
        //同步缓存
        /*deleteHomeRedis();*/
        return 1;
    }

    @Override
    public int updatePanel(TbPanel tbPanel) {
        tbPanel.setUpdated(new Date());

        if(tbPanelMapper.updateByPrimaryKey(tbPanel)!=1){
            throw new WhysuMallException("更新板块失败");
        }
        //同步缓存
        /*deleteHomeRedis();*/
        return 1;
    }

    @Override
    public int deletePanel(int id) {
        if(tbPanelMapper.deleteByPrimaryKey(id)!=1){
            throw new WhysuMallException("删除内容分类失败");
        }
        //同步缓存
        /*deleteHomeRedis();*/
        return 1;
    }

    /**
     * 同步首页缓存
     */
    public void deleteHomeRedis(){
        try {
            jedisClient.del(PRODUCT_HOME);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}

package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.IPInfoUtil;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.pojo.TbShiroFilter;
import top.whysu.manager.pojo.TbUser;
import top.whysu.manager.service.SystemService;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@Api(description = "系统配置管理")
public class SystemController {

    private Logger log = LoggerFactory.getLogger(SystemController.class);

    @Autowired
    private SystemService systemService;

    @RequestMapping(value = "/sys/weather",method = RequestMethod.GET)
    @ApiOperation(value = "获得天气信息")
    public Result<Object> getWeather(HttpServletRequest request){
        log.debug("idaddr: "+ IPInfoUtil.getIpAddr(request) );
        String result = IPInfoUtil.getIpInfo(IPInfoUtil.getIpAddr(request));
        log.debug("result: " + result);
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/sys/shiro/list",method = RequestMethod.GET)
    @ApiOperation(value = "获取shiro过滤链配置")
    public DataTablesResult getShiroList(@ModelAttribute TbUser tbUser){

        DataTablesResult result=new DataTablesResult();
        List<TbShiroFilter> list=systemService.getShiroFilter();
        result.setData(list);
        result.setSuccess(true);
        return result;
    }

    @RequestMapping(value = "/sys/shiro/count",method = RequestMethod.GET)
    @ApiOperation(value = "统计shiro过滤链数")
    public Result<Object> getUserCount(){

        Long result=systemService.countShiroFilter();
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/sys/shiro/add",method = RequestMethod.POST)
    @ApiOperation(value = "添加shiro过滤链")
    public Result<Object> addShiro(@ModelAttribute TbShiroFilter tbShiroFilter){

        systemService.addShiroFilter(tbShiroFilter);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/sys/shiro/update",method = RequestMethod.POST)
    @ApiOperation(value = "更新shiro过滤链")
    public Result<Object> updateShiro(@ModelAttribute TbShiroFilter tbShiroFilter){

        systemService.updateShiroFilter(tbShiroFilter);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/sys/shiro/del/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "删除shiro过滤链")
    public Result<Object> delShiro(@PathVariable int[] ids){

        for(int id:ids){
            systemService.deleteShiroFilter(id);
        }
        return new ResultUtil<Object>().setData(null);
    }
}

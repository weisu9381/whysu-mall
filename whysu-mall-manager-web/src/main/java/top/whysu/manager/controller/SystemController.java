package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.IPInfoUtil;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.service.SystemService;

import javax.servlet.http.HttpServletRequest;

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
}

package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.pojo.TbUser;
import top.whysu.manager.service.UserService;

@RestController
@Api(description = "管理员管理")
public class UserController {

    private Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/user/login", method = RequestMethod.POST)
    @ApiOperation(value = "用户登录")
    public Result<Object> login(String username,String password){
        log.info("username="+username+",password="+password);
        Subject subject = SecurityUtils.getSubject();
        //Md5加密
        String md5Pwd = DigestUtils.md5DigestAsHex(password.getBytes());
        UsernamePasswordToken token = new UsernamePasswordToken(username,md5Pwd);
        try{
            subject.login(token);
            return new ResultUtil<Object>().setData(null);
        }catch (Exception e){
            return new ResultUtil<Object>().setErrorMsg("用户名或密码错误");
        }
    }

    @RequestMapping(value="/user/logout",method = RequestMethod.GET)
    @ApiOperation(value="退出登录")
    public Result<Object> logout(){
        Subject subject = SecurityUtils.getSubject();
        subject.logout();
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value="/user/userInfo",method = RequestMethod.GET)
    @ApiOperation(value = "用户信息")
    public Result<Object> userInfo(){
        String username = SecurityUtils.getSubject().getPrincipal().toString();
        log.debug("username="+username);
        TbUser tbUser = userService.getUserByUsername(username);
        return new ResultUtil<Object>().setData(tbUser);
    }
}

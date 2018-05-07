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
import org.springframework.web.bind.annotation.*;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.pojo.TbPermission;
import top.whysu.manager.pojo.TbRole;
import top.whysu.manager.pojo.TbUser;
import top.whysu.manager.service.UserService;

import java.util.List;

@RestController
@Api(description = "管理员管理")
public class UserController {

    private Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ApiOperation(value = "用户登录")
    public Result<Object> login(String username, String password) {
        try {
            log.info("username=" + username + ",password=" + password);
            Subject subject = SecurityUtils.getSubject();
            //Md5加密
            String md5Pwd = DigestUtils.md5DigestAsHex(password.getBytes());
            log.info("md5Pwd=" + md5Pwd);
            UsernamePasswordToken token = new UsernamePasswordToken(username, md5Pwd);
            subject.login(token);
            return new ResultUtil<Object>().setData(null);
        } catch (Exception e) {
            return new ResultUtil<Object>().setErrorMsg("用户名或密码错误");
        }
    }

    @RequestMapping(value = "/user/logout", method = RequestMethod.GET)
    @ApiOperation(value = "退出登录")
    public Result<Object> logout() {
        Subject subject = SecurityUtils.getSubject();
        subject.logout();
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/userInfo", method = RequestMethod.GET)
    @ApiOperation(value = "用户信息")
    public Result<Object> userInfo() {
        String username = SecurityUtils.getSubject().getPrincipal().toString();
        log.debug("username=" + username);
        TbUser tbUser = userService.getUserByUsername(username);
        return new ResultUtil<Object>().setData(tbUser);
    }

    @RequestMapping(value = "/user/roleList",method = RequestMethod.GET)
    @ApiOperation(value = "获取角色列表")
    public DataTablesResult getRoleList(){

        DataTablesResult result=userService.getRoleList();
        return result;
    }

    @RequestMapping(value = "/user/roleCount",method = RequestMethod.GET)
    @ApiOperation(value = "统计角色数")
    public Result<Object> getRoleCount(){

        Long result=userService.countRole();
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/user/roleName",method = RequestMethod.GET)
    @ApiOperation(value = "判断角色是否已存在")
    public boolean roleName(String name){

        //这里因为修改了 tomcat的server.xml中添加了URIEncoding="utf-8"，所以这里无需解决中文转码的问题
        /*name = new String(name.getBytes("iso-8859-1"),"utf-8");*/

        if(userService.getRoleByRoleName(name)!=null){
            return false;
        }
        return true;
    }

    @RequestMapping(value = "/user/edit/roleName/{id}",method = RequestMethod.GET)
    @ApiOperation(value = "判断编辑角色是否已存在")
    public boolean roleName(@PathVariable int id, String name){

        //这里因为修改了 tomcat的server.xml中添加了URIEncoding="utf-8"，所以这里无需解决中文转码的问题
        /*name = new String(name.getBytes("iso-8859-1"),"utf-8");*/

        //这里不使用getRoleByRoleName()的原因是通过id获得“原角色名”，如果“新角色名”和“原角色名”一样的话也是正确的
        //只有当“新角色名”和“原角色名”不一样时，才去查看和其它的重不重名，重名的话就返回false
        return userService.getRoleByEditName(id,name);
    }

    @RequestMapping(value = "/user/addRole",method = RequestMethod.POST)
    @ApiOperation(value = "添加角色")
    public Result<Object> addRole(@ModelAttribute TbRole tbRole){

        userService.addRole(tbRole);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/updateRole",method = RequestMethod.POST)
    @ApiOperation(value = "更新角色")
    public Result<Object> updateRole(@ModelAttribute TbRole tbRole){

        userService.updateRole(tbRole);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/delRole/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "删除角色")
    public Result<Object> delRole(@PathVariable int[] ids){

        for(int id:ids){
            int result=userService.deleteRole(id);
            if(result==0){
                return new ResultUtil<Object>().setErrorMsg("id为"+id+"的角色被使用中，不能删除！");
            }
        }
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/permissionList",method = RequestMethod.GET)
    @ApiOperation(value = "获取权限列表")
    public DataTablesResult getPermissionList(){

        DataTablesResult result=userService.getPermissionList();
        return result;
    }

    @RequestMapping(value = "/user/addPermission",method = RequestMethod.POST)
    @ApiOperation(value = "添加权限")
    public Result<Object> addPermission(@ModelAttribute TbPermission tbPermission){

        userService.addPermission(tbPermission);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/updatePermission",method = RequestMethod.POST)
    @ApiOperation(value = "更新权限")
    public Result<Object> updatePermission(@ModelAttribute TbPermission tbPermission){

        userService.updatePermission(tbPermission);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/delPermission/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "删除权限")
    public Result<Object> delPermission(@PathVariable int[] ids){

        for(int id:ids){
            userService.deletePermission(id);
        }
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/permissionCount",method = RequestMethod.GET)
    @ApiOperation(value = "统计权限数")
    public Result<Object> getPermissionCount(){

        Long result=userService.countPermission();
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/user/userList",method = RequestMethod.GET)
    @ApiOperation(value = "获取用户列表")
    public DataTablesResult getUserList(){

        DataTablesResult result=userService.getUserList();
        return result;
    }

    @RequestMapping(value = "/user/userCount",method = RequestMethod.GET)
    @ApiOperation(value = "统计用户数")
    public Result<Object> getUserCount(){

        Long result=userService.countUser();
        return new ResultUtil<Object>().setData(result);
    }

    @RequestMapping(value = "/user/getAllRoles",method = RequestMethod.GET)
    @ApiOperation(value = "获取所有角色")
    public Result<List<TbRole>> getAllRoles(){

        List<TbRole> list=userService.getAllRoles();
        return new ResultUtil<List<TbRole>>().setData(list);
    }

    @RequestMapping(value = "/user/username",method = RequestMethod.GET)
    @ApiOperation(value = "判断用户名是否存在")
    public boolean getUserByName(String username){
        //如果用户名已经被注册，返回false
        return !userService.isUsernameExist(username);
    }

    @RequestMapping(value = "/user/phone",method = RequestMethod.GET)
    @ApiOperation(value = "判断手机是否存在")
    public boolean getUserByPhone(String phone){
        //如果手机已经被注册，返回false
        return !userService.isUserPhoneExist(phone);
    }

    @RequestMapping(value = "/user/email",method = RequestMethod.GET)
    @ApiOperation(value = "判断邮箱是否存在")
    public boolean getUserByEmail(String email){
        //如果邮箱已经被注册，返回false
        return !userService.isUserEmailExist(email);
    }

    @RequestMapping(value = "/user/addUser",method = RequestMethod.POST)
    @ApiOperation(value = "添加用户")
    public Result<Object> addUser(@ModelAttribute TbUser tbUser){

        userService.addUser(tbUser);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/updateUser",method = RequestMethod.POST)
    @ApiOperation(value = "更新用户")
    public Result<Object> updateUser(@ModelAttribute TbUser tbUser){

        userService.updateUser(tbUser);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/edit/username/{id}",method = RequestMethod.GET)
    @ApiOperation(value = "判断编辑用户名是否存在")
    public boolean getUserByEditName(@PathVariable Long id, String username){

        //分为两种情况：一：新name和旧name一样的话，不报错，返回true
        //二：新name和旧name不一样，如果新name已经被使用的话，返回false
        return userService.getUserByEditName(id,username);
    }

    @RequestMapping(value = "/user/edit/phone/{id}",method = RequestMethod.GET)
    @ApiOperation(value = "判断编辑手机是否存在")
    public boolean getUserByEditPhone(@PathVariable Long id, String phone){

        return userService.getUserByEditPhone(id,phone);
    }

    @RequestMapping(value = "/user/edit/email/{id}",method = RequestMethod.GET)
    @ApiOperation(value = "判断编辑用户名是否存在")
    public boolean getUserByEditEmail(@PathVariable Long id, String email){

        return userService.getUserByEditEmail(id,email);
    }

    @RequestMapping(value = "/user/stop/{id}",method = RequestMethod.POST)
    @ApiOperation(value = "停用用户")
    public Result<Object> stopUser(@PathVariable Long id){

        userService.changeUserState(id,0);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/start/{id}",method = RequestMethod.POST)
    @ApiOperation(value = "启用用户")
    public Result<Object> startUser(@PathVariable Long id){

        userService.changeUserState(id,1);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/changePass",method = RequestMethod.POST)
    @ApiOperation(value = "修改用户密码")
    public Result<Object> changePass(@ModelAttribute TbUser tbUser){

        userService.changePassword(tbUser);
        return new ResultUtil<Object>().setData(null);
    }

    @RequestMapping(value = "/user/delUser/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "删除用户")
    public Result<Object> delUser(@PathVariable Long[] ids){

        for(Long id:ids){
            userService.deleteUser(id);
        }
        return new ResultUtil<Object>().setData(null);
    }
}

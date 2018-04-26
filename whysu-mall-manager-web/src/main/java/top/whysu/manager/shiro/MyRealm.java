package top.whysu.manager.shiro;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;
import top.whysu.manager.pojo.TbUser;
import top.whysu.manager.service.UserService;

/**
 * 首先根据用户名-密码判断用户是否合法，再对合法用户授权
 */
public class MyRealm extends AuthorizingRealm{

    @Autowired
    private UserService userService;

    /**
     * 先执行登录验证（身份验证）,角色信息集合。
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        //根据用户名获得 用户信息
        String username = token.getPrincipal().toString();
        TbUser tbUser = userService.getUserByUsername(username);
        if(tbUser != null){
            //将得到的用户名+密码(合法用户信息)，存放在AuthenticationInfo中，用于Controller层的权限判断，第三个参数不能为null
            AuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(tbUser.getUsername(),tbUser.getPassword(),tbUser.getUsername());
            return authenticationInfo;
        }else{
            return null;
        }
    }

    /**
     * 返回权限信息（授权），权限信息集合
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        //获取用户名
        String username = principalCollection.getPrimaryPrincipal().toString();
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        //获得授权角色
        authorizationInfo.setRoles(userService.getRolesByUsername(username));
        //获得授权权限
        authorizationInfo.setStringPermissions(userService.getPermissionsByUsername(username));
        return authorizationInfo;
    }
}

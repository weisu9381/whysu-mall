package top.whysu.manager.service;

import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.pojo.TbPermission;
import top.whysu.manager.pojo.TbRole;
import top.whysu.manager.pojo.TbUser;

import java.util.List;
import java.util.Set;

public interface UserService {
    /**通过用户名获取用户*/
    TbUser getUserByUsername(String username);
    /**通过用户名获取角色*/
    Set<String> getRolesByUsername(String username);
    /**通过用户名获取权限*/
    Set<String> getPermissionsByUsername(String username);
    /**获取角色列表*/
    DataTablesResult getRoleList();
    /**获取所有角色*/
    List<TbRole> getAllRoles();
    /**添加角色*/
    int addRole(TbRole tbRole);
    /**通过角色名获取角色*/
    TbRole getRoleByRoleName(String roleName);
    /**要给id所在的角色修改 name，需要判断该 name 是否在 tb_role中已经存在*/
    boolean getRoleByEditName(int id,String roleName);
    /**更新角色*/
    int updateRole(TbRole tbRole);
    /**删除角色*/
    int deleteRole(int id);
    /**统计角色数*/
    Long countRole();
    /**获得所有权限列表*/
    DataTablesResult getPermissionList();
    /**添加权限*/
    int addPermission(TbPermission tbPermission);
    /**更新权限*/
    int updatePermission(TbPermission tbPermission);
    /**删除权限*/
    int deletePermission(int id);
    /**统计权限*/
    Long countPermission();
    /**获取用户列表*/
    DataTablesResult getUserList();
    /**添加管理员*/
    int addUser(TbUser tbUser);
    /**通过ID获取用户*/
    TbUser getUserById(Long id);
    /**通过用户名获取(意思是判断该用户名是否已经存在)*/
    boolean isUsernameExist(String username);
    /**通过手机获取(意思是判断该手机号码是否已经存在)*/
    boolean isUserPhoneExist(String phone);
    /**判断邮件是否已经注册*/
    boolean isUserEmailExist(String email);
    /**更新用户*/
    int updateUser(TbUser tbUser);
    /**更改状态*/
    int changeUserState(Long id,int state);
    /**修改密码*/
    int changePassword(TbUser tbUser);
    /**判断编辑用户名*/
    boolean getUserByEditName(Long id,String username);
    /**判断编辑手机*/
    boolean getUserByEditPhone(Long id,String phone);
    /**判断编辑邮箱*/
    boolean getUserByEditEmail(Long id,String emaill);
    /**删除管理员*/
    int deleteUser(Long userId);
    /**统计管理员*/
    Long countUser();
}

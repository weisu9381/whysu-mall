package top.whysu.manager.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.RoleDto;
import top.whysu.manager.mapper.TbPermissionMapper;
import top.whysu.manager.mapper.TbRoleMapper;
import top.whysu.manager.mapper.TbRolePermMapper;
import top.whysu.manager.mapper.TbUserMapper;
import top.whysu.manager.pojo.*;
import top.whysu.manager.service.UserService;

import java.util.*;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    private TbUserMapper tbUserMapper;

    @Autowired
    private TbRoleMapper tbRoleMapper;

    @Autowired
    private TbPermissionMapper tbPermissionMapper;

    @Autowired
    private TbRolePermMapper tbRolePermMapper;

    @Override
    public TbUser getUserByUsername(String username) {
        TbUserExample example = new TbUserExample();
        TbUserExample.Criteria criteria = example.createCriteria();
        criteria.andUsernameEqualTo(username);
        criteria.andStateEqualTo(1);
        List<TbUser> list;
        try {
            list = tbUserMapper.selectByExample(example);
        } catch (Exception e) {
            throw new WhysuMallException("通过用户名获取用户信息失败");
        }
        if(!list.isEmpty()){
            return list.get(0);
        }
        return null;
    }

    @Override
    public Set<String> getRolesByUsername(String username) {
        return tbUserMapper.getRolesByUsername(username);
    }

    @Override
    public Set<String> getPermissionsByUsername(String username) {
        return tbUserMapper.getPermissionsByUsername(username);
    }

    @Override
    public DataTablesResult getRoleList() {
        DataTablesResult result = new DataTablesResult();
        List<RoleDto> roleDtoList = new ArrayList<>();
        TbRoleExample example = new TbRoleExample();
        List<TbRole> tbRoleList = tbRoleMapper.selectByExample(example);
        if(tbRoleList == null){
            throw new WhysuMallException("获取角色列表失败");
        }
        for(TbRole tbRole : tbRoleList){
            RoleDto roleDto = new RoleDto();
            roleDto.setId(tbRole.getId());
            roleDto.setName(tbRole.getName());
            roleDto.setDescription(tbRole.getDescription());

            List<String> permissions=tbUserMapper.getPermsByRoleId(tbRole.getId());
            String names="";
            if(permissions.size()>1){
                names+=permissions.get(0);
                for(int i=1;i<permissions.size();i++){
                    names+="|"+permissions.get(i);
                }
            }else if(permissions.size()==1){
                names+=permissions.get(0);
            }
            roleDto.setPermissions(names);

            roleDtoList.add(roleDto);
        }
        result.setData(roleDtoList);
        return result;
    }

    @Override
    public List<TbRole> getAllRoles() {
        TbRoleExample example = new TbRoleExample();
        List<TbRole> list = tbRoleMapper.selectByExample(example);
        if(list == null){
            throw new WhysuMallException("获取所有角色权限失败");
        }
        return list;
    }

    @Override
    public int addRole(TbRole tbRole) {
        if(getRoleByRoleName(tbRole.getName())!=null){
            throw new WhysuMallException("该角色名已存在");
        }
        if(tbRoleMapper.insert(tbRole)!=1){
            throw new WhysuMallException("添加角色失败");
        }
        if(tbRole.getRoles()!=null){
            //因为前面已经给 TbRole插入了新的name,并且默认赋予了id
            //所以接下来，是给该角色指定【权限】
            TbRole newRole=getRoleByRoleName(tbRole.getName());
            for(int i=0;i<tbRole.getRoles().length;i++){
                TbRolePerm tbRolePerm=new TbRolePerm();
                tbRolePerm.setRoleId(newRole.getId());
                tbRolePerm.setPermissionId(tbRole.getRoles()[i]);
                if(tbRolePermMapper.insert(tbRolePerm)!=1){
                    throw new WhysuMallException("添加角色-权限失败");
                }
            }
        }
        return 1;
    }

    @Override
    public TbRole getRoleByRoleName(String roleName) {
        TbRoleExample example = new TbRoleExample();
        TbRoleExample.Criteria criteria = example.createCriteria();
        criteria.andNameEqualTo(roleName);
        List<TbRole> list = null;
        try {
            list = tbRoleMapper.selectByExample(example);
        } catch (Exception e) {
            throw new WhysuMallException("通过角色名获取角色失败");
        }
        if(!list.isEmpty()){
            return list.get(0);
        }
        return null;
    }

    @Override
    public boolean getRoleByEditName(int id, String roleName) {
        TbRole tbRole=tbRoleMapper.selectByPrimaryKey(id);
        TbRole newRole=null;
        if(tbRole==null){
            throw new WhysuMallException("通过ID获取角色失败");
        }
        //判断要修改的name 是否已经在 tb_role中存在
        if(!tbRole.getName().equals(roleName)){
            newRole=getRoleByRoleName(roleName);
        }
        return newRole == null;
    }

    @Override
    public int updateRole(TbRole tbRole) {
        if(!getRoleByEditName(tbRole.getId(),tbRole.getName())){
            throw new WhysuMallException("该角色名已经存在");
        }
        if(tbRoleMapper.updateByPrimaryKey(tbRole)!= 1){
            throw new WhysuMallException("更新角色失败");
        }
        //删除tb_role_perm中含有role_id的部分
        TbRolePermExample example = new TbRolePermExample();
        TbRolePermExample.Criteria criteria = example.createCriteria();
        criteria.andRoleIdEqualTo(tbRole.getId());
        List<TbRolePerm> list = tbRolePermMapper.selectByExample(example);
        if(list != null){
            for(TbRolePerm tbRolePerm:list){
                if(tbRolePermMapper.deleteByPrimaryKey(tbRolePerm.getId())!= 1){
                    throw new WhysuMallException("删除角色权限失败");
                }
            }
        }
        //新增。如果含有Integer[] roles(表示权限id的集合)的话
        if(tbRole.getRoles() != null){
            for(int i = 0; i < tbRole.getRoles().length; i++){
                TbRolePerm tbRolePerm = new TbRolePerm();
                tbRolePerm.setRoleId(tbRole.getId());
                tbRolePerm.setPermissionId(tbRole.getRoles()[i]);
                if(tbRolePermMapper.insert(tbRolePerm) != 1){
                    throw new WhysuMallException("编辑角色-权限失败");
                }
            }
        }
        return 1;
    }

    @Override
    public int deleteRole(int id) {

        List<String> list=tbRoleMapper.getUsedRoles(id);
        if(list==null){
            throw new WhysuMallException("查询用户角色失败");
        }
        if(list.size()>0){
            return 0;
        }
        if(tbRoleMapper.deleteByPrimaryKey(id)!=1){
            throw new WhysuMallException("删除角色失败");
        }
        TbRolePermExample example=new TbRolePermExample();
        TbRolePermExample.Criteria criteria=example.createCriteria();
        criteria.andRoleIdEqualTo(id);
        List<TbRolePerm> list1=tbRolePermMapper.selectByExample(example);
        if(list1==null){
            throw new WhysuMallException("查询角色权限失败");
        }
        for(TbRolePerm tbRolePerm:list1){
            if(tbRolePermMapper.deleteByPrimaryKey(tbRolePerm.getId())!=1){
                throw new WhysuMallException("删除角色权限失败");
            }
        }
        return 1;
    }

    @Override
    public Long countRole() {
        TbRoleExample example = new TbRoleExample();
        return  tbRoleMapper.countByExample(example);
    }

    @Override
    public DataTablesResult getPermissionList() {
        TbPermissionExample example = new TbPermissionExample();
        List<TbPermission> list = tbPermissionMapper.selectByExample(example);
        if(list == null){
            throw new WhysuMallException("获得权限列表失败");
        }
        DataTablesResult result = new DataTablesResult();
        result.setSuccess(true);
        result.setData(list);
        return result;
    }

    @Override
    public int addPermission(TbPermission tbPermission) {
        if(tbPermissionMapper.insert(tbPermission) != 1){
            throw new WhysuMallException("添加权限失败");
        }
        return 1;
    }

    @Override
    public int updatePermission(TbPermission tbPermission) {
        if(tbPermissionMapper.updateByPrimaryKey(tbPermission)!=1){
            throw new WhysuMallException("更新权限失败");
        }
        return 1;
    }

    @Override
    public int deletePermission(int id) {
        if(tbPermissionMapper.deleteByPrimaryKey(id)!=1){
            throw new WhysuMallException("删除权限失败");
        }
        TbRolePermExample example=new TbRolePermExample();
        TbRolePermExample.Criteria criteria=example.createCriteria();
        criteria.andPermissionIdEqualTo(id);
        tbRolePermMapper.deleteByExample(example);
        return 1;
    }

    @Override
    public Long countPermission() {
        TbPermissionExample example=new TbPermissionExample();
        return tbPermissionMapper.countByExample(example);
    }

    @Override
    public DataTablesResult getUserList() {
        TbUserExample example = new TbUserExample();
        List<TbUser> list = tbUserMapper.selectByExample(example);
        if(list == null){
            throw new WhysuMallException("获取用户列表失败");
        }
        DataTablesResult result = new DataTablesResult();
        for(TbUser tbUser : list){
            String names = "";
            Iterator it = getRolesByUsername(tbUser.getUsername()).iterator();
            while(it.hasNext()){
                names += it.next() + " ";
            }
            tbUser.setPassword("");
            tbUser.setRoleNames(names);
        }
        result.setData(list);
        return result;
    }



    @Override
    public TbUser getUserById(Long id) {
        TbUser tbUser=tbUserMapper.selectByPrimaryKey(id);
        if(tbUser==null){
            throw new WhysuMallException("通过ID获取用户失败");
        }
        tbUser.setPassword("");
        return tbUser;
    }

    @Override
    public boolean isUsernameExist(String username) {
        TbUserExample example=new TbUserExample();
        TbUserExample.Criteria criteria=example.createCriteria();
        criteria.andUsernameEqualTo(username);
        List<TbUser> list=tbUserMapper.selectByExample(example);
        if(list.size()!=0){
            return true;
        }
        return false;
    }

    @Override
    public boolean isUserPhoneExist(String phone) {
        TbUserExample example=new TbUserExample();
        TbUserExample.Criteria criteria=example.createCriteria();
        criteria.andPhoneEqualTo(phone);
        List<TbUser> list=tbUserMapper.selectByExample(example);
        if(list.size()!=0){
            return true;
        }
        return false;
    }

    @Override
    public boolean isUserEmailExist(String email) {
        TbUserExample example=new TbUserExample();
        TbUserExample.Criteria criteria=example.createCriteria();
        criteria.andEmailEqualTo(email);
        List<TbUser> list=tbUserMapper.selectByExample(example);
        if(list.size()!=0){
            return true;
        }
        return false;
    }

    @Override
    public int addUser(TbUser tbUser) {
        if(isUsernameExist(tbUser.getUsername())){
            throw new WhysuMallException("用户名已经存在");
        }
        if(isUserPhoneExist(tbUser.getPhone())){
            throw new WhysuMallException("手机号已经存在");
        }
        if(isUserEmailExist(tbUser.getEmail())){
            throw new WhysuMallException("邮箱已经存在");
        }
        String md5Pwd = DigestUtils.md5DigestAsHex(tbUser.getPassword().getBytes());
        tbUser.setPassword(md5Pwd);
        tbUser.setState(1);
        tbUser.setCreated(new Date());
        tbUser.setUpdated(new Date());
        if(tbUserMapper.insert(tbUser)!= 1){
            throw new WhysuMallException("添加用户失败");
        }
        return 1;
    }

    @Override
    public int updateUser(TbUser user) {
        TbUser old=tbUserMapper.selectByPrimaryKey(user.getId());
        user.setPassword(old.getPassword());
        user.setState(old.getState());
        user.setCreated(old.getCreated());
        user.setUpdated(new Date());
        if(tbUserMapper.updateByPrimaryKey(user)!=1){
            throw new WhysuMallException("更新用户失败");
        }
        return 1;
    }

    @Override
    public int changeUserState(Long id, int state) {
        TbUser tbUser=tbUserMapper.selectByPrimaryKey(id);
        tbUser.setState(state);
        tbUser.setUpdated(new Date());
        if(tbUserMapper.updateByPrimaryKey(tbUser)!=1){
            throw new WhysuMallException("更新用户状态失败");
        }
        return 1;
    }

    @Override
    public int changePassword(TbUser tbUser) {
        TbUser old=tbUserMapper.selectByPrimaryKey(tbUser.getId());
        old.setUpdated(new Date());
        String md5Pass = DigestUtils.md5DigestAsHex(tbUser.getPassword().getBytes());
        old.setPassword(md5Pass);
        if(tbUserMapper.updateByPrimaryKey(old)!=1){
            throw new WhysuMallException("修改用户密码失败");
        }
        return 1;
    }

    /**
     * 我有点方，暂时不知道这方法干嘛用的，还有boolean类型的方法你用get来命名
     */
    @Override
    public boolean getUserByEditName(Long id, String username) {
        TbUser tbUser=getUserById(id);
        boolean result=true;
        if(tbUser.getUsername()==null||!tbUser.getUsername().equals(username)){
            result=isUsernameExist(username);
        }
        return result;
    }

    @Override
    public boolean getUserByEditPhone(Long id, String phone) {
        TbUser tbUser=getUserById(id);
        boolean result=true;
        if(tbUser.getPhone()==null||!tbUser.getPhone().equals(phone)){
            result=isUserPhoneExist(phone);
        }
        return result;
    }

    @Override
    public boolean getUserByEditEmail(Long id, String email) {
        TbUser tbUser=getUserById(id);
        boolean result=true;
        if(tbUser.getEmail()==null||!tbUser.getEmail().equals(email)){
            result=isUserEmailExist(email);
        }
        return result;
    }

    @Override
    public int deleteUser(Long userId) {
        if(tbUserMapper.deleteByPrimaryKey(userId)!=1){
            throw new WhysuMallException("删除用户失败");
        }
        return 1;
    }

    @Override
    public Long countUser() {
        TbUserExample example=new TbUserExample();
        return tbUserMapper.countByExample(example);
    }
}

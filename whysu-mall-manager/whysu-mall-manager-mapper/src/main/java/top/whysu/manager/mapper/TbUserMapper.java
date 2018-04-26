package top.whysu.manager.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import top.whysu.manager.pojo.TbUser;
import top.whysu.manager.pojo.TbUserExample;

import java.util.List;
import java.util.Set;

@Repository
public interface TbUserMapper {
    long countByExample(TbUserExample example);

    int deleteByExample(TbUserExample example);

    int deleteByPrimaryKey(Long id);

    int insert(TbUser record);

    int insertSelective(TbUser record);

    List<TbUser> selectByExample(TbUserExample example);

    TbUser selectByPrimaryKey(Long id);

    int updateByExampleSelective(@Param("record") TbUser record, @Param("example") TbUserExample example);

    int updateByExample(@Param("record") TbUser record, @Param("example") TbUserExample example);

    int updateByPrimaryKeySelective(TbUser record);

    int updateByPrimaryKey(TbUser record);

    Set<String> getRolesByUsername(@Param("username")String username);

    Set<String> getPermissionsByUsername(@Param("username")String username);

    List<String> getPermsByRoleId(@Param("id")int id);
}
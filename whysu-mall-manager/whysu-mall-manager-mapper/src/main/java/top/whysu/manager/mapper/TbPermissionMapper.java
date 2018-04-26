package top.whysu.manager.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import top.whysu.manager.pojo.TbPermission;
import top.whysu.manager.pojo.TbPermissionExample;

import java.util.List;
@Repository
public interface TbPermissionMapper {
    long countByExample(TbPermissionExample example);

    int deleteByExample(TbPermissionExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(TbPermission record);

    int insertSelective(TbPermission record);

    List<TbPermission> selectByExample(TbPermissionExample example);

    TbPermission selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") TbPermission record, @Param("example") TbPermissionExample example);

    int updateByExample(@Param("record") TbPermission record, @Param("example") TbPermissionExample example);

    int updateByPrimaryKeySelective(TbPermission record);

    int updateByPrimaryKey(TbPermission record);
}
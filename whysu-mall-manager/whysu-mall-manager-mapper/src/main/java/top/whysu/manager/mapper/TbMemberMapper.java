package top.whysu.manager.mapper;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.pojo.TbMemberExample;

import java.util.List;
@Repository
public interface TbMemberMapper {
    long countByExample(TbMemberExample example);

    int deleteByExample(TbMemberExample example);

    int deleteByPrimaryKey(Long id);

    int insert(TbMember record);

    int insertSelective(TbMember record);

    List<TbMember> selectByExample(TbMemberExample example);

    TbMember selectByPrimaryKey(Long id);

    int updateByExampleSelective(@Param("record") TbMember record, @Param("example") TbMemberExample example);

    int updateByExample(@Param("record") TbMember record, @Param("example") TbMemberExample example);

    int updateByPrimaryKeySelective(TbMember record);

    int updateByPrimaryKey(TbMember record);

    List<TbMember> selectByMemberInfo(@Param("search")String search,@Param("minDate")String minDate,@Param("maxDate")String maxDate,
                                      @Param("orderCol")String orderCol,@Param("orderDir")String orderDir);
    
    List<TbMember> selectByRemoveMemeberInfo(@Param("search")String search,@Param("minDate")String minDate,@Param("maxDate")String maxDate,
                                             @Param("orderCol")String orderCol,@Param("orderDir")String orderDir);
}
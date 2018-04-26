package top.whysu.manager.service;

import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.dto.MemberDto;
import top.whysu.manager.pojo.TbMember;

public interface MemberService {
    /**根据ID获取会员信息*/
    TbMember getMemberById(long id);
    /**分页获取会员列表*/
    DataTablesResult getMemberList(int draw,int start,int length,String search,String minDate,String maxDate,String orderCol,String orderDir);
    /**分页获取移除会员列表*/
    DataTablesResult getRemoveMemberList(int draw,int start,int length,String search,String minDate,String maxDate,String orderCol,String orderDir);
    /**获得所有会员总数*/
    DataTablesResult getMemberCount();
    /**获得移除会员总数*/
    DataTablesResult getRemoveMemberCount();
    /**通过email获取会员*/
    TbMember getMemberByEmail(String email);
    /**通过phone获取会员*/
    TbMember getMemberByPhone(String phone);
    /**通过username获取会员*/
    TbMember getMemberByUsername(String username);
    /**添加会员*/
    TbMember addMember(MemberDto memberDto);
    /**更新会员*/
    TbMember updateMember(Long id,MemberDto memberDto);
    /**修改会员密码*/
    TbMember changePassMember(Long id,MemberDto memberDto);
    /**修改会员状态*/
    TbMember alertMemberState(Long id,Integer state);
    /**彻底删除会员*/
    int deleteMember(Long id);
    /**验证编辑手机邮箱是否存在*/
    TbMember getMemberByEditEmail(Long id,String email);
    /**验证编辑手机号码是否存在*/
    TbMember getMemberByEditPhone(Long id,String phone);
    /**验证编辑用户名是否存在*/
    TbMember getMemberByEditUsername(Long id,String username);
}

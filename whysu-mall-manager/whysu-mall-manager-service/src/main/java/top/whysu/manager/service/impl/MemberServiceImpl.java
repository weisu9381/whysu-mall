package top.whysu.manager.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.dto.MemberDto;
import top.whysu.manager.mapper.TbMemberMapper;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.pojo.TbMemberExample;
import top.whysu.manager.service.MemberService;

import java.util.Date;
import java.util.List;

@Service
public class MemberServiceImpl implements MemberService{

    private Logger log = LoggerFactory.getLogger(MemberServiceImpl.class);

    @Autowired
    private TbMemberMapper tbMemberMapper;

    @Override
    public TbMember getMemberById(long id) {
        TbMember tbMember;
        try {
            tbMember = tbMemberMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            throw  new WhysuMallException("ID获取会员信息失败");
        }
        tbMember.setPassword("");
        return tbMember;
    }

    @Override
    public DataTablesResult getMemberList(int draw, int start, int length, String search, String minDate, String maxDate, String orderCol, String orderDir) {
        DataTablesResult result = new DataTablesResult();
        try {
            //分页
            PageHelper.startPage(start/length + 1,length);
            List<TbMember> list = tbMemberMapper.selectByMemberInfo("%"+search+"%",minDate,maxDate,orderCol,orderDir);
            PageInfo<TbMember> pageInfo = new PageInfo<>(list);
            for(TbMember tbMember : list){
                tbMember.setPassword("");
            }
            result.setRecordsTotal(getMemberCount().getRecordsTotal());
            result.setRecordsFiltered((int) pageInfo.getTotal());
            result.setDraw(draw);
            result.setData(list);
        } catch (Exception e) {
            throw new WhysuMallException("加载用户列表失败");
        }
        return result;
    }

    @Override
    public DataTablesResult getRemoveMemberList(int draw, int start, int length, String search, String minDate, String maxDate, String orderCol, String orderDir) {
        DataTablesResult result = new DataTablesResult();
        try {
            //分页
            PageHelper.startPage(start/length + 1, length);
            List<TbMember> list = tbMemberMapper.selectByRemoveMemeberInfo("%"+search+"%",minDate,maxDate,orderCol,orderDir);
            PageInfo<TbMember> pageInfo = new PageInfo<>(list);

            for(TbMember tbMember : list){
                tbMember.setPassword("");
            }

            result.setRecordsTotal(getRemoveMemberCount().getRecordsTotal());
            result.setRecordsFiltered((int) pageInfo.getTotal());
            result.setDraw(draw);
            result.setData(list);
        } catch (Exception e) {
            throw new WhysuMallException("加载已删除用户列表失败");
        }
        return result;
    }

    @Override
    public DataTablesResult getMemberCount() {
        DataTablesResult result = new DataTablesResult();
        TbMemberExample example = new TbMemberExample();
        TbMemberExample.Criteria criteria = example.createCriteria();
        criteria.andStateNotEqualTo(2);
        try {
            result.setRecordsTotal((int) tbMemberMapper.countByExample(example));
        } catch (Exception e) {
            throw new WhysuMallException("统计会员数失败");
        }
        return result;
    }

    @Override
    public DataTablesResult getRemoveMemberCount() {
        DataTablesResult result = new DataTablesResult();
        TbMemberExample example = new TbMemberExample();
        TbMemberExample.Criteria criteria = example.createCriteria();
        criteria.andStateEqualTo(2);
        try {
            result.setRecordsTotal((int) tbMemberMapper.countByExample(example));
        } catch (Exception e) {
            throw new WhysuMallException("统计已删除会员数失败");
        }
        return result;
    }

    @Override
    public TbMember getMemberByEmail(String email) {
        List<TbMember> list;
        TbMemberExample example = new TbMemberExample();
        TbMemberExample.Criteria criteria = example.createCriteria();
        criteria.andEmailEqualTo(email);
        try {
            list = tbMemberMapper.selectByExample(example);
        } catch (Exception e) {
            throw new WhysuMallException("通过Email获取会员信息失败");
        }
        if(!list.isEmpty()) {
            list.get(0).setPassword("");
            return list.get(0);
        }
        return null;
    }

    @Override
    public TbMember getMemberByPhone(String phone) {
        List<TbMember> list;
        TbMemberExample example=new TbMemberExample();
        TbMemberExample.Criteria criteria=example.createCriteria();
        criteria.andPhoneEqualTo(phone);
        try {
            list=tbMemberMapper.selectByExample(example);
        }catch (Exception e){
            throw new WhysuMallException("通过Phone获取会员信息失败");
        }
        if(!list.isEmpty()){
            list.get(0).setPassword("");
            return list.get(0);
        }
        return null;
    }

    @Override
    public TbMember getMemberByUsername(String username) {
        List<TbMember> list;
        TbMemberExample example=new TbMemberExample();
        TbMemberExample.Criteria criteria=example.createCriteria();
        criteria.andUsernameEqualTo(username);
        try {
            list=tbMemberMapper.selectByExample(example);
        }catch (Exception e){
            throw new WhysuMallException("通过Username获取会员信息失败");
        }
        if(!list.isEmpty()){
            list.get(0).setPassword("");
            return list.get(0);
        }
        return null;
    }

    @Override
    public TbMember addMember(MemberDto memberDto) {
        TbMember tbMember = DtoUtil.MemberDto2TbMember(memberDto);
        if(getMemberByUsername(tbMember.getUsername()) != null){
            throw new WhysuMallException("用户名已经被注册");
        }
        if(getMemberByPhone(tbMember.getPhone()) != null){
            throw new WhysuMallException("手机号已经被注册");
        }
        if(getMemberByEmail(tbMember.getEmail()) != null){
            throw new WhysuMallException("邮箱已经被注册");
        }
        tbMember.setState(1);
        tbMember.setCreated(new Date());
        tbMember.setUpdated(new Date());
        String md5Pwd = DigestUtils.md5DigestAsHex(memberDto.getPassword().getBytes());
        tbMember.setPassword(md5Pwd);
        if(tbMemberMapper.insert(tbMember) != 1){
            throw new WhysuMallException("添加用户失败");
        }
        return getMemberByPhone(tbMember.getPhone());
    }

    @Override
    public TbMember updateMember(Long id, MemberDto memberDto) {
        TbMember oldMember = getMemberById(id);
        TbMember newMember = DtoUtil.MemberDto2TbMember(memberDto);
        newMember.setId(id);
        newMember.setUpdated(new Date());
        newMember.setState(oldMember.getState());
        newMember.setCreated(oldMember.getCreated());
        if(newMember.getPassword() == null || newMember.getPassword() == ""){
            newMember.setPassword(oldMember.getPassword());
        }else{
            String md5Pwd = DigestUtils.md5DigestAsHex(newMember.getPassword().getBytes());
            newMember.setPassword(md5Pwd);
        }
        if(tbMemberMapper.updateByPrimaryKey(newMember) != 1){
            throw new WhysuMallException("更新会员信息失败");
        }
        return getMemberById(id);
    }

    @Override
    public TbMember changePassMember(Long id, MemberDto memberDto) {
        TbMember tbMember = getMemberById(id);
        String md5Pwd = DigestUtils.md5DigestAsHex(memberDto.getPassword().getBytes());
        tbMember.setPassword(md5Pwd);
        tbMember.setUpdated(new Date());
        if(tbMemberMapper.updateByPrimaryKey(tbMember) != 1){
            throw new WhysuMallException("修改会员密码失败");
        }
        return getMemberById(id);
    }

    @Override
    public TbMember alertMemberState(Long id, Integer state) {
        TbMember tbMember = getMemberById(id);
        tbMember.setState(state);
        tbMember.setUpdated(new Date());
        if(tbMemberMapper.updateByPrimaryKey(tbMember) != 1){
            throw new WhysuMallException("修改会员状态失败");
        }
        return getMemberById(id);
    }

    @Override
    public int deleteMember(Long id) {
        if(tbMemberMapper.deleteByPrimaryKey(id) != 1){
            throw new WhysuMallException("删除会员失败");
        }
        return 0;
    }

    @Override
    public boolean getMemberByEditEmail(Long id, String email) {
        TbMember tbMember = tbMemberMapper.selectByPrimaryKey(id);
        if(tbMember == null){
            throw new WhysuMallException("MemberServiceImpl: 通过ID获取用户失败");
        }
        if(tbMember.getEmail().equals(email)){
            //新邮箱和旧邮箱一样，也是可以用的
            return true;
        }else{
            TbMember newMember = getMemberByEmail(email);
            if(newMember != null){
                //说明新邮箱已经被注册，不可使用
                return false;
            }else{
                //说明新邮箱未被注册，可使用
                return true;
            }
        }
    }

    @Override
    public boolean getMemberByEditPhone(Long id, String phone) {
        TbMember tbMember = tbMemberMapper.selectByPrimaryKey(id);
        if(tbMember == null){
            throw new WhysuMallException("MemberServiceImpl: 通过ID获取用户失败");
        }
        if(tbMember.getPhone().equals(phone)){
            //新号码和原号码一样，也是可以用的
            return true;
        }else{
            TbMember newMember = getMemberByPhone(phone);
            if(newMember != null){
                //说明新号码已经被注册，不可使用
                return false;
            }else{
                //说明新号码未被注册，可使用
                return true;
            }
        }
    }

    @Override
    public boolean getMemberByEditUsername(Long id, String username) {
        TbMember tbMember = tbMemberMapper.selectByPrimaryKey(id);
        if(tbMember == null){
            throw new WhysuMallException("MemberServiceImpl: 通过ID获取用户失败");
        }
        if(tbMember.getUsername().equals(username)){
            //新用户名和原用户名一样，也是可以用的
            return true;
        }else{
            TbMember newMember = getMemberByUsername(username);
            if(newMember != null){
                //说明用户名已经被注册，不可使用
                return false;
            }else{
                //说明用户名未被注册，可使用
                return true;
            }
        }

    }
}

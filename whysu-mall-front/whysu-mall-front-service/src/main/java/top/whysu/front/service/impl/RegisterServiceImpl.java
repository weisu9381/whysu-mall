package top.whysu.front.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.front.service.RegisterService;
import top.whysu.manager.mapper.TbMemberMapper;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.pojo.TbMemberExample;

import java.util.Date;
import java.util.List;

@Service
public class RegisterServiceImpl implements RegisterService {

    @Autowired
    private TbMemberMapper tbMemberMapper;

    /**
     * 检查 用户名，手机，邮箱 是否已经被注册
     * @param param
     * @param type
     * @return
     */
    @Override
    public boolean checkData(String param, int type) {
        TbMemberExample example = new TbMemberExample();
        TbMemberExample.Criteria criteria = example.createCriteria();
        criteria.andStateEqualTo(1);
        //1：用户名 2：手机号 3：邮箱
        if (type == 1) {
            criteria.andUsernameEqualTo(param);
        } else if (type == 2) {
            criteria.andPhoneEqualTo(param);
        } else if (type == 3) {
            criteria.andEmailEqualTo(param);
        } else {
            return false;
        }

        List<TbMember> list = tbMemberMapper.selectByExample(example);
        if (list != null && list.size()>0) {
            return false;
        }
        return true;
    }

    @Override
    public int register(String userName, String userPwd) {
        TbMember tbMember=new TbMember();
        tbMember.setUsername(userName);

        if(userName.isEmpty()||userPwd.isEmpty()){
            return -1; //用户名密码不能为空
        }
        boolean result = checkData(userName, 1);
        if (!result) {
            return 0; //该用户名已被注册
        }

        //MD5加密
        String md5Pass = DigestUtils.md5DigestAsHex(userPwd.getBytes());
        tbMember.setPassword(md5Pass);
        tbMember.setState(1);
        tbMember.setCreated(new Date());
        tbMember.setUpdated(new Date());

        if(tbMemberMapper.insert(tbMember)!=1){
            throw new WhysuMallException("注册用户失败");
        }
        return 1;
    }
}

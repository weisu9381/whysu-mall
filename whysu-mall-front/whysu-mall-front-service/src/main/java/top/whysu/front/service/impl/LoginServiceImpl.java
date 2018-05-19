package top.whysu.front.service.impl;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;
import top.whysu.common.jedis.JedisClient;
import top.whysu.front.service.LoginService;
import top.whysu.manager.dto.DtoUtil;
import top.whysu.manager.dto.front.Member;
import top.whysu.manager.mapper.TbMemberMapper;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.pojo.TbMemberExample;

import java.util.List;
import java.util.UUID;

@Service
public class LoginServiceImpl implements LoginService{

    private Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);

    @Autowired
    private TbMemberMapper tbMemberMapper;

    @Autowired
    private JedisClient jedisClient;

    @Value("${SESSION_EXPIRE}")
    private String SESSION_EXPIRE;

    @Override
    public Member userLogin(String username, String password) {
        TbMemberExample example = new TbMemberExample();
        TbMemberExample.Criteria criteria = example.createCriteria();
        criteria.andStateEqualTo(1);
        criteria.andUsernameEqualTo(username);
        List<TbMember> list = tbMemberMapper.selectByExample(example);
        if (list == null || list.size() == 0) {
            Member member=new Member();
            member.setState(0);
            member.setMessage("用户名或密码错误");
            return member;
        }
        TbMember tbMember = list.get(0);
        //md5加密
        if (!DigestUtils.md5DigestAsHex(password.getBytes()).equals(tbMember.getPassword())) {
            Member member=new Member();
            member.setState(0);
            member.setMessage("用户名或密码错误");
            return member;
        }
        String token = UUID.randomUUID().toString();
        Member member= DtoUtil.TbMemer2Member(tbMember);
        member.setToken(token);
        member.setState(1);
        // 用户信息写入redis：key："SESSION:token" value："user"
        jedisClient.set("SESSION:" + token, new Gson().toJson(member));
        jedisClient.expire("SESSION:" + token, Integer.parseInt(SESSION_EXPIRE));

        return member;
    }

    @Override
    public Member getUserByToken(String token) {
        String json = jedisClient.get("SESSION:" + token);
        if (json==null) {
            Member member=new Member();
            member.setState(0);
            member.setMessage("用户登录已过期");
            return member;
        }
        //重置过期时间
        jedisClient.expire("SESSION:" + token, Integer.parseInt(SESSION_EXPIRE));
        Member member = new Gson().fromJson(json,Member.class);
        return member;
    }

    @Override
    public int logout(String token) {
        jedisClient.del("SESSION:" + token);
        return 1;
    }
}

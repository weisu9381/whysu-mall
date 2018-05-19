package top.whysu.front.service.impl;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.jedis.JedisClient;
import top.whysu.front.fastdfs.FastDFSClient;
import top.whysu.front.fastdfs.FastDFSException;
import top.whysu.front.service.LoginService;
import top.whysu.front.service.MemberService;
import top.whysu.manager.dto.front.Member;
import top.whysu.manager.mapper.TbMemberMapper;
import top.whysu.manager.pojo.TbMember;

@Service
public class MemberServiceImpl implements MemberService{

    private Logger log = LoggerFactory.getLogger(MemberServiceImpl.class);

    /**
     * FastDFS秘钥
     */
    @Value("${fastdfs.http_secret_key}")
    private String fastDFSHttpSecretKey;

    /**
     * 文件服务器地址
     */
    @Value("${file_server_addr}")
    private String fileServerAddr;

    @Autowired
    private LoginService loginService;

    @Autowired
    private JedisClient jedisClient;

    @Autowired
    private TbMemberMapper tbMemberMapper;

    private FastDFSClient fastDFSClient = new FastDFSClient();

    @Override
    public String imageUpload(Long userId, String token, String imgData) {
        //imgData的类似： data:image/jpeg;base64,XXX 后面跟的是图片
        //所以需要截取
        String base64 = "";
        if(imgData!=null||!imgData.isEmpty()){
            base64 =imgData.substring(imgData.lastIndexOf(",")+1);
        }

        //上传图片到FastDFS服务器，获取图片保存地址
        String imgPath = uploadFileWithBase64(base64);
        if(imgPath == null){
            throw new WhysuMallException("上传fastdfs图片失败");
        }
        TbMember tbMember=tbMemberMapper.selectByPrimaryKey(userId);
        if(tbMember==null){
            throw new WhysuMallException("通过id获取用户失败");
        }
        tbMember.setFile(imgPath);
        if(tbMemberMapper.updateByPrimaryKey(tbMember)!=1){
            throw new WhysuMallException("更新用户头像失败");
        }
        //更新缓存
        Member member=loginService.getUserByToken(token);
        member.setFile(imgPath);
        jedisClient.set("SESSION:" + token, new Gson().toJson(member));
        return imgPath;
    }

    /**
     * 上传通用方法，只上传到服务器，不保存记录到数据库
     *
     * @return
     */
    public String uploadFileWithBase64(String base64){
        try {
            // 上传到服务器，得到的路径是group1/M00/00/00/wKh9gVronamABhBLAAB_hRwU00A836.jpg
            String filepath = fastDFSClient.uploadFileWithBase64(base64);
            // 设置访文件的Http地址. 有时效性.
            String token = FastDFSClient.getToken(filepath, fastDFSHttpSecretKey);
            //将url保存到数据库中作为image的值，这里不加token
            if(fileServerAddr.contains("http://")){
                return fileServerAddr+"/"+filepath;
            }else{
                return "http://"+fileServerAddr+"/"+filepath;
            }
        } catch (FastDFSException e) {
            return null;
        }
    }
}

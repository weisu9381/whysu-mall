package top.whysu.front.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.front.service.AddressService;
import top.whysu.manager.mapper.TbAddressMapper;
import top.whysu.manager.pojo.TbAddress;
import top.whysu.manager.pojo.TbAddressExample;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
public class AddressServiceImpl implements AddressService{

    @Autowired
    private TbAddressMapper tbAddressMapper;

    @Override
    public List<TbAddress> getAddressList(Long userId) {
        List<TbAddress> list=new ArrayList<>();
        TbAddressExample example=new TbAddressExample();
        TbAddressExample.Criteria criteria=example.createCriteria();
        criteria.andUserIdEqualTo(userId);
        list=tbAddressMapper.selectByExample(example);
        if(list==null){
            throw new WhysuMallException("获取默认地址列表失败");
        }

        for(int i=0;i<list.size();i++){
            if(list.get(i).getIsDefault()){
                //如果是默认地址的话，换到第一个位置
                Collections.swap(list,0,i);
                break;
            }
        }

        return list;
    }

    @Override
    public TbAddress getAddress(Long addressId) {
        TbAddress tbAddress=tbAddressMapper.selectByPrimaryKey(addressId);
        if(tbAddress==null){
            throw new WhysuMallException("通过id获取地址失败");
        }
        return tbAddress;
    }

    @Override
    public int addAddress(TbAddress tbAddress) {
        //设置唯一默认
        setOneDefault(tbAddress);
        if(tbAddressMapper.insert(tbAddress)!=1){
            throw new WhysuMallException("添加地址失败");
        }
        return 1;
    }

    @Override
    public int updateAddress(TbAddress tbAddress) {
        //设置唯一默认
        setOneDefault(tbAddress);
        if(tbAddressMapper.updateByPrimaryKey(tbAddress)!=1){
            throw new WhysuMallException("更新地址失败");
        }
        return 1;
    }

    @Override
    public int delAddress(TbAddress tbAddress) {
        if(tbAddressMapper.deleteByPrimaryKey(tbAddress.getAddressId())!=1){
            throw new WhysuMallException("删除地址失败");
        }
        return 1;
    }

    private void setOneDefault(TbAddress tbAddress){
        //将该用户的所有地址 的 isDefault都设置为false, 这样使用add添加的时候就能保证最多只有一个默认地址了。
        if(tbAddress.getIsDefault()){
            TbAddressExample example=new TbAddressExample();
            TbAddressExample.Criteria criteria= example.createCriteria();
            criteria.andUserIdEqualTo(tbAddress.getUserId());
            List<TbAddress> list=tbAddressMapper.selectByExample(example);
            for(TbAddress tbAddress1:list){
                tbAddress1.setIsDefault(false);
                tbAddressMapper.updateByPrimaryKey(tbAddress1);
            }
        }
    }
}

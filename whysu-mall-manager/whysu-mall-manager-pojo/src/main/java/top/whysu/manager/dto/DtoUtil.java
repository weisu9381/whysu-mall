package top.whysu.manager.dto;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import top.whysu.common.pojo.ZTreeNode;
import top.whysu.manager.dto.front.Product;
import top.whysu.manager.pojo.TbItem;
import top.whysu.manager.pojo.TbItemCat;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.pojo.TbPanel;

public class DtoUtil {

    private static Logger logger = LoggerFactory.getLogger(DtoUtil.class);

    public static TbMember MemberDto2TbMember(MemberDto memberDto){

        TbMember tbMember =new TbMember();

        if(!memberDto.getUsername().isEmpty()){
            tbMember.setUsername(memberDto.getUsername());
        }
        if(!memberDto.getPassword().isEmpty()){
            tbMember.setPassword(memberDto.getPassword());
        }
        if(!memberDto.getPhone().isEmpty()){
            tbMember.setPhone(memberDto.getPhone());
        }
        if(!memberDto.getEmail().isEmpty()){
            tbMember.setEmail(memberDto.getEmail());
        }
        if(!memberDto.getSex().isEmpty()){
            tbMember.setSex(memberDto.getSex());
        }
        if(!memberDto.getDescription().isEmpty()){
            tbMember.setDescription(memberDto.getDescription());
        }
        if(!memberDto.getProvince().isEmpty()){
            tbMember.setAddress(memberDto.getProvince()+" "
                    +memberDto.getCity()+" "+memberDto.getDistrict());
        }

        return tbMember;
    }

    public static TbItem ItemDto2TbItem(ItemDto itemDto){

        TbItem tbItem =new TbItem();

        tbItem.setTitle(itemDto.getTitle());
        tbItem.setSellPoint(itemDto.getSellPoint());
        tbItem.setPrice(itemDto.getPrice());
        tbItem.setNum(itemDto.getNum());
        if(itemDto.getLimitNum()==null||itemDto.getLimitNum()<0){
            tbItem.setLimitNum(10);
        }else{
            tbItem.setLimitNum(itemDto.getLimitNum());
        }
        tbItem.setImage(itemDto.getImage());
        tbItem.setCid(itemDto.getCid());

        return tbItem;
    }

    public static ItemDto TbItem2ItemDto(TbItem tbItem){

        ItemDto itemDto =new ItemDto();

        itemDto.setTitle(tbItem.getTitle());
        itemDto.setPrice(tbItem.getPrice());
        itemDto.setCid(tbItem.getCid());
        itemDto.setImage(tbItem.getImage());
        itemDto.setSellPoint(tbItem.getSellPoint());
        itemDto.setNum(tbItem.getNum());
        if(tbItem.getLimitNum()==null){
            itemDto.setLimitNum(tbItem.getNum());
        }else if(tbItem.getLimitNum()<0&&tbItem.getNum()<0) {
            itemDto.setLimitNum(10);
        }else{
            itemDto.setLimitNum(tbItem.getLimitNum());
        }

        return itemDto;
    }

    public static ZTreeNode TbItemCat2ZTreeNode(TbItemCat tbItemCat){
        ZTreeNode zTreeNode = new ZTreeNode();
        zTreeNode.setId(Math.toIntExact(tbItemCat.getId()));
        zTreeNode.setpId(Math.toIntExact(tbItemCat.getParentId()));
        zTreeNode.setName(tbItemCat.getName());
        zTreeNode.setIsParent(tbItemCat.getIsParent());
        zTreeNode.setStatus(tbItemCat.getStatus());
        zTreeNode.setSortOrder(tbItemCat.getSortOrder());
        zTreeNode.setRemark(tbItemCat.getRemark());
        return zTreeNode;
    }

    public static ZTreeNode TbPanel2ZTreeNode(TbPanel tbPanel){

        ZTreeNode zTreeNode =new ZTreeNode();

        zTreeNode.setId(tbPanel.getId());
        zTreeNode.setIsParent(false);
        zTreeNode.setpId(0);
        zTreeNode.setName(tbPanel.getName());
        zTreeNode.setSortOrder(tbPanel.getSortOrder());
        zTreeNode.setStatus(tbPanel.getStatus());
        zTreeNode.setRemark(tbPanel.getRemark());
        zTreeNode.setLimitNum(tbPanel.getLimitNum());
        zTreeNode.setType(tbPanel.getType());
        zTreeNode.setPosition(tbPanel.getPosition());

        return zTreeNode;
    }

    public static Product TbItem2Product(TbItem tbItem){

        Product product =new Product();

        product.setProductId(tbItem.getId());
        product.setProductName(tbItem.getTitle());
        product.setSalePrice(tbItem.getPrice());
        product.setSubTitle(tbItem.getSellPoint());
        product.setProductImageBig(tbItem.getImages()[0]);

        return product;
    }
}

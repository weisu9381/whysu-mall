package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;
import top.whysu.manager.dto.MemberDto;
import top.whysu.manager.pojo.TbMember;
import top.whysu.manager.service.MemberService;

@RestController
@Api(description = "会员管理")
public class MemeberController {

    private Logger log = LoggerFactory.getLogger(MemeberController.class);

    @Autowired
    private MemberService memberService;

    @RequestMapping(value = "/member/count",method = RequestMethod.GET)
    @ApiOperation(value = "获得会员总数")
    public DataTablesResult getMemberCount(){
        return memberService.getMemberCount();
    }

    /**
     * 之前的ItemController中分别使用了/item/list表示没有minDate和maxDate的情况(直接从表格输入search来搜索)，
     * /item/listSearch是输入minDate和maxDate然后再输入searchKey，点击“搜索”
     * 这里的 /member/list 将二者融为一体，search和searchKey同时有值的情况按照search来搜索。
     * datatable初始化的时候需要初始化minDate="" maxDate="" searchKey=""
     */
    @RequestMapping(value = "/member/list",method = RequestMethod.GET)
    @ApiOperation(value = "分页多条件搜索获取会员列表")
    public DataTablesResult getMemberList(int draw, int start, int length, String searchKey,
                                          String minDate, String maxDate,
                                          @RequestParam("search[value]") String search,
                                          @RequestParam("order[0][column]") int orderCol,
                                          @RequestParam("order[0][dir]") String orderDir){

        //获取客户端需要排序的列
        String[] cols = {"checkbox","id", "username","sex", "phone", "email", "address", "created", "updated", "state"};
        String orderColumn = cols[orderCol];
        //默认排序列
        if(orderColumn == null) {
            orderColumn = "created";
        }
        //获取排序方式 默认为desc(asc)
        if(orderDir == null) {
            orderDir = "desc";
        }
        if(!search.isEmpty()){
            searchKey=search;
        }
        DataTablesResult result=memberService.getMemberList(draw,start,length,searchKey,minDate,maxDate,orderColumn,orderDir);
        return result;
    }

    @RequestMapping(value = "/member/list/remove",method = RequestMethod.GET)
    @ApiOperation(value = "分页多条件搜索已删除会员列表")
    public DataTablesResult getDelMemberList(int draw, int start, int length, String searchKey,
                                             String minDate, String maxDate,
                                             @RequestParam("search[value]") String search,
                                             @RequestParam("order[0][column]") int orderCol,
                                             @RequestParam("order[0][dir]") String orderDir){

        //获取客户端需要排序的列
        String[] cols = {"checkbox","id", "username","sex", "phone", "email", "address", "created", "state"};
        String orderColumn = cols[orderCol];
        //默认排序列
        if(orderColumn == null) {
            orderColumn = "created";
        }
        //获取排序方式 默认为desc(asc)
        if(orderDir == null) {
            orderDir = "desc";
        }
        if(!search.isEmpty()){
            searchKey=search;
        }
        DataTablesResult result=memberService.getRemoveMemberList(draw,start,length,searchKey,minDate,maxDate,orderColumn,orderDir);
        return result;
    }

    @RequestMapping(value = "/member/count/remove",method = RequestMethod.GET)
    @ApiOperation(value = "获得移除总会员数目")
    public DataTablesResult getRemoveMemberCount(){

        return memberService.getRemoveMemberCount();
    }

    @RequestMapping(value = "/member/add",method = RequestMethod.POST)
    @ApiOperation(value = "添加会员")
    public Result<TbMember> createMember(@ModelAttribute MemberDto memberDto){

        TbMember newTbMember = memberService.addMember(memberDto);
        return new ResultUtil<TbMember>().setData(newTbMember);
    }

    @RequestMapping(value = "/member/stop/{id}",method = RequestMethod.PUT)
    @ApiOperation(value = "停用会员")
    public Result<TbMember> stopMember(@PathVariable Long id){

        TbMember tbMember = memberService.alertMemberState(id,0);
        return new ResultUtil<TbMember>().setData(tbMember);
    }

    @RequestMapping(value = "/member/start/{ids}",method = RequestMethod.PUT)
    @ApiOperation(value = "启用会员")
    public Result<TbMember> startMember(@PathVariable Long[] ids){

        for(Long id:ids){
            memberService.alertMemberState(id,1);
        }
        return new ResultUtil<TbMember>().setData(null);
    }

    @RequestMapping(value = "/member/remove/{ids}",method = RequestMethod.PUT)
    @ApiOperation(value = "移除会员")
    public Result<TbMember> removeMember(@PathVariable Long[] ids){

        for(Long id:ids){
            memberService.alertMemberState(id,2);
        }
        return new ResultUtil<TbMember>().setData(null);
    }

    @RequestMapping(value = "/member/del/{ids}",method = RequestMethod.POST)
    @ApiOperation(value = "彻底删除会员")
    public Result<TbMember> deleteMember(@PathVariable Long[] ids){

        for(Long id:ids){
            memberService.deleteMember(id);
        }
        return new ResultUtil<TbMember>().setData(null);
    }

    @RequestMapping(value = "/member/changePass/{id}",method = RequestMethod.POST)
    @ApiOperation(value = "修改会员密码")
    public Result<TbMember> changeMemberPassword(@PathVariable Long id,@ModelAttribute MemberDto memberDto){

        TbMember tbMember = memberService.changePassMember(id,memberDto);
        return new ResultUtil<TbMember>().setData(tbMember);
    }

    @RequestMapping(value = "/member/update/{id}",method = RequestMethod.POST)
    @ApiOperation(value = "修改会员信息")
    public Result<TbMember> updateMember(@PathVariable Long id,@ModelAttribute MemberDto memberDto){

        TbMember tbMember = memberService.updateMember(id,memberDto);
        return new ResultUtil<TbMember>().setData(tbMember);
    }

    @RequestMapping(value = "/member/{id}",method = RequestMethod.GET)
    @ApiOperation(value = "通过ID获取会员信息")
    public Result<TbMember> getMemberById(@PathVariable Long id){

        TbMember tbMember = memberService.getMemberById(id);
        return new ResultUtil<TbMember>().setData(tbMember);
    }

    @RequestMapping(value = "/member/username",method = RequestMethod.GET)
    @ApiOperation(value = "验证注册名是否存在")
    public Boolean validateUsername(String username){

        if(memberService.getMemberByUsername(username)!=null){
            return false;
        }
        return true;
    }

    @RequestMapping(value = "/member/phone",method = RequestMethod.GET)
    @ApiOperation(value = "验证注册手机是否存在")
    public Boolean validatePhone(String phone){

        if(memberService.getMemberByPhone(phone)!=null){
            return false;
        }
        return true;
    }

    @RequestMapping(value = "/member/email",method = RequestMethod.GET)
    @ApiOperation(value = "验证注册邮箱是否存在")
    public Boolean validateEmail(String email){

        if(memberService.getMemberByEmail(email)!=null){
            return false;
        }
        return true;
    }

    @RequestMapping(value = "/member/edit/{id}/username",method = RequestMethod.GET)
    @ApiOperation(value = "验证编辑用户名是否存在")
    public Boolean validateEditUsername(@PathVariable Long id, String username){
        return memberService.getMemberByEditUsername(id,username);
    }

    @RequestMapping(value = "/member/edit/{id}/phone",method = RequestMethod.GET)
    @ApiOperation(value = "验证编辑手机是否存在")
    public Boolean validateEditPhone(@PathVariable Long id,String phone){
        return memberService.getMemberByEditPhone(id,phone);
    }

    @RequestMapping(value = "/member/edit/{id}/email",method = RequestMethod.GET)
    @ApiOperation(value = "验证编辑邮箱是否存在")
    public Boolean validateEditEmail(@PathVariable Long id,String email){
        return memberService.getMemberByEditEmail(id,email);
    }

}

package top.whysu.manager.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import top.whysu.common.pojo.DataTablesResult;
import top.whysu.manager.service.MemberService;

@RestController
@Api(description = "会员管理")
public class MemeberController {
    @Autowired
    private MemberService memberService;

    @RequestMapping(value = "/member/count",method = RequestMethod.GET)
    @ApiOperation(value = "获得会员总数")
    public DataTablesResult getMemberCount(){
        return memberService.getMemberCount();
    }
}

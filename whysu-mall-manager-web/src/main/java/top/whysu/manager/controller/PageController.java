package top.whysu.manager.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/**
 * 页面跳转
 */
@Controller
public class PageController {

    private Logger log = LoggerFactory.getLogger(PageController.class);

    @RequestMapping("/")
    public String showIndex(HttpServletRequest request){
        /*该判断有问题，例如前一个页面时product-list.jsp,现在已经登录的话，你再刷新一下不是跳转到index.jsp，而是product-list.jsp*/
        //如果是session过期等登录方式的话，跳转到前一个页面。
        /*SavedRequest savedRequest = WebUtils.getSavedRequest(request);
        if(null != savedRequest){
            //savedRequest.getRequestUrl()获取的是 /whysu-mall-manager-web/product-list ,但现在只需要 /product-list
            //获取项目名称
            String contextPath = request.getContextPath();
            //取出项目名称得到的路径
            String redirect = savedRequest.getRequestUrl().substring(contextPath.length());
            //如果前一个页面是"/"的话，那就返回index.jsp页面
            if(Objects.equals(redirect, "/")){
                return "index";
            }
            return "redirect:" + redirect;
        }*/
        return "index";
    }

    @RequestMapping("/{page}")
    public String showPage(@PathVariable String page){return page;}
}

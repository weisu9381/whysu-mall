package top.whysu.manager.shiro;

import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import java.util.HashMap;
import java.util.Map;

public class MyPermissionFilter extends AuthorizationFilter {

    private Logger log = LoggerFactory.getLogger(MyPermissionFilter.class);

    /**
     *
     * @param o  这里是 权限集合 String[] 可以通过 subject.isPermitted(perms[0])或者subject.isPermittedAll(perms)来判断subject用户是否有perms权限
     * @return
     * @throws Exception
     */
    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object o) throws Exception {

        Subject subject = this.getSubject(request, response);
        String[] perms = (String[]) ((String[]) o);
        boolean isPermitted = true;

        if (subject.getPrincipal() == null) {
            if(FilterUtil.isAjax(request)){
                log.info("未登录或登录时间过长,是ajax！");
                Map<String, Object> resultMap = new HashMap<String, Object>();
                resultMap.put("success", false);
                resultMap.put("message", "您还未登录或登录时间过长,请重新登录！");
                FilterUtil.out(response, resultMap);
            }else{
                log.info("未登录或登录时间过长,不是ajax！");
                this.saveRequestAndRedirectToLogin(request, response);
            }
        } else {
            if (perms != null && perms.length > 0) {
                if (perms.length == 1) {
                    //判断subject这个用户是否有perms[0]权限
                    if (!subject.isPermitted(perms[0])) {
                        isPermitted = false;
                    }
                } else if (!subject.isPermittedAll(perms)) {
                    isPermitted = false;
                }
            }
            if (!isPermitted) {
                if (FilterUtil.isAjax(request)) {
                    log.info("没有该权限，并且是Ajax请求");
                    Map<String, Object> resultMap = new HashMap<String, Object>();
                    resultMap.put("success", false);
                    resultMap.put("message", "抱歉，您没有该权限！");
                    FilterUtil.out(response, resultMap);
                } else {
                    return isPermitted;
                }
            }
        }
        return isPermitted;
    }



}

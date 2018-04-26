package top.whysu.manager.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 之前写 ${pageContext.request.contextPath}/user/login
 * 经过该过滤器，可以节省写成:  ${URL}/user/login
 * 当然要把该拦截器注册到 springmvc.xml中
 */
public class SecurityInterceptor implements HandlerInterceptor{
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse httpServletResponse, Object o) throws Exception {
        String baseUrl =request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort() + request.getContextPath();
        request.setAttribute("URL", baseUrl);//网站根目录变量
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}

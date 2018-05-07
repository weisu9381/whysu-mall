package top.whysu.manager.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import top.whysu.common.exception.WhysuMallException;
import top.whysu.common.pojo.Result;
import top.whysu.common.utils.ResultUtil;

import java.net.BindException;

@ControllerAdvice
public class GlobalExceptionHandler {

    private Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 虽然自定义了WhysuMallException extends RuntimeException,并且throw new WhysuMallException('异常信息'):
     * 但是，却被转换为了 RuntimeException, 通过e.getMessage()得到的是一大串错误信息，这对用户体验是不好的，
     * 但我又无法得到WhysuMallException中的getMsg()的信息，
     * 于是这里只能通过截取 RuntimeException的getMessage()了
     * @param e
     * @return
     */
    @ExceptionHandler(value = RuntimeException.class)
    @ResponseStatus(value = HttpStatus.OK)
    @ResponseBody
    public Result<Object> handleException(Exception e) {
        String errorMsg="RuntimeException: ";
        if (e!=null){
            String msg = e.getMessage();
            /*在没有更好的办法之前只能先这样了，但这不是长久之计,毕竟e.getMessage()的值会变化*/
            if(msg.contains("WhysuMallException")) {
                errorMsg = msg.substring(msg.indexOf(":") + 1, msg.indexOf("top", 1));
            }else{
                errorMsg = "内部异常！请联系管理员";
            }
        }
        return new ResultUtil<>().setErrorMsg(errorMsg);
    }

    @ExceptionHandler(value = BindException.class)
    @ResponseStatus(value = HttpStatus.OK)
    @ResponseBody
    public Result<Object> bindExceptionHandler(BindException e){
        String errorMsg="请求数据校验不合法: ";
        if(e!=null){
            errorMsg=e.getMessage();
            log.warn(errorMsg);
        }
        return new ResultUtil<>().setErrorMsg(errorMsg);
    }

    @ExceptionHandler(value = WhysuMallException.class)
    @ResponseStatus(value = HttpStatus.OK)
    @ResponseBody
    public Result<Object> handleWhysuMallException(WhysuMallException e) {
        String errorMsg="WhysuMall exception: ";
        if (e!=null){
            errorMsg=e.getMsg();
        }
        return new ResultUtil<>().setErrorMsg(errorMsg);
    }



}

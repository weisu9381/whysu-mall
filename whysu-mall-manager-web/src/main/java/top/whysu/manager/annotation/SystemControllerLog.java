package top.whysu.manager.annotation;

import java.lang.annotation.*;

/**
 * 自定义注解，系统级别Controller层，拦截Controller
 */
@Target({ElementType.PARAMETER,ElementType.METHOD})//作用于参数或方法之上
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SystemControllerLog {
    String description() default "";
}

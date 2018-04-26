package top.whysu.common.pojo;

import java.io.Serializable;

/**
 * 前后端交互数据标准
 */
public class Result<T> implements Serializable{

    public static final long serialVersionUID = 1L;

    /**
     * 成功标志
     */
    private boolean success;
    /**
     * 失败信息
     */
    private String message;

    /**
     * 返回代码
     */
    private Integer code;

    /**
     * 结果，数据
     */
    private T result;

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }
}

package top.whysu.common.exception;

public class WhysuMallException extends RuntimeException{

    private String msg;

    public WhysuMallException(String msg){
        super(msg);
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}

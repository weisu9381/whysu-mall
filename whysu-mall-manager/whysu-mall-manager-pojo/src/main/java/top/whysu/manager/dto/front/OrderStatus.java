package top.whysu.manager.dto.front;

import java.io.Serializable;

public class OrderStatus implements Serializable{
    private Long orderId;
    private Integer status;

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}

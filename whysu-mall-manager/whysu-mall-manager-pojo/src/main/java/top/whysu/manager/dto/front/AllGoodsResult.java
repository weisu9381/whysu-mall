package top.whysu.manager.dto.front;

import java.io.Serializable;
import java.util.List;

/**
 * 分页条件获取全部商品，返回的数据
 */
public class AllGoodsResult implements Serializable {

    private int total;

    private List<?> data;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<?> getData() {
        return data;
    }

    public void setData(List<?> data) {
        this.data = data;
    }
}

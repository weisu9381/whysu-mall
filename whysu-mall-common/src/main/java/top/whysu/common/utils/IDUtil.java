package top.whysu.common.utils;

import java.util.Random;

public class IDUtil {

    /**随机生成id*/
    public static long getRandomId(){
        long millis =System.currentTimeMillis();
        //加上两位随机数
        Random random = new Random();
        int end2 = random.nextInt(99);
        //不过不是两位补足2位
        String str = millis + String.format("%02d",end2);
        long id = new Long(str);
        return id;
    }
}

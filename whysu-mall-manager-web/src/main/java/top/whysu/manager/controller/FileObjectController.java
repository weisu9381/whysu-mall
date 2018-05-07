package top.whysu.manager.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import top.whysu.common.pojo.KindEditorResult;
import top.whysu.manager.fastdfs.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Locale;

/**
 * 文件接口
 * <p>
 *
 * @author jiangzhou.bo@hand-china.com
 * @version 1.0
 * @name FileObjectController
 * @date 2017-10-15 14:09
 */
@Controller
@RequestMapping("/fastdfs")
public class FileObjectController {

    private Logger log = LoggerFactory.getLogger(FileObjectController.class);
    private FastDFSClient fastDFSClient = new FastDFSClient();

    /**
     * 文件服务器地址
     */
    @Value("${file_server_addr}")
    private String fileServerAddr;

    /**
     * FastDFS秘钥
     */
    @Value("${fastdfs.http_secret_key}")
    private String fastDFSHttpSecretKey;

    @RequestMapping("/test")
    @ResponseBody
    public FileResponseData test(){
        return new FileResponseData(true);
    }

    /**
     * 上传文件通用，只上传文件到服务器，不会保存记录到数据库
     *
     * @param file
     * @param request
     * @return 返回文件路径等信息
     */
    @RequestMapping(value = "/upload/file/sample")
    @ResponseBody
    public FileResponseData uploadFileSample(@RequestParam("file")MultipartFile file, HttpServletRequest request){
        return uploadSample(file, request);
    }

    /**
     * 只能上传图片，只上传文件到服务器，不会保存记录到数据库. <br>
     * 会检查文件格式是否正确，默认只能上传 ['png', 'gif', 'jpeg', 'jpg'] 几种类型.
     *
     * @param file
     * @param request
     * @return 返回文件路径等信息
     */
    @RequestMapping("/upload/image/sample")
    @ResponseBody
    public FileResponseData uploadImageSample(@RequestParam("file") MultipartFile file, HttpServletRequest request){
        // 检查文件类型
        if(!FileCheck.checkImage(file.getOriginalFilename())){
            log.debug("FileObjectController:uploadImageSample: 图片类型错误");
            FileResponseData responseData = new FileResponseData(false);
            responseData.setCode(ErrorCode.FILE_TYPE_ERROR_IMAGE.CODE);
            responseData.setMessage(ErrorCode.FILE_TYPE_ERROR_IMAGE.MESSAGE);
            return responseData;
        }

        return uploadSample(file, request);
    }

    /**
     * 只能上传文档，只上传文件到服务器，不会保存记录到数据库. <br>
     * 会检查文件格式是否正确，默认只能上传 ['pdf', 'ppt', 'xls', 'xlsx', 'pptx', 'doc', 'docx'] 几种类型.
     *
     * @param file
     * @param request
     * @return 返回文件路径等信息
     */
    @RequestMapping("/upload/doc/sample")
    @ResponseBody
    public FileResponseData uploadDocSample(@RequestParam("file") MultipartFile file, HttpServletRequest request){
        // 检查文件类型
        if(!FileCheck.checkDoc(file.getOriginalFilename())){
            FileResponseData responseData = new FileResponseData(false);
            responseData.setCode(ErrorCode.FILE_TYPE_ERROR_DOC.CODE);
            responseData.setMessage(ErrorCode.FILE_TYPE_ERROR_DOC.MESSAGE);
            return responseData;
        }

        return uploadSample(file, request);
    }

    /**
     * 以附件形式下载文件
     *
     * @param filePath 文件地址
     * @param response
     */
    @RequestMapping("/download/file")
    public void downloadFile(String filePath, HttpServletResponse response) throws FastDFSException {
        try {
            fastDFSClient.downloadFile(filePath, response);
        } catch (FastDFSException e) {
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * 获取图片 使用输出流输出字节码，可以使用< img>标签显示图片<br>
     *
     * @param filePath 图片地址
     * @param response
     */
    @RequestMapping("/download/image")
    public void downloadImage(String filePath, HttpServletResponse response) throws FastDFSException {
        try {
            fastDFSClient.downloadFile(filePath, response.getOutputStream());
        } catch (FastDFSException e) {
            e.printStackTrace();
            throw e;
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 根据指定的路径删除服务器文件，适用于没有保存数据库记录的文件
     *
     * @param filePath
     */
    @RequestMapping("/delete/file")
    public FileResponseData deleteFile(String filePath, Locale locale) {
        FileResponseData responseData = new FileResponseData();
        try {
            fastDFSClient.deleteFile(filePath);
        } catch (FastDFSException e) {
            e.printStackTrace();
            responseData.setSuccess(false);
            responseData.setCode(e.getCode());
            responseData.setMessage(e.getMessage());
        }
        return responseData;
    }

    /**
     * 获取访问文件的token
     *
     * @param filePath 文件路径
     * @return
     */
    @RequestMapping("/get/token")
    @ResponseBody
    public FileResponseData getToken(String filePath){
        FileResponseData responseData = new FileResponseData();
        // 设置访文件的Http地址. 有时效性.
        String token = FastDFSClient.getToken(filePath, fastDFSHttpSecretKey);
        responseData.setToken(token);
        responseData.setHttpUrl(fileServerAddr+"/"+filePath+"?"+token);

        return responseData;
    }

    /**
     * KindEditor返回的json格式有要求，所以再写一个
     * @param file
     * @param request
     * @return
     */
    @RequestMapping(value = "/kindEditor/upload/image/sample")
    @ResponseBody
    public KindEditorResult kindeditor(@RequestParam("imgFile") MultipartFile file, HttpServletRequest request){
        KindEditorResult kindEditorResult=new KindEditorResult();
        // 检查文件类型
        if(!FileCheck.checkImage(file.getOriginalFilename())){
            kindEditorResult.setError(1);
            kindEditorResult.setMessage("图片类型错误，上传失败");
            return kindEditorResult;
        }
        try {
            // 上传到服务器
            String filepath = fastDFSClient.uploadFileWithMultipart(file);
            log.debug("kindEditor: filePath="+ filepath+",file.getOriginalFilename()="+file.getOriginalFilename());
            kindEditorResult.setError(0);
            kindEditorResult.setUrl("http://"+fileServerAddr+"/"+filepath);
        } catch (FastDFSException e) {
            kindEditorResult.setError(1);
            kindEditorResult.setMessage("上传错误");
        }
        return kindEditorResult;
    }

    /**
     * 上传通用方法，只上传到服务器，不保存记录到数据库
     *
     * @param file
     * @param request
     * @return
     */
    public FileResponseData uploadSample(MultipartFile file, HttpServletRequest request){
        FileResponseData responseData = new FileResponseData();
        try {
            // 上传到服务器，得到的路径是group1/M00/00/00/wKh9gVronamABhBLAAB_hRwU00A836.jpg
            // file.getOriginalFilename()可以得到图片原名 比如 图片.jpg。你可以将其一快保存到数据库中
            String filepath = fastDFSClient.uploadFileWithMultipart(file);
            log.debug("filePath="+ filepath+",file.getOriginalFilename()="+file.getOriginalFilename());
            responseData.setSuccess(true);
            responseData.setFileName(file.getOriginalFilename());
            responseData.setFilePath(filepath);
            responseData.setFileType(FastDFSClient.getFilenameSuffix(file.getOriginalFilename()));
            // 设置访文件的Http地址. 有时效性.
            String token = FastDFSClient.getToken(filepath, fastDFSHttpSecretKey);
            responseData.setToken(token);
            //将url保存到数据库中,作为image的值，这里不加token
            if(fileServerAddr.contains("http://")){
                responseData.setHttpUrl(fileServerAddr+"/"+filepath);
            }else{
                responseData.setHttpUrl("http://"+fileServerAddr+"/"+filepath);
            }
        } catch (FastDFSException e) {
            responseData.setSuccess(false);
            responseData.setCode(e.getCode());
            responseData.setMessage(e.getMessage());
            log.debug("上传图片错误："+"e.getCode()="+e.getCode()+",e.getMessage()="+e.getMessage());
        }

        return responseData;
    }
}

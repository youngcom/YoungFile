package com.demo.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.demo.service.PackageService;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.InputSource;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class TestController {
    private static Logger log = LoggerFactory.getLogger(TestController.class);

    @Autowired
    PackageService packageService;



    @RequestMapping(value = "/downloadPage", method = RequestMethod.GET)
    public String downloadIpaPage() {
        return "testipa";
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String index(){
        System.out.println("测试----");
        log.error("测试信息输出");
        log.debug("测试debug日志统计");
        return "test";
    }

    @RequestMapping(value = "/getPackageUrl", method = {RequestMethod.POST})
    @ResponseBody
    public Map getPackageUrl(HttpServletRequest request, HttpServletResponse response, @RequestBody JSONObject jsonObject) throws ServletException,IOException{
        Map info = new HashMap();
        Map data = new HashMap();

        String udid = jsonObject.getString("udid");
        String account = jsonObject.getString("account");
        String password = jsonObject.getString("password");
        String appName = jsonObject.getString("appName");
        String bundleId = jsonObject.getString("bundleId");
        String schemes = jsonObject.getString("schemes");
        String downloadUrl = jsonObject.getString("downloadUrl");
//        ftp相关参数
        String ftpAccount = jsonObject.getString("ftpAccount");
        String ftpPwd = jsonObject.getString("ftpPwd");
        String ftpAddress = jsonObject.getString("ftpAddress");
        String ftpPort = jsonObject.getString("ftpPort");

        System.out.println(udid + account + password + appName + bundleId + schemes + downloadUrl );
        log.info("------------"+"请求入口");
        //去动态生成描述文件并打包
        try {
//            excuteCommand(udid,account,password,appName,bundleId,schemes);
            excuteCommand(udid,account,password,appName,bundleId,schemes,downloadUrl,ftpAccount,ftpPwd,ftpAddress,ftpPort);
        }catch (Exception e){
            info.put("code","410");
            info.put("data","");
            info.put("msg","请求失败,签名脚本异常:"+e.getMessage());
            return info;
        }

        //生成plist文件
//        try {
//            String ipaUrl = downloadUrl+"/APPReSign/"+appName+"/"+account+"/"+bundleId+"/"+appName+"_Release.ipa";
//            String plistPath = "/Users/admin/Desktop"+"/APPReSign/"+appName+"/"+account+"/"+bundleId+"/"+appName+"_Release.plist";
//            packageService.createPlist(downloadUrl,appName,bundleId,plistPath);
//        }catch (IOException e){
//            e.printStackTrace();
//            System.out.println(e.getMessage());
//            info.put("code","406");
//            info.put("data","");
//            info.put("msg","生成plist文件失败:"+e.getMessage());
//            return info;
//        }
//        response.setStatus(301); //301之后iOS设备会自动打开safari浏览器
//        response.setHeader("Location", "itms-services://?action=download-manifest&url="+downloadUrl+"/iosTest/"+appName+"/"+account+"/"+udid+"/app.plist");//重定向地址

//        "itms-services://?action=download-manifest&url="

        data.put("downloadUrl",downloadUrl+"/"+appName+"/"+account+"/"+udid+"/app.plist");

        info.put("code","200");
        info.put("data",data);
        info.put("msg","请求成功");
        return info;
    }

    @RequestMapping(value = "/udidTest", method = {RequestMethod.POST})
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("---------------udid test------------");
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        //获取HTTP请求的输入流
        InputStream is = request.getInputStream();
        //已HTTP请求输入流建立一个BufferedReader对象
        BufferedReader br = new BufferedReader(new InputStreamReader(is,"UTF-8"));
        StringBuilder sb = new StringBuilder();

        //读取HTTP请求内容
        String buffer = null;
        while ((buffer = br.readLine()) != null) {
            sb.append(buffer);
        }
        String content = sb.toString().substring(sb.toString().indexOf("<?xml"), sb.toString().indexOf("</plist>")+8);
        System.out.println("udid:"+content);
        //content就是接收到的xml字符串
        //进行xml解析
        String udid="";
        try {
            udid = getDeviceId(content);
        }catch (Exception e){
            System.out.println(e.getMessage());
        }

        //去动态生成描述文件并打包
        try {
            excuteCommand(udid,"tuwenleroy@gmail.com","5jZFReEBDb3UQsw","AVGO","com.avgo.phonelive","iphoneLive","https://download.pan4u.cn","tuwen","tuwen@admin88754321","47.75.254.163","21");
        }catch (Exception e){

        }

        //生成plist文件
//        try {
//            packageService.createPlist("http://10.55.53.5:8686","AVGO","com.avgo.cs","1");
//        }catch (IOException e){
//            e.printStackTrace();
//            System.out.println(e.getMessage());
//        }

        response.setStatus(301); //301之后iOS设备会自动打开safari浏览器
        response.setHeader("Location", "https://www.dtdjnc.com");//重定向地址
    }

    private void excuteCommand(String udid,String account,String password,String appName,String bundleId,String schemes,String downloadUrl,String ftpAccount,String ftpPwd,String ftpAddress,String ftpPort) throws Exception{
        // 用法：Runtime.getRuntime().exec("命令");

//        String shpath="/Users/admin/Desktop/UDID/getProfile.rb";   //程序路径
////
//        String command2 = "ruby"+" "+shpath+" "+udid+" "+account+" "+password+" "+appName+" "+bundleId+" "+schemes+" "+downloadUrl;
        String shpath="/Users/admin/Desktop/againSignature/supersign/againSignature.sh";   //程序路径

        String command2 = "sh"+" "+shpath+" "+account+" "+password+" "+bundleId+" "+udid+" "+appName+" "+appName+"_Release"+" "+downloadUrl+" "+ftpAccount+" "+ftpPwd+" "+ftpAddress;
        ShellExcutor shellExcutor = new ShellExcutor();
        try {
            shellExcutor.service(command2);
        }catch (Exception e){
            throw e;
        }

//        try {
//            Runtime.getRuntime().exec(command2).waitFor();
//        }catch (IOException e){
//            e.printStackTrace();
//        }catch (InterruptedException e) {
//            e.printStackTrace();
//        }

    }

    private String getDeviceId(String xmlStr) throws Exception{
        StringReader read = new StringReader(xmlStr);
        //创建新的输入源SAX 解析器将使用 InputSource 对象来确定如何读取 XML 输入
        InputSource source = new InputSource(read);
        //创建一个新的SAXBuilder
        SAXBuilder saxBuilder = new SAXBuilder();
        String udid = "";
        try {
            //通过输入源构造一个Document
            Document doc = saxBuilder.build(source);
            //取的根元素
            Element root = doc.getRootElement();
            System.out.println(root.getName());
            List<?> node = root.getChildren();
            for (int i = 0;i < node.size();i++){
                Element element=(Element)node.get(i);
                System.out.println(element.getName());
                List<?> subNode = element.getChildren();
                for(int j=0;j<subNode.size();j++){
                    Element subElement=(Element)subNode.get(j);
                    System.out.println(subElement.getName());
                    System.out.println("value："+ subElement.getValue());
                    if (j > 0) {
                        Element udidElement = (Element)subNode.get(j - 1);
                        if (udidElement.getValue().equals("UDID")) {
                            udid = subElement.getValue();
                            break;
                        }
                    }
                }
            }

        }catch (JDOMException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (udid.length() == 0){
            throw new Exception("udid获取失败");
        }
        return udid;
    }
}

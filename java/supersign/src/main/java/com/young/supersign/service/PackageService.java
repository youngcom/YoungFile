package com.young.supersign.service;

import org.jdom2.DocType;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.XMLOutputter;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

@Service
public class PackageService {
    /**
     * @param domainName   服务器地址
     * @param appName  ipa应用名称
     * @param appBundleId      bundleid
     * @param plistPath      plist存储目录
     * @throws IOException
     *
     */
    public void createPlist(String domainName,String appName,String appBundleId,String plistPath) throws IOException {
        //ipa包的路径

        //plist文件存储地址
        String filePath=plistPath;

// 创建文档类型
        DocType docType = new DocType("plist");
        docType.setPublicID("-//Apple//DTD PLIST 1.0//EN");
        docType.setSystemID("http://www.apple.com/DTDs/PropertyList-1.0.dtd");
// 创建根节点 plist
        Element root = new Element("plist");
        root.setAttribute("version", "1.0");
//
        Element rootDict = new Element("dict");
        rootDict.addContent(new Element("key").setText("items"));
        Element rootDictArray = new Element("array");
        Element rootDictArrayDict = new Element("dict");
        rootDictArrayDict.addContent(new Element("key").setText("assets"));


        Element rootDictArrayDictArray = new Element("array");
        Element rootDictArrayDictArrayDict1 = new Element("dict");
        rootDictArrayDictArrayDict1.addContent(new Element("key")
                .setText("kind"));
        rootDictArrayDictArrayDict1.addContent(new Element("string")
                .setText("software-package"));
        rootDictArrayDictArrayDict1.addContent(new Element("key")
                .setText("url"));
        rootDictArrayDictArrayDict1.addContent(new Element("string")
                .setText(domainName));


//        Element rootDictArrayDictArrayDict2 = new Element("dict");
//        rootDictArrayDictArrayDict2.addContent(new Element("key")
//                .setText("kind"));
//        rootDictArrayDictArrayDict2.addContent(new Element("string")
//                .setText("display-image"));
//        rootDictArrayDictArrayDict2.addContent(new Element("key")
//                .setText("needs-shine"));
//        rootDictArrayDictArrayDict2.addContent(new Element("true"));
//        rootDictArrayDictArrayDict2.addContent(new Element("key")
//                .setText("url"));
//        rootDictArrayDictArrayDict2.addContent(new Element("string")
//                .setText(domainName.replace("house", "icon/eims.png")));


        rootDictArrayDictArray.addContent(rootDictArrayDictArrayDict1);
//        rootDictArrayDictArray.addContent(rootDictArrayDictArrayDict2);
        rootDictArrayDict.addContent(rootDictArrayDictArray);
        rootDictArrayDict.addContent(new Element("key").setText("metadata"));


        Element rootDictArrayDictDict = new Element("dict");
        rootDictArrayDictDict.addContent(new Element("key")
                .setText("bundle-identifier"));
        rootDictArrayDictDict.addContent(new Element("string")
                .setText(appBundleId));
        rootDictArrayDictDict.addContent(new Element("key")
                .setText("bundle-version"));
        rootDictArrayDictDict.addContent(new Element("string").setText("1.0"));
        rootDictArrayDictDict.addContent(new Element("key").setText("kind"));
        rootDictArrayDictDict.addContent(new Element("string")
                .setText("software"));
        rootDictArrayDictDict.addContent(new Element("key").setText("title"));
        rootDictArrayDictDict.addContent(new Element("string")
                .setText(appName));
        rootDictArrayDict.addContent(rootDictArrayDictDict);


        rootDictArray.addContent(rootDictArrayDict);
        rootDict.addContent(rootDictArray);
        root.addContent(rootDict);
//根节点添加到文档中;
        Document Doc = new Document(root, docType);
//        Format format = new Format();
        XMLOutputter XMLOut = new XMLOutputter();
// 输出 plist文件；
        try {
            FileOutputStream fos = new FileOutputStream(new File(filePath));
            XMLOut.output(Doc, fos);
        }catch (Exception e){
            throw e;
        }

    }
}

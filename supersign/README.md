# againSignature.sh
超级签名---------------------生成证书+描述文件+重签名+FTP



## (1)使用规则

### 1.本机生成CertificateSigningRequest.certSigningRequest文件放入supersign文件夹下，和脚本同级
### 2.创建产品名文件夹，并把需要签名的ipa包和版本号文件version.txt(用户更新的时候判断是否需要重签名)、app.plist模板(用于下载)放入对应的产品文件夹下
### 3.cd 到againSignature.sh脚本文件目录
### 3.`sh againSignature.sh "appid账号" "appid密码" "bundleId（签名过后的bundleId）" "udid" "产品名" ” “ipa名” ”域名“ "ftpAccount" "ftpPwd" "ftpAdress"`

### 例: 
`sh /Users/admin/Desktop/supersign/supersign/againSignature.sh "appid" "pwd" "com.avgo.cs" "0cd3bc82f25666805bca16fb1658a0de0c042eee" "test" "avgo" "http://www.baidu.com" "ftpAccount" "ftpPwd" "ftpAdress"` 

### 4.产品文件路径规则
产品名文件夹->账号文件夹->udid文件夹->ipa文件
### 5.成功重签名ipa文件过后上传ftp


## (2)签名策略

### 1.首先判断是否需要更新描述文件
#### 需要：请求描述文件更新->重签名>导出api在udid文件夹下->判断appid文件夹下是否有公共的ipa文件，没有则copy一个
#### 不需要:根据ipa名判断本地是否有重签名过的文件
#### 如果对应的udid文件夹有ipa名的文件，则直接返回，没有则判断appid下是否有公共的ipa文件，有则直接返回，无：  重签名>导出api在udid文件夹下->判断appid文件夹下是否有公共的ipa文件，没有则copy一个

## (3)文件夹图片示例:
![avatar](/D414F957-B396-4E3C-87C5-F7FCE0523BCE.png)
![avatar](/649F23A0-49FD-426B-AD86-B87B0B29D4A9.png)

## (4)环境配置:
### 1.安装fastlane 官网地址：https://docs.fastlane.tools/getting-started/ios/setup/
### 2.安装FTP命令
```
	brew install telnet 
	brew install inetutils 
	brew link --overwrite inetutils
```
	

product="$1"
appid="$2"
udid="$3"
ipaName="$4"
ipaFile="$5"
#ftp存放根目录
ftpRoot="$6"
ftpAccount="$7"
ftpPwd="$8"
ftpAdress="$9"

#本地路径开头
ipaStartPath=${ipaFile%$product/$appid/*}
echo "ipaStartPath:"
echo "$ipaStartPath"
#ftp ipa路径
ftpIpaPath=${ipaFile#$ipaStartPath}
echo "ftpIpaPath:"
echo "$ftpIpaPath"
#ftp ipa目录
ftpIpaDir=${ftpIpaPath%/*}
echo "ftpIpaDir:"
echo "$ftpIpaDir"
#本地ipa目录
ipaDir=${ipaFile%/*}
echo "ipaDir"
echo "$ipaDir"
cd $ipaDir
#ipa名
ipaName=${ipaFile##*/}


ftplogFile="$ipaDir""/""$ipaName""_ftp.log"

function ftpUpload()
{

echo $(date +"=======================ftp开始上传时间：%Y-%m-%d %T")
echo "$ftpAdress $ftpAccount $ftpPwd"

ftp -v -n $ftpAdress << EOF
user $ftpAccount $ftpPwd
binary
#hash

cd $ftpRoot
#创建product文件夹
mkdir $product
#创建appid文件夹
mkdir "$product/$appid"
#创建udid文件夹
mkdir "$product/$appid/$udid"
cd $ftpIpaDir

prompt  #取消交互
put $ipaName
put app.plist

close
bye
EOF

echo $(date +"=======================ftp结束上传时间：%Y-%m-%d %T")

}

if grep -q "Transfer complete" "$ftplogFile";then
    echo "--------------------FTP上的文件路径---------------------"
    echo "$ftpRoot""$ftpIpaDir""/""$ipaName"
else
    ftpUpload > "$ftplogFile"
    if grep -q "Transfer complete" "$ftplogFile";then
        echo "--------------------FTP上的文件路径---------------------"
        echo "$ftpRoot""$ftpIpaDir""/""$ipaName"
    else
        echo "supersignErrorLog:FTP上传失败,详情见log文件"
        exit 1
    fi
fi





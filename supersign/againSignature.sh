currTime=$(date +"开始时间：%Y-%m-%d %T")
echo $currTime

appid="$1"
pwd="$2"
#用于重签名budleId
signBundleId="$3"
#描述文件的budleId
proBundleId="com.*"
udid="$4"
product="$5"
ipaName="$6"
downloadUrl="$7"
ftpAccount="$8"
ftpPwd="$9"
ftpAdress="${10}"
isUpdateProfile=true

debug=0

ftpRoot="/"


#export PATH=$PATH:/Library/Ruby/Gems/2.3.0/gems/fastlane-2.128.0/bin
#export HOME=/Users/admin
#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8
#export TERM=xterm-256color
#export PATH=$PATH:/usr/local/bin
#export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate
#进入当前目录 因为fastlane必须在当前目录执行

#脚本目录
basedir=`cd $(dirname $0); pwd -P`
cd "$basedir"
#上级目录
topDir=${basedir%/*}

outputFile="$topDir/$product/$appid"

#判断产品文件夹是否存在
if ! ([ -d "$topDir/$product" ])
then
    echo "supersignErrorLog:$product""文件夹不存在"
    exit 1
#mkdir  "./$product"
fi

#ipa文件
ipaFile="$topDir/$product/$ipaName.ipa"
if [ ! -f $ipaFile ]
then
    echo "supersignErrorLog:$product""文件夹下不存在""$ipaName.ipa"
    exit 1
fi

version=""
while read line
do
version=$line
done < "$topDir/$product/version.txt"
echo "版本号----------------$version"
#输出的ipaName
ipaName="$ipaName""_""$version"

#判断是否已有签名文件 优先判断是否注册过设备
ipaPath=""
function signFileCheck()
{
    if ([ -d "$outputFile/$udid" ])
    then
        #注册过设备 判断是否有重签名过文件
        isUpdateProfile=false
        if [ -f "$outputFile/$udid/$ipaName.ipa" ]
        then
            ipaPath="$outputFile/$udid/$ipaName.ipa"
        else
            #判断是否存在公共的重签名文件
            if [ -f "$outputFile/$ipaName.ipa" ]
            then
                ipaPath="$outputFile/$ipaName.ipa"
            fi
        fi
    fi
}

#判断产品下账号文件夹是否存在 不存在就创建
if ! ([ -d "$topDir/$product/$appid" ])
then
    mkdir  "$topDir/$product/$appid"
else
    signFileCheck
    echo "$ipaPath"
    if [[ "$ipaPath" == *.ipa ]]
    then
        echo "本地存在ipa文件，判断是否上传ftp"
        sh ftpUpload.sh $product $appid $udid $ipaName $ipaPath $ftpRoot $ftpAccount $ftpPwd $ftpAdress
        if [ $? -ne 0 ]; then
            echo "supersignErrorLog:上传FTP错误"
            exit 1
        else
            exit 0
        fi
    fi
fi

ruby againSignature.rb $appid $pwd $udid $proBundleId $outputFile $ipaFile $isUpdateProfile $ipaName
if [ $? -ne 0 ]; then
    echo "supersignErrorLog:获取证书或者描述文件出错"
    exit 1
fi
certName=""

while read line || [[ -n ${line} ]]
do
certName=$line
done < "$outputFile/$appid.txt"
echo "certName----------$certName"
profilePath="$outputFile/adhoc_$proBundleId.mobileprovision"

echo $(date +"=======================开始签名时间：%Y-%m-%d %T")
sh GQResign.sh "$certName" "$profilePath" "$outputFile" "$ipaFile" "$ipaName" "$udid" "$product" "$downloadUrl" "$appid" "$ftpRoot" "$ftpAccount" "$ftpPwd" "$ftpAdress" "$signBundleId"

if [ $? -ne 0 ]; then
    echo "supersignErrorLog:签名或者上传FTP错误"
    exit 1
fi

#sudo sh GQResign.sh "iPhone Distribution: Young Y (J4677U8AMU)" "./Certificates/adhoc_com.avgo.cs.mobileprovision"


#sudo sh /Users/admin/Desktop/againSignature/againSignature.sh cwqgi80@163.com Leolee120925 com.spacon.cs 0cd3bc82f25666805bca16fb1658a0de0c042eee AVGO avgo_1.0
currTime=$(date +"结束时间：%Y-%m-%d %T")
echo $currTime


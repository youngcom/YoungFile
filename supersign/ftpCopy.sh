
product="$1"
appid="$2"
udid="$3"
ipaName="$4"

ipaPath="不存在对应的ipa文件，需要重签名上传"

ftp -v -n 47.75.254.163 << EOF
user tuwen tuwen@admin88754321
binary
#cd /iosTest
ls "/iosTest/$product/$appid/$udid/$ipaName.ipa" >
##判断产品文件夹是否存在
#if ([ -d "./$product" ])
#then
#    #判断是否已有签名文件 优先判断是否注册过设备
#    if ([ -d "./$product/$appid/$udid" ])
#    then
#        #注册过设备 判断是否有重签名过文件
#        if [ -f "./$product/$appid/$udid/$ipaName.ipa" ]
#        then
#            ipaPath="/$product/$appid/$udid/$ipaName.ipa"
#        else
#            #判断是否存在公共的重签名文件
#            if [ -f "./$product/$appid/$ipaName.ipa" ]
#            then
#                ipaPath="/$product/$appid/$ipaName.ipa"
#            fi
#        fi
#    fi
#fi

prompt  #取消交互
close
bye
EOF

echo "ipaPath:$ipaPath"
echo "/iosTest/$product/$appid/$udid/$ipaName.ipa"

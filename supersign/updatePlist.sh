#bin/bsah - l

export LANG=en_US.UTF-8

export LANGUAGE=en_US.UTF-8

export LC_ALL=en_US.UTF-8

#分别传四个参数
#plist所在路径
plistPath=$1
#ipa下载地址
downloadUrl=$2
#项目名
productName=$3
#bundleid
bundleId=$4

echo "----传入的四个参数分别是：${plistPath} ${downloadUrl} ${productName} ${bundleId}"

plistBuddy="/usr/libexec/PlistBuddy"


#修改ipa下载地址
$plistBuddy -c "Set :items:0:assets:0:url ""${downloadUrl}" "${plistPath}"
#修改app名
$plistBuddy -c "Set :items:0:metadata:CFBundleDisplayName ""${productName}" "${plistPath}"
$plistBuddy -c "Set :items:0:metadata:title ""${productName}" "${plistPath}"
#修改bundle id
$plistBuddy -c "Set :items:0:metadata:bundle-identifier ""${bundleId}" "${plistPath}"

echo "------plist修改完成---------"

require "spaceship"
#require "pathname"

APPID = ARGV[0]
PWD = ARGV[1]
UDID = ARGV[2]
BUNDLEID = ARGV[3]
OUTPUTFILE = ARGV[4]
IPAFILE = ARGV[5]
#是否更新描述文件
isUpdateProfile = ARGV[6]

ipaName = ARGV[7]

$certName = ""
$profilePath = ""

def updateProfile
    puts "login-account"
    #登录
    Spaceship.login(APPID, PWD)
    #获取证书
    if Spaceship.certificate.production.all.count == 0
        #创建证书
        #    csr, pkey = Spaceship::Portal.certificate.create_certificate_signing_request
        #    puts csr
        #    puts pkey
        csr=""
        flag = FileTest::exists?("./CertificateSigningRequest.certSigningRequest")
        if !flag
            puts "请先创建一个CertificateSigningRequest.certSigningRequest文件,并放入该目录下"
            exit
        end
        File.open("./CertificateSigningRequest.certSigningRequest","r").each_line do |line|
            csr += line
        end
        puts csr
        Spaceship::Portal.certificate.production.create!(csr: csr)
    end
    cert = Spaceship.certificate.production.all.first
    $certName = "iPhone Distribution: #{cert.owner_name} (#{cert.owner_id})"
    #判断本地是否有证书
    cerPath = "#{OUTPUTFILE}/#{APPID}.cer"
    flag = FileTest::exists?(cerPath)
    if !flag
        #本地没有证书下载并安装 保存证书名
        File.write("#{OUTPUTFILE}/#{APPID}.txt", $certName)
        File.write(cerPath, cert.download)
        #    shell = "fastlane run import_certificate certificate_path:\"#{cerPath}\" keychain_path:\"/Users/admin/Library/Keychains/login.keychain-db\""
        shell = "security import #{cerPath} -k ~/Library/Keychains/login.keychain-db -T /usr/bin/codesign"
        puts "安装证书"
        puts shell
        system shell
    end
    
    #添加udid
    #devices = Spaceship::Portal.device.all
    #devices.each do |udid|
    #    puts "新增设备#{udid}"
    #    Spaceship::Portal.device.create!(name: "test", udid: udid)
    #end
    Spaceship::Portal.device.create!(name: "test", udid: UDID)
    #判断bundleId是否存在
    app = Spaceship::Portal.app.find(BUNDLEID)
    unless app
        #创建
        app = Spaceship::Portal.app.create!(bundle_id: BUNDLEID, name: "App")
        puts "app不存在创建"
    end
    #判断描述文件是否存在
    profile = Spaceship::Portal.provisioning_profile.ad_hoc.find_by_bundle_id(bundle_id: BUNDLEID).first
    if profile
        profile.devices = Spaceship::Portal.device.all
        profile.update!
        #更新描述文件 这里需要重新获取描述文件
        profile = Spaceship::Portal.provisioning_profile.ad_hoc.find_by_bundle_id(bundle_id: BUNDLEID).first
        puts "描述文件存在，更新设备"
        else
        profile = Spaceship::Portal.provisioning_profile.ad_hoc.create!(bundle_id: BUNDLEID,certificate: cert,name: "adhoc_#{BUNDLEID}")
        puts "描述文件不存在，创建描述文件"
    end
    $profilePath = "#{OUTPUTFILE}/adhoc_#{BUNDLEID}.mobileprovision"
    File.write($profilePath, profile.download)
end

if isUpdateProfile == "true"
    updateProfile()
#    else
#    File.open("#{OUTPUTFILE}/#{APPID}.txt","r").each_line do |line|
#        $certName += line
#    end
#    $profilePath = "#{OUTPUTFILE}/adhoc_#{BUNDLEID}.mobileprovision"
end

#shell脚本实现重签名
#shell = "sudo sh GQResign.sh \"#{$certName}\" \"#{$profilePath}\" \"#{OUTPUTFILE}/#{UDID}\" \"#{IPAFILE}\" \"#{ipaName}\""
#system "su root"
#puts shell
#
#exec shell


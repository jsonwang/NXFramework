#
# Be sure to run `pod lib lint NXFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NXFramework' # 库的名称
  s.version          = '0.0.1'   # 库的版本
  s.summary          = '公用组件' #简介

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jsonwang/NXFramework.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ak' => '287971051@qq.com.com' }
  # s.source           = { :git => 'https://github.com/jsonwang/NXFramework.git', :tag => s.version.to_s } #指定 TAG 的写法
  s.source           = { :git => 'https://github.com/jsonwang/NXFramework.git' }
   #组件github/svn地址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'
  s.requires_arc = true
# s.source_files = 'NXFramework/Classes/**/*.{h,m,swift,mm}','NXFramework/Classes/NXAdapted/NXAdaptedDevice/*.{h,m,swift,mm}'
 s.source_files = 'NXFramework/Classes/NXFramework.h'


  s.resource_bundles = {
    'NXFramework' => ['NXFramework/Assets/*.*']
  }
  # 类似于pch,文件,多个用逗号隔开
  s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # 指定头文件 暴露的头文件中, 引入都的头文件也必须是 public的
  s.public_header_files = 'NXFramework/Classes/NXFramework.h'
  #声明了库所依赖的系统核心库
  s.frameworks = 'UIKit'
  
  # s.vendored_libraries
  # 依赖的第三方库

  #required 图片缓存
  s.dependency 'SDWebImage', '~> 4.1.2'
  #s.dependency 'SDWebImage/WebP', '~> 4.1.2'
 
  #optional 建议使用的库
  #下载刷新组件
  # pod 'MJRefresh', '~> 3.1.12'
  #精准 iOS 内存泄露检测工具
  #pod 'MLeaksFinder', '~> 1.0.0'
  #lodingUI kit
  # pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'

  # s.subspec 'AdaptedDevice' do |ss|
  #   ss.source_files = 'NXFramework/Classes/NXAdapted/NXAdaptedDevice/**/*.{h,m}'
  #   ss.public_header_files = 'NXFramework/Classes/NXAdapted/NXAdaptedDevice/**/*.{h}'
  #   ss.frameworks = 'AdaptedDevice'
  # end
  
  s.subspec 'Base' do |ss|
      ss.source_files = 'NXFramework/Classes/NXObject.{h,m}'
      ss.public_header_files = 'NXFramework/Classes/NXObject.h'
  end
  s.subspec 'NXMacro' do |ss|
      ss.source_files = 'NXFramework/Classes/NXMacro/**/*.{h,m}'
      ss.public_header_files = 'NXFramework/Classes/NXMacro/**/*.h'
  end
  
  s.subspec 'NXDBManager' do |ss|
      ss.libraries = 'sqlite3','z'#libz.tdb
      ss.dependency 'FMDB', '~> 2.7.2'
       #required YYKIT
      ss.dependency  'YYKit', '0.9.11'
      
      ss.source_files = 'NXFramework/Classes/NXDBManager/*.{h,m}'
      ss.public_header_files = 'NXFramework/Classes/NXDBManager/*.h'
  end
  
  s.subspec 'NXNetworkManager' do |ss|
      
      # ss1.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'
      ss.source_files = 'NXFramework/Classes/NXNetworkManager/*.{h,m}'
      ss.public_header_files = 'NXFramework/Classes/NXNetworkManager/*.h'
      
      #required 网络库 同看 https://github.com/shaioz/AFNetworking-AutoRetry
      ss.dependency 'AFNetworking', '~> 3.1.0'
  end
  
   s.subspec 'NXFoundation' do |ss|
     ss.source_files = 'NXFramework/Classes/NXFoundation/*.{h,m}'
     ss.public_header_files = 'NXFramework/Classes/NXFoundation/*.h'
  end
   s.subspec 'NXPhotoLibrary' do |ss|
       ss.ios.frameworks = 'Photos'
       ss.dependency 'NXFramework/NXMacro'
      
      
       #重新划分 NXPhotoLibrary 的功能模块
       ss.subspec 'NXPhotoCategory' do |sss|
           sss.source_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoCategory/*.{h,m}'
           sss.public_header_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoCategory/*.h'
       end
       ss.subspec 'NXPhotoServiece' do |sss|
           
           sss.dependency  'NXFramework/NXPhotoLibrary/NXPhotoCategory'
            
           sss.source_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoServiece/*.{h,m}'
           sss.public_header_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoServiece/*.h'
       end
       ss.subspec 'NXPhotoImagePicker' do |sss|
           sss.dependency  'SVProgressHUD'
           sss.dependency  'NXFramework/NXPhotoLibrary/NXPhotoServiece'
           
           sss.source_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoImagePicker/*.{h,m}'
           sss.public_header_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoImagePicker/*.h'
       end
       ss.subspec 'NXPhotoUtility' do |sss|
           
           sss.dependency 'NXFramework/NXUtility/NXCommond'
           sss.dependency  'NXFramework/NXPhotoLibrary/NXPhotoImagePicker'
           
           sss.source_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoUtility/*.{h,m}'
           sss.public_header_files = 'NXFramework/Classes/NXPhotoLibrary/NXPhotoUtility/*.h'
       end
   end
   
   s.subspec 'NXUtility' do |ss|
       #required UI自适应
       ss.dependency 'SDAutoLayout', '~> 2.2.0'
       #required 切面编程库
       ss.dependency 'Aspects' , '~> 1.4.1'
       
       ss.subspec 'NXAdapted' do |sss|
           sss.source_files = 'NXFramework/Classes/NXAdapted/**/*.{h,m}'
           sss.public_header_files = 'NXFramework/Classes/NXAdapted/**/*.h'
           sss.dependency 'NXFramework/NXMacro'
       end
       
       ss.subspec 'NXCommond' do |sss|
           sss.source_files ='NXFramework/Classes/NXUtility/**/*.{h,m}', 'NXFramework/Classes/NXCategory/**/*.{h,m}','NXFramework/Classes/NXCustomViews/**/*.{h,m}'
           sss.public_header_files ='NXFramework/Classes/NXUtility/**/*.h', 'NXFramework/Classes/NXCategory/**/*.h','NXFramework/Classes/NXCustomViews/**/*.h'
           sss.dependency  'NXFramework/NXMacro'
           sss.dependency  'NXFramework/Base'
           sss.dependency  'NXFramework/NXUtility/NXAdapted'
       end
       
   end
   
   s.subspec 'NXBusiness' do |ss|
       ss.source_files = 'NXFramework/Classes/NXBusiness/**/*.{h,m}'
       ss.public_header_files = 'NXFramework/Classes/NXBusiness/**/*.h'
       
       ss.dependency 'NXFramework/NXMacro'
       ss.dependency 'NXFramework/NXUtility'
       ss.dependency 'NXFramework/Base'
       ss.dependency 'NXFramework/NXUtility/NXAdapted'
       
   end
   s.subspec 'NXDebug' do |ss|
       ss.source_files = 'NXFramework/Classes/NXDebug/**/*.{h,m}'
       ss.public_header_files = 'NXFramework/Classes/NXDebug/**/*.h'
       ss.dependency  'NXFramework/NXMacro'
       ss.dependency  'NXFramework/NXUtility/NXCommond'
   end
end

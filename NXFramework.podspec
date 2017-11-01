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

  s.source_files = 'NXFramework/Classes/**/*.{h,m,swift,mm}','NXFramework/Classes/NXAdapted/NXAdaptedDevice/*.{h,m,swift,mm}'
# s.source_files = 'NXFramework/Classes//{Configuration,Core,Custo


  # s.resource_bundles = {
  #   'NXFramework' => ['NXFramework/Assets/*.png']
  # }
  # 类似于pch,文件,多个用逗号隔开
  s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
  # 指定头文件 暴露的头文件中, 引入都的头文件也必须是 public的
  s.public_header_files = 'NXFramework/Classes/**/*.h'
  #声明了库所依赖的系统核心库
  s.frameworks = 'UIKit'
  s.libraries = 'sqlite3','z'#libz.tdb
  # s.vendored_libraries
  # 依赖的第三方库
  #required 网络库 同看 https://github.com/shaioz/AFNetworking-AutoRetry
  s.dependency 'AFNetworking', '~> 3.1.0'
  #required 图片缓存
  s.dependency 'SDWebImage', '~> 4.1.2'
  s.dependency 'SDWebImage/WebP', '~> 4.1.2'
  #required 数据库
  s.dependency 'FMDB', '~> 2.7.2'
  #required UI自适应
  s.dependency 'SDAutoLayout', '~> 2.2.0'
  #required 切面编程库
  s.dependency 'Aspects' , '~> 1.4.1'

  #optional 建议使用的库
  #下载刷新组件
  # pod 'MJRefresh', '~> 3.1.12'
  #精准 iOS 内存泄露检测工具
  # pod 'MLeaksFinder', '~> 1.0.0'
  #lodingUI kit
  # pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'

  # s.subspec 'AdaptedDevice' do |ss|
  #   ss.source_files = 'NXFramework/Classes/NXAdapted/NXAdaptedDevice/**/*.{h,m}'
  #   ss.public_header_files = 'NXFramework/Classes/NXAdapted/NXAdaptedDevice/**/*.{h}'
  #   ss.frameworks = 'AdaptedDevice'
  # end

end

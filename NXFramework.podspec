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
  s.source           = { :git => 'https://github.com/jsonwang/NXFramework.git', :tag => s.version.to_s } #组件github/svn地址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'NXFramework/Classes/**/*'

  # s.resource_bundles = {
  #   'NXFramework' => ['NXFramework/Assets/*.png']
  # }

# 指定头文件
  s.public_header_files = 'NXFramework/Classes/NXFramework.h'
  s.frameworks = 'UIKit' #声明了库所依赖的系统核心库
  s.libraries = 'sqlite3','z'#libz.tdb
  # s.vendored_libraries
  s.dependency 'AFNetworking', '~> 3.0.1' #依赖的第三方库
  s.dependency 'SDWebImage', '~> 4.1.0'  #必要
  s.dependency 'FMDB', '~> 2.7.2' #必要 === 数据库
  s.dependency 'SDAutoLayout', '~> 2.2.0'
  s.dependency 'Aspects' , '~> 1.4.1'

end

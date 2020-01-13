Pod::Spec.new do |s|
  s.name         = "KJWorkbox"
  s.version      = "1.0.3"
  s.summary      = "77 toolbox"
  s.homepage     = "https://github.com/yangKJ/KJWorkboxDemo"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.license      = "Copyright (c) 2020 yangkejun"
  s.author       = { "77" => "393103982@qq.com" }
  s.platform     = :ios,"10.0"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/yangKJ/KJWorkboxDemo.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://www.jianshu.com/u/c84c00476ab6'
  s.requires_arc = true
  
  s.default_subspec  = 'Box' # 默认引入的文件
  s.ios.source_files = 'KJWorkboxDemo/Workbox/KJWorkboxHeader.h' # 添加头文件

  s.subspec 'Box' do |y|
    y.source_files = "KJWorkboxDemo/Workbox/Box/**/*.{h,m}" # 添加文件
    y.public_header_files = "KJWorkboxDemo/Workbox/Box/**/*.h" # 添加头文件
    y.frameworks = 'Foundation','UIKit'
  end
  
  s.subspec 'CommonBox' do |fun|
    fun.source_files = "KJWorkboxDemo/Workbox/CommonBox/**/*.{h,m}" # 添加文件
    fun.public_header_files = "KJWorkboxDemo/Workbox/CommonBox/**/*.h" # 添加头文件
    fun.dependency 'KJWorkbox/Box'
  end
  
end



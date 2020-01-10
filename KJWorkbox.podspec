Pod::Spec.new do |s|
  s.name         = "KJWorkbox"
  s.version      = "1.0.0"
  s.summary      = "Some iOS Emitter"
  s.homepage     = "https://github.com/yangKJ/KJWorkboxDemo"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.license      = "Copyright (c) 2020 yangkejun"
  s.author       = { "77" => "393103982@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/yangKJ/KJWorkboxDemo.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://www.jianshu.com/u/c84c00476ab6'
  s.requires_arc = true
  
  s.default_subspec = 'Workbox' # 默认引入的文件
  s.ios.source_files = 'KJWorkboxDemo/Workbox/KJWorkboxHeader.h' # 添加头文件

  s.subspec 'Workbox' do |y|
    y.source_files = "KJWorkboxDemo/Workbox/**/*.{h,m}" # 添加文件
    y.public_header_files = "KJWorkboxDemo/Workbox/**/*.h" # 添加头文件
    y.frameworks = 'Foundation','UIKit'
  end
  
end



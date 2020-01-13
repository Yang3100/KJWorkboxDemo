# KJWorkbox
![coverImage](https://upload-images.jianshu.io/upload_images/1933747-b7e843a01999b9a9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 本库提供各种工具：
* 本地消息推送工具、APNs推送工具
* 自带缓存机制网络图片下载工具
* 快速识别网页当中的图片
* 跳转处理工具

----------------------------------------
### 框架整体介绍
* [作者信息](#作者信息)
* [作者其他库](#作者其他库)
* [Cocoapods安装](#Cocoapods安装)
* [更新日志](#更新日志)
* [打赏作者 &radic;](#打赏作者)

----------------------------------------

#### <a id="作者信息"></a>作者信息
> Github地址：https://github.com/yangKJ  
> 简书地址：https://www.jianshu.com/u/c84c00476ab6  
> 博客地址：https://blog.csdn.net/qq_34534179  


#### <a id="作者其他库"></a>作者其他Pod库
```
工具集合
- 粒子效果、Button图文混排、点击事件封装、扩大点击域、点赞粒子效果，
- 手势封装、圆角渐变、Xib属性、TextView输入框扩展、限制字数、识别网址超链接，
- Image图片加工处理、滤镜渲染、泛洪算法等等
pod 'KJEmitterView'
pod 'KJEmitterView/Function'#
pod 'KJEmitterView/Control' # 自定义控件

播放器 - KJPlayer是一款视频播放器，AVPlayer的封装，继承UIView
- 视频可以边下边播，把播放器播放过的数据流缓存到本地，下次直接从缓冲读取播放
pod 'KJPlayer'  # 播放器功能区
pod 'KJPlayer/KJPlayerView'  # 自带展示界面

轮播图 - 支持缩放 多种pagecontrol 支持继承自定义样式 自带网络加载和缓存
pod 'KJBannerView'  # 轮播图，网络图片加载 支持网络GIF和网络图片和本地图片混合轮播

加载Loading - 多种样式供选择 HUD控件封装
pod 'KJLoadingAnimation' # 加载控件

菜单控件 - 下拉控件 选择控件
pod 'KJMenuView' # 菜单控件
```

##### Issue
如果您在使用中有好的需求及建议，或者遇到什么bug，欢迎随时issue，我会及时的回复，有空也会不断优化更新这些库

#### <a id="Cocoapods安装"></a>Cocoapods安装
```
pod 'KJWorkbox' # 系统工具
pod 'KJWorkbox/CommonBox' # 常用工具
```

#### <a id="更新日志"></a>更新日志
```
####版本更新日志:
#### Add 1.0.2
1、重新分类工具项目，Box存放系统工具，CommonBox存放常用工具
2、默认pod系统工具

#### Add 1.0.1
1、取出KJNotificationManager当中的AppDelegate扩展
2、修改KJWebDiscernTool当中的WKNavigationDelegate协议实现与否

#### Add 1.0.0
1、KJNotificationManager 本地推送工具
2、KJLoadImageTool 网络图片下载工具
3、KJJumpControllerTool 跳转控制器工具
4、KJWebDiscernTool 识别网页图片工具

```

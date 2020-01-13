//
//  KJWorkboxHeader.h
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/9.
//  Copyright © 2020 杨科军. All rights reserved.
/*------------ 作者其余库，欢迎大家使用 ------------
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
 
 > Github地址：https://github.com/yangKJ
 > 简书地址：https://www.jianshu.com/u/c84c00476ab6
 > 博客地址：https://blog.csdn.net/qq_34534179

 ####版本更新日志:
 #### Add 1.0.3
 1、引入__has_include宏，处理AppDelegate分类问题
 
 #### Add 1.0.2
 1、重新分类工具项目，Box存放系统工具，CommonBox存放常用工具
 2、默认pod系统工具
 
 #### Add 1.0.0
 1、KJNotificationManager 本地推送工具
 2、KJLoadImageTool 网络图片下载工具
 3、KJJumpControllerTool 跳转控制器工具
 4、KJWebDiscernTool 识别网页图片工具

 */

#ifndef KJWorkboxHeader_h
#define KJWorkboxHeader_h

/// 系统相关工具
#import "KJNotificationManager.h" // 推送工具

/// 常用工具 - 以下工具需要 pod 'KJWorkbox/CommonBox'
#if __has_include(<KJWorkbox/KJLoadImageTool.h>)
#import "KJLoadImageTool.h" // 网络图片下载工具
#import "KJJumpControllerTool.h" // 跳转控制器工具
#import "KJWebDiscernTool.h" // 识别网页图片工具
#else
// 不包含相关文件
#endif

#endif /* KJWorkboxHeader_h */

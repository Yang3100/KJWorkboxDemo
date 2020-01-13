//
//  KJNotificationManager.h
//  KJNotificationDemo
//
//  Created by 杨科军 on 2020/1/7.
//  Copyright © 2020 杨科军. All rights reserved.
//  推送工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
//#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 推送的几种类型
typedef NS_ENUM(NSInteger, KJLocalityNotificationType) {
    KJLocalityNotificationTypeCustom, /// 默认推送类型
    KJLocalityNotificationTypeImage, /// 图像推送
    KJLocalityNotificationTypeVideo, /// 视频推送
    KJLocalityNotificationTypeTiming, /// 定时推送
    KJLocalityNotificationTypePlace, /// 指定位置推送
};
/// 推送方式
typedef NS_ENUM(NSInteger, KJNotificationType) {
    KJNotificationTypeAPNs, /// 远程服务器推送
    KJNotificationTypeLocality, /// 本地推送
};
/// 收到推送消息
typedef NS_ENUM(NSInteger, KJReceiveNotificationType) {
    KJReceiveNotificationTypeWillPresent, /// 前台收到推送
    KJReceiveNotificationTypeDidReceive, /// 应用在后台收到推送
    KJReceiveNotificationTypeOpenSettings, /// 从通知界面直接进入应用
};
typedef void(^kNotificationCompletion)(KJReceiveNotificationType receiveType,KJNotificationType type,UNNotification *notification);
@interface KJNotificationManager : NSObject

#pragma mark - 公共推送参数
@property(nonatomic,strong) NSString *title; /// 推送主标题
@property(nonatomic,strong) NSString *subTitle; /// 推送副标题
@property(nonatomic,strong) NSString *body; /// 推送内容体
@property(nonatomic,strong) NSString *identifier; /// 推送标识符
@property(nonatomic,assign) NSInteger badge; /// 推送角标，默认为1
@property(nonatomic,strong) NSString *_Nullable soundName; /// 推送提示音
@property(nonatomic,assign) NSInteger timeInterval; /// 推送间隔时间
@property(nonatomic,assign) BOOL repeat; /// 是否重复，若要重复->时间间隔应>=60s

#pragma mark - 图像和视频推送
@property(nonatomic,strong) NSString *imageName; /// 图像名称，包含png、jpg、gif等图像格式
@property(nonatomic,strong) NSString *videoName; /// 视频名称，包含mp3格式
@property(nonatomic,strong) NSString *URLString; /// 下载链接地址

#pragma mark - 定时推送
@property(nonatomic,strong) NSString *year; /// 年
@property(nonatomic,strong) NSString *month; /// 月
@property(nonatomic,strong) NSString *day; /// 日
@property(nonatomic,strong) NSString *weekday; /// 周
@property(nonatomic,strong) NSString *hour; /// 时
@property(nonatomic,strong) NSString *minute; /// 分
@property(nonatomic,strong) NSString *second; /// 秒

#pragma mark - 指定位置推送
@property(nonatomic,assign) CGFloat longitude;/// 经度
@property(nonatomic,assign) CGFloat latitude;/// 纬度
@property(nonatomic,assign) CGFloat radius; /// 半径范围
@property(nonatomic,assign) BOOL notifyOnEntry;/// 每次进入指定位置区域时发送通知
@property(nonatomic,assign) BOOL notifyOnExit;/// 每次离开指定位置区域时发送通知

#pragma mark - 外界方法
/// 单例
+ (instancetype)sharedInstance;
/// 是否开启权限回调
+ (void)kj_authorizationNotification:(void(^)(BOOL authorization))completion;
/// 注册远端APNs和本地消息通知
+ (void)kj_registerNotification;
/// 发送本地消息通知
- (void)kj_sendLocalityMassageWithNotificationType:(KJLocalityNotificationType)type;
/// 获取通知回调处理
+ (void)kj_getNotificationDatas:(kNotificationCompletion)completion;


#pragma mark - 工具相关
/// 清除本地角标
void kj_clearLocalityBadge(NSTimeInterval timeInterval);
/// 获取设备Token
//+ (void)kj_getDeviceTokenData:(void(^)(NSData *data))completion;
/// 转换设备Token
+ (NSString*)kj_deviceTokenTransformWithData:(NSData*)deviceToken;

@end


/*提供一套获取设备token的AppDelegate扩展
 /// 获取设备Token
 + (void)kj_getDeviceTokenData:(void(^)(NSData *data))completion;

 /// 获取设备Token
 + (void)kj_getDeviceTokenData:(void(^)(NSData *data))completion{
     dispatch_async(dispatch_get_main_queue(), ^{
         AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
         [appDelegate kj_deviceTokenData:^(NSData * _Nonnull data) {
             completion(data);
         }];
     });
 }
 
 /// AppDelegate扩展获取设备Token ------------------------------
 #import <objc/runtime.h>

 NS_ASSUME_NONNULL_BEGIN

 @interface AppDelegate (KJNotification)
 - (void)kj_deviceTokenData:(void(^)(NSData *data))completion;
 @end

 NS_ASSUME_NONNULL_END

 @interface AppDelegate ()
 @property(nonatomic,copy) void(^kDeviceTokenCompletion)(NSData *data);
 @end
 @implementation AppDelegate (KJNotification)
 - (void(^)(NSData *data))kDeviceTokenCompletion{
     return objc_getAssociatedObject(self, @selector(kDeviceTokenCompletion));
 }
 - (void)setKDeviceTokenCompletion:(void (^)(NSData *))kDeviceTokenCompletion{
     objc_setAssociatedObject(self, @selector(kDeviceTokenCompletion), kDeviceTokenCompletion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 }
 /// 获取Token
 - (void)kj_deviceTokenData:(void(^)(NSData *data))completion{
     self.kDeviceTokenCompletion = completion;
 }
 #pragma mark - UIApplicationDelegate
 //获取到deviceToken
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
     if (deviceToken) {
         !self.kDeviceTokenCompletion?:self.kDeviceTokenCompletion(deviceToken);
     }
 }

 @end
 
 */

NS_ASSUME_NONNULL_END

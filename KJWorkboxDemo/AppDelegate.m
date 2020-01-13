//
//  AppDelegate.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/9.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "AppDelegate.h"
#import "KJNotificationManager.h" /// 推送工具

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /// 注册远端APNs和本地消息通知
    [KJNotificationManager kj_registerNotification];
    
    [KJNotificationManager kj_getDeviceTokenData:^(NSData * _Nonnull data) {
        NSLog(@"deviceToken:%@",[KJNotificationManager kj_deviceTokenTransformWithData:data]);
    }];
    
    [KJNotificationManager kj_getNotificationDatas:^(KJReceiveNotificationType receiveType, KJNotificationType type, UNNotification * _Nonnull notification) {
        NSLog(@"body:%@",notification.request.content.body);
    }];
    
    return YES;
}

@end

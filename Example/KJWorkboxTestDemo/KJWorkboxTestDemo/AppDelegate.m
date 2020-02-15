//
//  AppDelegate.m
//  KJWorkboxTestDemo
//
//  Created by 杨科军 on 2020/1/13.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "AppDelegate.h"
#import <KJWorkbox/KJWorkboxHeader.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /// 注册远端APNs和本地消息通知
    [KJNotificationManager kj_registerNotification];
    
    [KJNotificationManager kj_getNotificationDatas:^(KJReceiveNotificationType receiveType, KJNotificationType type, UNNotification * _Nonnull notification) {
        NSLog(@"body:%@",notification.request.content.body);
    }];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

//
//  KJNotificationManager.m
//  KJNotificationDemo
//
//  Created by 杨科军 on 2020/1/7.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJNotificationManager.h"
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


@interface KJNotificationManager ()<UNUserNotificationCenterDelegate>
@property(nonatomic,strong,class) kNotificationCompletion xxblock;
@end
@implementation KJNotificationManager
//@dynamic title,subTitle,body,identifier,badge,soundName,timeInterval,repeat;
//@dynamic imageName,videoName,URLString;
//@dynamic timeDict,year,month,day,weekday,hour,minute,second;
//@dynamic longitude,latitude,radius;
static kNotificationCompletion _xxblock = nil;
+ (kNotificationCompletion)xxblock{
    if (_xxblock == nil) {
        _xxblock = ^void(KJReceiveNotificationType receiveType,KJNotificationType type,UNNotification *notification){ };
    }
    return _xxblock;
}
+ (void)setXxblock:(kNotificationCompletion)xxblock{
    if (xxblock != _xxblock) {
        _xxblock = [xxblock copy];
    }
}
#pragma mark - 外界方法
/// 单例
static KJNotificationManager *_instance = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
/// 是否开启权限回调
+ (void)kj_authorizationNotification:(void(^)(BOOL authorization))completion{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                /**
                 * UNAuthorizationStatusNotDetermined : 没有做出选择
                 * UNAuthorizationStatusDenied        : 用户未授权
                 * UNAuthorizationStatusAuthorized    : 用户已授权
                 */
                !completion?:completion(settings.authorizationStatus == UNAuthorizationStatusAuthorized);
            });
        }];
    }else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion?:completion(setting.types != UIUserNotificationTypeNone);
        });
    }
}

/// 注册消息推送
+ (void)kj_registerNotification{
    CGFloat kSystemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (kSystemVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = [KJNotificationManager sharedInstance];
        UNAuthorizationOptions types = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
                }];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) {
                    
                }];
            }
        }];
    }else if (kSystemVersion >= 8.0){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
#pragma clang diagnostic pop
    }
    
    //注册APNs消息推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
/// 发送本地消息通知
- (void)kj_sendLocalityMassageWithNotificationType:(KJLocalityNotificationType)type{
    UNMutableNotificationContent *content = [self UNMutableNotificationContentWithNotificationType:type];
    if (type == KJLocalityNotificationTypePlace) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.longitude,self.latitude);
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:self.radius identifier:self.identifier];
        region.notifyOnEntry = self.notifyOnEntry;
        region.notifyOnExit  = self.notifyOnExit;
        UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:self.repeat];
        [self addNotificationWithContent:content Trigger:trigger];
    }else{
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:self.timeInterval repeats:self.repeat];
        [self addNotificationWithContent:content Trigger:trigger];
    }
}

/// 获取通知回调处理
+ (void)kj_getNotificationDatas:(kNotificationCompletion)completion{
    self.xxblock = completion;
}

#pragma mark - 工具相关
/// 清除本地角标
void kj_clearLocalityBadge(NSTimeInterval timeInterval){
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        if (@available(iOS 11.0, *)) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
        }else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
            notification.fireDate = fireDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.repeatInterval = 0;
            notification.alertBody = nil;
            notification.applicationIconBadgeNumber = -1;
            notification.soundName = nil;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}
/// 获取设备Token
+ (void)kj_getDeviceTokenData:(void(^)(NSData *data))completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate kj_deviceTokenData:^(NSData * _Nonnull data) {
            completion(data);
        }];
    });
}
/// 转换设备Token
+ (NSString*)kj_deviceTokenTransformWithData:(NSData*)deviceToken{
    if (![deviceToken isKindOfClass:[NSData class]]) return nil;
    
    NSMutableString *hexToken = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSInteger count = deviceToken.length;
    for (NSInteger i = 0; i < count; i++) {
        [hexToken appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    return hexToken;
}

#pragma mark - set
- (void)setIdentifier:(NSString *)identifier{
    _identifier = identifier?:@"";
}
#pragma mark - 内部方法
/// 添加推送
- (void)addNotificationWithContent:(UNMutableNotificationContent*)content Trigger:(UNNotificationTrigger*)trigger{
    UNNotificationRequest *request;
    if ([trigger isKindOfClass:[UNCalendarNotificationTrigger class]]) {
        request = [UNNotificationRequest requestWithIdentifier:self.identifier content:content trigger:trigger];
    }else if ([trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]){
        request = [UNNotificationRequest requestWithIdentifier:self.identifier content:content trigger:trigger];
    }else if ([trigger isKindOfClass:[UNLocationNotificationTrigger class]]){
        request = [UNNotificationRequest requestWithIdentifier:self.identifier content:content trigger:trigger];
    }
    
    // 发送推送
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            
        }
    }];
}
/// 获取UNMutableNotificationContent
- (UNMutableNotificationContent*)UNMutableNotificationContentWithNotificationType:(KJLocalityNotificationType)type{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    if (self.title) {
        content.title = self.title;
    }
    if (self.subTitle) {
        content.subtitle = self.subTitle;
    }
    if (self.body) {    
        content.body = self.body;
    }
    content.badge = [NSNumber numberWithInteger:self.badge?:1]; /// 默认为1
    /// 推送声音处理
    if (self.soundName) {
        content.sound = [UNNotificationSound soundNamed:self.soundName];
        self.soundName = nil; /// 置空
    }else{
        content.sound = [UNNotificationSound defaultSound];
    }
    
    switch (type) {
        case KJLocalityNotificationTypeCustom:{
            
        }
            break;
        case KJLocalityNotificationTypeImage:{
            NSArray *array = [self.imageName componentsSeparatedByString:@"."];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:self.identifier URL:[NSURL fileURLWithPath:filePath] options:nil error:nil];
            content.attachments = @[attachment];
        }
            break;
        case KJLocalityNotificationTypeVideo:{
            NSArray *array = [self.videoName componentsSeparatedByString:@"."];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:self.identifier URL:[NSURL fileURLWithPath:filePath] options:nil error:nil];
            content.attachments = @[attachment];
        }
            break;
        case KJLocalityNotificationTypeTiming:{
            
        }
            break;
        case KJLocalityNotificationTypePlace:{
            
        }
            break;
        default:
            break;
    }
    
    return content;
}

#pragma mark - UNUserNotificationCenterDelegate
/// 前台收到推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    KJNotificationType type;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        type = KJNotificationTypeAPNs;
    }else{
        type = KJNotificationTypeLocality;
    }
    _xxblock(KJReceiveNotificationTypeWillPresent,type,notification);
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
/// 应用在后台收到推送的处理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    KJNotificationType type;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        type = KJNotificationTypeAPNs;
    }else{
        type = KJNotificationTypeLocality;
    }
    _xxblock(KJReceiveNotificationTypeDidReceive,type,response.notification);
    completionHandler();
}
/// 从通知界面直接进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification*)notification{
    KJNotificationType type;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        type = KJNotificationTypeAPNs;
    }else{
        type = KJNotificationTypeLocality;
    }
    _xxblock(KJReceiveNotificationTypeOpenSettings,type,notification);
}

@end

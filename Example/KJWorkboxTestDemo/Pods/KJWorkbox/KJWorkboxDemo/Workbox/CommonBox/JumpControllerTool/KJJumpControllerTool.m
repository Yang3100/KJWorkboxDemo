//
//  KJJumpControllerTool.m
//  KJJumpControllerDemo
//
//  Created by 杨科军 on 2019/12/23.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJJumpControllerTool.h"

@implementation KJJumpControllerTool

+ (instancetype)kj_pushViewControllerWithClassName:(NSString*)clazz Params:(NSDictionary*_Nullable)params{
    // 取出控制器类名
    const char *className = [clazz cStringUsingEncoding:NSASCIIStringEncoding];
    // 根据字符串返回一个类
    Class newClass = objc_getClass(className);
    if (newClass == nil) {
        // 创建一个类
        Class superClass = [UIViewController class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
 
    // 创建对象（就是控制器对象）
    id instance = [[newClass alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 检测这个对象是否存在该属性
        if (checkIsExistProperty(instance, key)) {
            // 利用 KVC 对控制器对象的属性赋值
            [instance setValue:obj forKey:key];
        }
    }];
    
    // 跳转到对应的控制器
    UIViewController *vc = [self topViewController];
    UINavigationController *nav = vc.navigationController;
    if (nav == nil) {
        [vc presentViewController:instance animated:YES completion:nil];
    } else {
        [nav pushViewController:instance animated:YES];
    }
    return instance;
}

// 获取当前显示在屏幕最顶层的 ViewController
+ (UIViewController*)topViewController {
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = _topViewController(keyWindow.rootViewController);
    while (vc.presentedViewController) {
        vc = _topViewController(vc.presentedViewController);
    }
    return vc;
}

static inline UIViewController *_topViewController(UIViewController *vc){
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return _topViewController([(UINavigationController *)vc topViewController]);
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return _topViewController([(UITabBarController *)vc selectedViewController]);
    } else {
        return vc;
    }
    return nil;
}
// 检测对象是否存在该属性
static inline bool checkIsExistProperty(id instance,NSString *verifyPropertyName){
    unsigned int count, i;
    // 获取对象里的属性列表
    objc_property_t *properties = class_copyPropertyList([instance class], &count);
    for (i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return true;
        }
    }
    free(properties);
    return false;
}

@end

//
//  KJJumpControllerTool.h
//  KJJumpControllerDemo
//
//  Created by 杨科军 on 2019/12/23.
//  Copyright © 2019 杨科军. All rights reserved.
//  跳转控制器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface KJJumpControllerTool : NSObject

+ (instancetype)kj_pushViewControllerWithClassName:(NSString*)clazz Params:(NSDictionary*_Nullable)params;

@end

NS_ASSUME_NONNULL_END

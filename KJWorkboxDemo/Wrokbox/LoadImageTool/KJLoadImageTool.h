//
//  KJLoadImageTool.h
//  KJPhotoBrowserDemo
//
//  Created by 杨科军 on 2019/11/22.
//  Copyright © 2019 杨科军. All rights reserved.
//  网络下载工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KJLoadImages [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/KJLoadImages"];
#define kMaxLoadNum  (2) /// 最大缓存次数
/// 下载完成回调
typedef void (^KJLoadImageBlock)(UIImage * _Nullable image);
/// 网络请求回调
typedef void (^KJLoadDataBlock)(NSData * _Nullable data, NSError * _Nullable error);
/// 下载进度回调
typedef void (^_Nullable KJLoadProgressBlock)(CGFloat totalLength,CGFloat currentLength);

@interface KJLoadImageTool : NSObject
/// 需要注意，进度需要在下载数据代码之前执行
@property (nonatomic,copy,class) KJLoadProgressBlock progressblock;
/// 下载数据，未使用缓存机制
+ (NSData*)kj_downloadDataWithURL:(NSString*)url;

/// 带缓存机制的下载图片
+ (void)kj_loadImageWithURL:(NSString*)url Complete:(KJLoadImageBlock)block;
+ (void)kj_loadImageWithURL:(NSString*)url LoadProgress:(KJLoadProgressBlock)progess Complete:(KJLoadImageBlock)block;

/// 清理掉本地缓存
+ (void)kj_clearImagesCache;

/// 获取图片缓存的占用的总大小/bytes
+ (CGFloat)kj_imagesCacheSize;

@end

NS_ASSUME_NONNULL_END

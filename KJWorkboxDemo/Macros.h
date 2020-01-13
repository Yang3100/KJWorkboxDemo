//
//  Macros.h
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/13.
//  Copyright © 2020 杨科军. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#ifdef DEBUG // 输出日志 (格式: [编译时间] [文件名] [方法名] [行号] [输出内容])
#define NSLog(FORMAT, ...) fprintf(stderr,"------- 😎 给我点赞 😎 -------\n编译时间:%s\n文件名:%s\n方法名:%s\n行号:%d\n打印信息:%s\n\n", __TIME__,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__func__,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil
#endif

#endif /* Macros_h */

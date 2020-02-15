//
//  KJPredicateTool.h
//  KJPredicateDemo
//
//  Created by 杨科军 on 2019/9/19.
//  Copyright © 2019 杨科军. All rights reserved.
//  利用谓词写的一套工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// bindings参数:替换变量字典。字典必须包含接收器中所有变量的键值对
typedef BOOL (^KJPredicateBlock)(id evaluatedObject, NSDictionary<NSString *, id> *bindings);
@interface KJPredicateTool : NSObject

/// 映射
+ (NSArray*)kj_mapWithTemps:(NSArray*)temp Block:(id (^)(id object))block;
/// 筛选数据
+ (id)kj_detectWithTemps:(NSArray*)temp Block:(BOOL (^)(id object))block;
/// NSPredicate 不影响原数组，返回数组即为过滤结果
+ (NSArray*)kj_filtrationDatasWithTemps:(NSArray*)temps predicateWithBlock:(KJPredicateBlock)block;
/// NSPredicate 除去数组temps中包含的数组targetTemps元素
+ (NSArray*)kj_delEqualDatasWithTemps:(NSArray*)temps TargetTemps:(NSArray*)targetTemps;
/// 利用 NSSortDescriptor 对对象数组，按照某一属性的升序降序排列
+ (NSArray*)kj_sortDescriptorWithTemps:(NSArray*)temps Key:(NSString*)key Ascending:(BOOL)ascending;
/// 利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列
+ (NSArray*)kj_sortDescriptorWithTemps:(NSArray*)temps Keys:(NSArray*)keys Ascendings:(NSArray*)ascendings;
/// 利用 NSSortDescriptor 对对象数组，取出 key 中匹配 value 的元素
+ (NSArray*)kj_takeOutDatasWithTemps:(NSArray*)temps Key:(NSString*)key Value:(NSString*)value;
// 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
// [c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd]既又
+ (NSArray*)kj_takeOutDatasWithTemps:(NSArray*)temps Operator:(NSString*)ope Key:(NSString*)key Value:(NSString*)value;

// 过滤空格
+ (NSString*)kj_filterSpace:(NSString*)string;
// 检测输入内容是否为数字
+ (BOOL)kj_validateNumber:(NSString*)number;
// 验证字符串中是否有特殊字符
+ (BOOL)kj_validateHaveSpecialCharacter:(NSString*)string;
// 验证手机号码是否有效
+ (BOOL)kj_mobileNumberIsCorrect:(NSString *)mobileNum;
// 验证邮箱格式是否正确
+ (BOOL)kj_validateEmail:(NSString*)email;
// 验证身份证是否是真实的
+ (BOOL)kj_validateIDCardNumber:(NSString*)value;

@end

NS_ASSUME_NONNULL_END

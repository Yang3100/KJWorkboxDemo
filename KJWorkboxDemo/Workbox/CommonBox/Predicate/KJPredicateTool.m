//
//  KJPredicateTool.m
//  KJPredicateDemo
//
//  Created by 杨科军 on 2019/9/19.
//  Copyright © 2019 杨科军. All rights reserved.
//

#import "KJPredicateTool.h"

@implementation KJPredicateTool

/// 映射
+ (NSArray*)kj_mapWithTemps:(NSArray*)temp Block:(id (^)(id object))block{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:temp.count];
    for (id object in temp) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    return array;
}
/// 筛选数据
+ (id)kj_detectWithTemps:(NSArray*)temp Block:(BOOL (^)(id object))block{
    for (id object in temp) {
        if (block(object)) return object;
    }
    return nil;
}


//MARK: - ------------------------ Predicate谓词的简单使用 ------------------------
/*
 // self 表示数组元素/字符串本身
 // 比较运算符 =/==(等于)、>=/=>(大于等于)、<=/=<(小于等于)、>(大于)、<(小于)、!=/<>(不等于)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self = %@",[people_arr lastObject]];//比较数组元素相等
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@",[(People *)[people_arr lastObject] address]];//比较数组元素中某属性相等
 ////NSPredicate *pre = [NSPredicate predicateWithFormat:@"age in {18,21}"];//比较数组元素中某属性值在这些值中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"age between {18,21}"];//比较数组元素中某属性值大于等于左边的值，小于等于右边的值
 
 // 逻辑运算符 and/&&(与)、or/||(或)、not/!(非)
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"address = %@ && age between {19,22}",[(People *)[people_arr lastObject] address]];
 
 // 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
 // [c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd]既 又
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name beginswith[cd] 'ja'"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name matches '^[a-zA-Z]{4}$'"];
 
 //集合运算符 some/any:集合中任意一个元素满足条件、all:集合中所有元素都满足条件、none:集合中没有元素满足条件、in:集合中元素在另一个集合中
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"all employees.employeeId in {7,8,9}"];
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"self in %@",filter_arr];
 // $K：用于动态传入属性名、%@：用于动态设置属性值(字符串、数字、日期对象)、$(value)：可以动态改变
 //NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K > $age",@"age"];
 //pre = [pre predicateWithSubstitutionVariables:@{@"age":@21}];
 // NSCompoundPredicate 相当于多个NSPredicate的组合
 //NSCompoundPredicate *compPre = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"age > 19"],[NSPredicate predicateWithFormat:@"age < 21"]]];
 // 暂时没找到用法
 //NSComparisonPredicate *compPre = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"name"] rightExpression:[NSExpression expressionForVariable:@"ja"] modifier:NSAnyPredicateModifier type:NSBeginsWithPredicateOperatorType options:NSNormalizedPredicateOption];
 //[people_arr filterUsingPredicate:compPre];

 */

//MARK: - --- NSPredicate 不影响原数组，返回数组即为过滤结果
+ (NSArray*)kj_filtrationDatasWithTemps:(NSArray*)temps predicateWithBlock:(KJPredicateBlock)block{
    NSPredicate *pre = [NSPredicate predicateWithBlock:block];
    return [temps filteredArrayUsingPredicate:pre];
}
//MARK: - --- NSPredicate 除去数组temps中包含的数组targetTemps元素
+ (NSArray*)kj_delEqualDatasWithTemps:(NSArray*)temps TargetTemps:(NSArray*)targetTemps{
    /// 谓词 从第二个数组(b)中去除第一个数组(a)中相同的元素
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", targetTemps];
    return [temps filteredArrayUsingPredicate:predicate].mutableCopy;
}
//MARK: - --- 利用 NSSortDescriptor 对对象数组，按照某一属性的升序降序排列
+ (NSArray*)kj_sortDescriptorWithTemps:(NSArray*)temps Key:(NSString*)key Ascending:(BOOL)ascending{
    // 利用 NSSortDescriptor 对对象数组，按照某一属性或某些属性的升序降序排列
    NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSMutableArray *array = [NSMutableArray arrayWithArray:temps];
    [array sortUsingDescriptors:@[des]];
    return array;
}
//MARK: - --- 利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列
+ (NSArray*)kj_sortDescriptorWithTemps:(NSArray*)temps Keys:(NSArray*)keys Ascendings:(NSArray*)ascendings{
    // 利用 NSSortDescriptor 对对象数组，按照某一属性或某些属性的升序降序排列
    NSMutableArray *desTemp = [NSMutableArray array];
    for (NSInteger i=0; i<keys.count; i++) {
        NSString *key = keys[i];
        BOOL boo = [ascendings[i] integerValue] ? YES : NO;
        NSSortDescriptor *des = [NSSortDescriptor sortDescriptorWithKey:key ascending:boo];
        [desTemp addObject:des];
    }
    NSMutableArray *array = temps.mutableCopy;
    [array sortUsingDescriptors:desTemp];
    desTemp = nil;
    return array;
}
//MARK: - --- 利用 NSSortDescriptor 对对象数组，取出 key 中匹配 value 的元素
+ (NSArray*)kj_takeOutDatasWithTemps:(NSArray*)temps Key:(NSString*)key Value:(NSString*)value{
    NSString *string  = [NSString stringWithFormat:@"%@ LIKE '%@'",key,value];
    NSPredicate *pred = [NSPredicate predicateWithFormat:string];
    return [temps filteredArrayUsingPredicate:pred];
}
//MARK: - --- 字符串比较运算符 beginswith(以*开头)、endswith(以*结尾)、contains(包含)、like(匹配)、matches(正则)
// [c]不区分大小写 [d]不区分发音符号即没有重音符号 [cd]既又
+ (NSArray*)kj_takeOutDatasWithTemps:(NSArray*)temps Operator:(NSString*)ope Key:(NSString*)key Value:(NSString*)value{
    NSString *string  = [NSString stringWithFormat:@"%@ %@ '%@'",key,ope,value];
    NSPredicate *pred = [NSPredicate predicateWithFormat:string];
    return [temps filteredArrayUsingPredicate:pred];
}

//MARK: - --- 过滤空格
+ (NSString*)kj_filterSpace:(NSString*)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSLog(@"urlStr = %@",string);
    //过滤中间空格
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"urlStr = %@",string);
    return string;
}

//MARK: - --- 检测输入内容是否为数字
+ (BOOL)kj_validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length){
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0){
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//MARK: - --- 检测字符串中是否有特殊字符
+ (BOOL)kj_validateHaveSpecialCharacter:(NSString *)string{
    NSString *regex = @".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？].*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//MARK: - --- 验证手机号码是否有效
+ (BOOL)kj_mobileNumberIsCorrect:(NSString *)mobileNum{
    if (mobileNum.length != 11) return NO;
    /**手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    // 使用谓词筛选功能,选出需求的数据
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES) ||
        ([regextestcm evaluateWithObject:mobileNum] == YES) ||
        ([regextestct evaluateWithObject:mobileNum] == YES) ||
        ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

//MARK: - --- 验证邮箱格式是否正确
+ (BOOL)kj_validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//MARK: - --- 判断身份证是否是真实的
+ (BOOL)kj_validateIDCardNumber:(NSString *)value{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value){
        return NO;
    }else {
        length = value.length;
        if (length != 15 && length != 18){
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    
    for (NSString *areaCode in areasArray){
        if ([areaCode isEqualToString:valueStart2]){
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) return NO;
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    NSInteger year = 0;
    
    switch (length){
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)){
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            return [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)] > 0 ? YES : NO;
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)){
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0){
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue)*7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue)*9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value  substringWithRange:NSMakeRange(12,1)].intValue)*10 + ([value  substringWithRange:NSMakeRange(3,1)].intValue + [value  substringWithRange:NSMakeRange(13,1)].intValue)*5 + ([value  substringWithRange:NSMakeRange(4,1)].intValue + [value  substringWithRange:NSMakeRange(14,1)].intValue)*8 + ([value  substringWithRange:NSMakeRange(5,1)].intValue + [value  substringWithRange:NSMakeRange(15,1)].intValue)*4 + ([value  substringWithRange:NSMakeRange(6,1)].intValue + [value  substringWithRange:NSMakeRange(16,1)].intValue)*2 + [value  substringWithRange:NSMakeRange(7,1)].intValue *1 + [value  substringWithRange:NSMakeRange(8,1)].intValue *6 + [value  substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]){
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
}


@end

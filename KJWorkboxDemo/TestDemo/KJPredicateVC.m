//
//  KJPredicateVC.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/17.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJPredicateVC.h"
#import "KJPredicateTool.h"
@interface KJPredicateVC ()

@end

@implementation KJPredicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    textView.textColor = UIColor.blackColor;
    textView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:textView];
    NSString *string;
    // Do any additional setup after loading the view.
    NSArray *temp = @[@{@"Apple":@"1.0",@"xx":@(1)},
                       @{@"Apple":@(2),@"xx":@(2)},
                       @{@"Apple":@"3",@"xx":@(3)},
                       @{@"Apple":@"4",@"xx":@(4)},
                       ];
    NSArray *arr1 = [KJPredicateTool kj_filtrationDatasWithTemps:temp predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//        NSLog(@"\nevaluatedObject = %@\nbindings = %@",evaluatedObject,bindings);
        NSDictionary *dic = evaluatedObject;
        return [dic[@"Apple"] integerValue] >= 2;
    }];
    NSLog(@"\nNSPredicate 不影响原数组，返回数组即为过滤结果 = %@",arr1);
    string = [NSString stringWithFormat:@"\nNSPredicate 不影响原数组，返回数组即为过滤结果 = %@",arr1];
    
    NSArray *temp1 = @[@"1",@"2",@"3",@"5",@"2.5"];
    NSArray *temp2 = @[@"1",@"5",@"2.5"];
    NSArray *arr2 = [KJPredicateTool kj_delEqualDatasWithTemps:temp1 TargetTemps:temp2];
    NSLog(@"\nNSPredicate 除去数组temps中包含的数组targetTemps元素 = %@",arr2);
    string = [string stringByAppendingFormat:@"\nNSPredicate 除去数组temps中包含的数组targetTemps元素 = %@",arr2];
    
    NSArray *temp3 = @[@{@"Apple":@"1",@"xx":@"x"},
                       @{@"Apple":@"2",@"xx":@"bdq"},
                       @{@"Apple":@"2",@"xx":@"B"},
                       @{@"Apple":@"4",@"xx":@""},
                       @{@"Apple":@"4",@"xx":@"cb"},
                       @{@"Apple":@"2",@"xx":@"2"},
                       ];
    /// 字母排序是根据首字母的ASC码排序
    NSArray *arr3 = [KJPredicateTool kj_sortDescriptorWithTemps:temp3 Keys:@[@"Apple",@"xx"] Ascendings:@[@(NO),@(YES)]];
    NSLog(@"\n利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列 = %@",arr3);
    string = [string stringByAppendingFormat:@"\n利用 NSSortDescriptor 对对象数组，按照某些属性的升序降序排列 = %@",arr3];
    
    NSArray *arr4 = [KJPredicateTool kj_takeOutDatasWithTemps:temp3 Key:@"xx" Value:@"cb"];
    NSLog(@"\n利用 NSSortDescriptor 对对象数组，取出 key 中包含 value 的元素 = %@",arr4);
    string = [string stringByAppendingFormat:@"\n利用 NSSortDescriptor 对对象数组，取出 key 中包含 value 的元素 = %@",arr4];
    
    textView.text = string;
}

@end

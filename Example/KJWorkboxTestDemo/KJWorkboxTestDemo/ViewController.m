//
//  ViewController.m
//  KJWorkboxTestDemo
//
//  Created by 杨科军 on 2020/1/13.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "ViewController.h"
#import <KJWorkbox/KJWorkboxHeader.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    KJNotificationManager *manager = [KJNotificationManager sharedInstance];
    manager.title = @"普通推送";
//        manager.subTitle = @"小标题";
    manager.body = @"test1234u";
    manager.timeInterval = 3;
    manager.identifier = @"123dc233ca924d7034b05dbc7abe8dfbdaf32ffd";
    [manager kj_sendLocalityMassageWithNotificationType:(KJLocalityNotificationTypeCustom)];

}


@end

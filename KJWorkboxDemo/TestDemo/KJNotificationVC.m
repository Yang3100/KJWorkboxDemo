//
//  KJNotificationVC.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/9.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJNotificationVC.h"
#import "KJNotificationManager.h"
@interface KJNotificationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *temps;

@end

@implementation KJNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
}

- (void)setUI{
    self.temps = @[@"普通推送",@"图像推送",@"视频推送",@"定时推送"];
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, w, h-20) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = YES;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.temps.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.temps[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textAlignment = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    [cell.textLabel setTextColor:UIColor.blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        KJNotificationManager *manager = [KJNotificationManager sharedInstance];
        manager.title = @"普通推送";
//        manager.subTitle = @"小标题";
        manager.body = @"You may say that I'm a dreamer, but I'm not the only one";
        manager.timeInterval = 3;
        manager.identifier = @"123dc233ca924d7034b05dbc7abe8dfbdaf32ffd";
        [manager kj_sendLocalityMassageWithNotificationType:(KJLocalityNotificationTypeCustom)];
    }else if (indexPath.row == 1) {
        
    }
}

@end

//
//  KJLoadImageVC.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/10.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJLoadImageVC.h"
#import "KJLoadImageTool.h"

@interface KJLoadImageVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray <UIView *>*selectedViewArray;

@end

@implementation KJLoadImageVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI{
    [self setDemoTitle:@"单图"];
    CGFloat w = self.view.frame.size.width;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 135, w-30, 150)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_imageView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [KJLoadImageTool kj_downloadDataWithURL:self.images[0]];
        dispatch_async(dispatch_get_main_queue(), ^{        
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
    
    [self setDemoTitle:@"多图"];
    CGFloat wh = 80;
    CGFloat x =  15;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 4 * 80 - x * 2) / 3;
    _selectedViewArray = [NSMutableArray array];
    for (int i = 0 ; i < self.images.count; i ++) {
        int indexX = i % 4;
        int indexY = i / 4;
        __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x + indexX  * (wh + margin), 335 + indexY * (wh + 15), wh, wh)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        imageView.tag = i;
        [KJLoadImageTool kj_loadImageWithURL:self.images[i] Complete:^(UIImage * _Nullable image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }];
        [_selectedViewArray addObject:imageView];
    }
    
    __block UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.frame = CGRectMake(w-300-15, 64+30, 300, 30);
    label.textColor = self.view.tintColor;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"缓存大小 : %.2fkb",[KJLoadImageTool kj_imagesCacheSize]];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(w-100, 64, 100, 30);
    [button setTitle:@"清除缓存" forState:(UIControlStateNormal)];
    [button setTitleColor:self.view.tintColor forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:button];
//    [button kj_addAction:^(UIButton * _Nonnull kButton) {
//        [KJLoadImageTool kj_clearImagesCache];
//        label.text = [NSString stringWithFormat:@"缓存大小 : %.2fkb",[KJLoadImageTool kj_imagesCacheSize]];
//    }];
}

- (void)setDemoTitle:(NSString *)title{
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.frame = [title isEqualToString:@"单图"] ? CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 20) : CGRectMake(15, 300, 100, 20);
    label.textColor = self.view.tintColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
}

- (NSArray *)images{
    if (!_images) {
        NSArray *images = @[@"http://photos.tuchong.com/285606/f/4374153.jpg",
                            @"http://img12.360buyimg.com/piao/jfs/t2743/132/3170930521/77809/42cfd6d4/57836e27N06956fd3.jpg",
                            @"http://img5.cache.netease.com/photo/0003/2012-06-21/84G462VS51GQ0003.jpg",
                            @"http://i2.hdslb.com/bfs/archive/1c471796343e34a8613518cc0d393792680a1022.jpg",
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574831563457&di=5a4d7d6137bfadc59e899a7324b43bc7&imgtype=0&src=http%3A%2F%2Fwx3.sinaimg.cn%2Forj360%2F006xMRKdly1g7osekxracj31bq8koe81.jpg",
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574833072666&di=f3286000de7f1219dc0671f186a8855a&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D2417468297%2C2186818078%26fm%3D214%26gp%3D0.jpg",
        ];
        _images = images;
    }
    return _images;
}
@end

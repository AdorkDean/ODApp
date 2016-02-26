//
//  ODNetClosedView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNetClosedView.h"
#import "AFNetworkReachabilityManager.h"

@interface ODNetClosedView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@end


@implementation ODNetClosedView

+ (void)load
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                [self dismiss];
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [self show];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [self dismiss];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [self dismiss];
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}

+ (instancetype)sharedView
{
    static dispatch_once_t once;
    static ODNetClosedView *sharedView;
    dispatch_once(&once, ^
    {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [UIColor whiteColor];
        sharedView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:sharedView];
        sharedView.hidden = YES;
    });
    return sharedView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wifi_icon"]];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)label1
{
    if (!_label1)
    {
        _label1 = [[UILabel alloc]init];
        _label1.text = @"无网络";
        _label1.textColor = [UIColor grayColor];
        _label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label1];
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2)
    {
        _label2 = [[UILabel alloc]init];
        _label2.text = @"请先连接到网络再继续使用";
        _label2.textColor = [UIColor grayColor];
        _label2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label2];
    }
    return _label2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.label1.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, self.od_width,20);
    self.label2.frame = CGRectMake(0, CGRectGetMaxY(self.label1.frame) + 20, self.od_width, 20);
}

+ (instancetype)netCloseView
{
    return [[self sharedView]initWithFrame:[UIScreen mainScreen].bounds];
}

+ (void)show
{
    [[self netCloseView]setHidden:NO];
}

+ (void)dismiss
{
    [[self netCloseView]setHidden:YES];
}
@end

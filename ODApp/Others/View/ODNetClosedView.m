//
//  ODNetClosedView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNetClosedView.h"

@interface ODNetClosedView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@end


@implementation ODNetClosedView


+ (instancetype)sharedView
{
    static dispatch_once_t once;
    static ODNetClosedView *sharedView;
    dispatch_once(&once, ^
    {
        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [UIColor greenColor];
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
        [self addSubview:_label1];
    }
    return _label1;
}

- (UILabel *)label2
{
    if (!_label2)
    {
        _label2 = [[UILabel alloc]init];
        _label2.text = @"点击屏幕重新加载";
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

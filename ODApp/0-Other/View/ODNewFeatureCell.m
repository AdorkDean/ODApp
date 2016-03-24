//
//  ODNewFeatureCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNewFeatureCell.h"

#import "ODTabBarController.h"

@interface ODNewFeatureCell()

/** imageView */
@property (nonatomic, weak) UIImageView *imageView;

/** 开始按钮 */
@property (nonatomic, weak) UIButton *startButton;

@end

@implementation ODNewFeatureCell

#pragma mark - 懒加载
/** 懒加载 */
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

/** 懒加载开始按钮 */
- (UIButton *)startButton
{
    if (!_startButton)
    {
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:startButton];
        _startButton = startButton;
    }
    return _startButton;
}

#pragma mark - 设置数据
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

/**
 *  布局子控件frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = [UIScreen mainScreen].bounds;

    // 设置开始按钮frame
    self.startButton.od_width = 140;
    self.startButton.od_height = 50;
    self.startButton.center = CGPointMake(KScreenWidth * 0.5, KScreenHeight * 0.8);
}

- (void)setIndex:(NSIndexPath *)indexPath imageCount:(NSInteger)count
{
    if (indexPath.item == (count - 1))
    {
        self.startButton.hidden = NO;
        [self.startButton setTitle:@"立即体验" forState:UIControlStateNormal];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.startButton.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
        self.startButton.layer.masksToBounds = YES;
        self.startButton.layer.cornerRadius = 25;
        self.startButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.startButton.layer.borderWidth = 1;
        [self.startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.startButton.hidden = YES;
    }
}

#pragma mark - 事件方法
- (void)start
{
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.hidden = 0;
    }];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[ODTabBarController alloc] init];
}

@end


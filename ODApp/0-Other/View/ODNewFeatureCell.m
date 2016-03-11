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
        [startButton setBackgroundImage:[UIImage imageNamed:@"立即体验icon"] forState:UIControlStateNormal];
        startButton.od_width = 140;
        startButton.od_height = 50;
        [self.contentView addSubview:startButton];
        _startButton = startButton;
        
        [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (void)start
{
    [UIView animateWithDuration:0.25 animations:^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[ODTabBarController alloc] init];
    }];
}

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
    
    self.startButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.87);
}

- (void)setIndex:(NSIndexPath *)indexPath imageCount:(NSInteger)count
{
    if (indexPath.item == (count - 1))
    {
        self.startButton.hidden = NO;
    }
    else
    {
        self.startButton.hidden = YES;
    }
}

@end


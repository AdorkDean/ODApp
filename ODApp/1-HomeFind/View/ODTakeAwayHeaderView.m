//
//  ODTakeAwayHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeAwayHeaderView.h"
#import "ODInfiniteScrollView.h"

@interface ODTakeAwayHeaderView()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuView;

/** 指示器 */
@property (weak, nonatomic) IBOutlet UIView *indicatorLine;

/** 无线滚动scrollView */
@property (nonatomic, weak) IBOutlet ODInfiniteScrollView *scrollView;

/** 被选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation ODTakeAwayHeaderView

/**
 *  快速创建View
 */
+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark - 初始化方法
/**
 *  初始化
 */
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 添加点击事件
    for (UIButton *button in self.menuView) {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 默认第一个按钮无法点击
        if (button.od_x < button.od_width) {
            button.enabled = NO;
            self.selectedButton = button;
        }
    }
}

- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    // 传递图片地址数组
    self.scrollView.images = [banners valueForKeyPath:@"img_url"];
    self.scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.scrollView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
}

#pragma mark - 事件方法
/**
 *  切换指示器, 重新发送请求
 */
- (void)buttonClick:(UIButton *)button
{
    self.selectedButton.enabled = YES;
    self.selectedButton = button;
    self.selectedButton.enabled = NO;
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.indicatorLine.od_centerX = button.od_centerX;
    }];
    
    NSInteger index = button.od_x / button.od_width + 1;
    // 更新参数
    if ([self.delegate respondsToSelector:@selector(headerView:didClickedMenuButton:)]) {
        [self.delegate headerView:self didClickedMenuButton:index];
    }
}

@end

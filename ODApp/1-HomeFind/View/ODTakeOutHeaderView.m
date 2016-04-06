//
//  ODTakeOutHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeOutHeaderView.h"
#import "ODInfiniteScrollView.h"
#import "ODTakeOutBannerModel.h"
#import "ODPublicWebViewController.h"

@interface ODTakeOutHeaderView() <ODInfiniteScrollViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuView;

/** 指示器 */
@property (weak, nonatomic) IBOutlet UIView *indicatorLine;

/** 无线滚动scrollView */
@property (nonatomic, weak) IBOutlet ODInfiniteScrollView *scrollView;

/** 被选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation ODTakeOutHeaderView

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
    self.scrollView.delegate = self;
    
    // 添加点击事件
    for (UIButton *button in self.menuView) {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 默认第一个按钮无法点击
        if (button.od_x < button.od_width) {
            button.enabled = NO;
            self.selectedButton = button;
        }
        button.titleLabel.backgroundColor = [UIColor whiteColor];
        button.titleLabel.layer.masksToBounds = YES;
    }
}

- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    // 传递图片地址数组
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ODTakeOutBannerModel *banner in banners) {
        [arrayM addObject:banner.img_url];
    }
    // 传递地址数组(不为空时)
    if ( arrayM.count ) self.scrollView.images = arrayM;
    // 设置pageControl颜色
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
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.indicatorLine.od_centerX = button.od_centerX;
    }];
    
    [self setNeedsDisplay];
    
    NSInteger index = button.od_x / button.od_width;
    // 更新参数
    if ([self.delegate respondsToSelector:@selector(headerView:didClickedMenuButton:)]) {
        [self.delegate headerView:self didClickedMenuButton:index];
    }
}

#pragma mark - ODInfiniteScrollViewDelegate
- (void)infiniteScrollViewDidClickImage:(ODInfiniteScrollView *)infiniteScrollView index:(NSInteger)index
{
    ODTakeOutBannerModel *banner = self.banners[index];
    if ( !banner.banner_url ) return;
    ODPublicWebViewController *webViewVc = [[ODPublicWebViewController alloc] init];
    webViewVc.webUrl = banner.banner_url;
    webViewVc.navigationTitle = banner.title;
    webViewVc.isShowProgress = YES;
    // 跳转
    UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVc = tabBarVc.selectedViewController;
    [navVc pushViewController:webViewVc animated:YES];
}

@end

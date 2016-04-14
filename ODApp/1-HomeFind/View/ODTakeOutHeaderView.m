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

#import <UIImageView+WebCache.h>

@interface ODTakeOutHeaderView() <ODInfiniteScrollViewDelegate>

/** 菜单 */
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *menuView;
/** 指示器 */
@property (nonatomic, weak) IBOutlet UIView *indicatorLine;
/** banner视图 */
@property (nonatomic, weak) IBOutlet UIView *scrollView;
/** 被选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
// 一张图片
@property (nonatomic, weak) UIImageView *oneImageView;
// 多张图片
@property (nonatomic, weak) ODInfiniteScrollView *infiniteScrollView;

@end

@implementation ODTakeOutHeaderView

/**
 *  快速创建View
 */
+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark - LazyLoad
- (UIImageView *)oneImageView
{
    if (_oneImageView == nil) {
        UIImageView *oneImageView = [[UIImageView alloc] init];
        oneImageView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:oneImageView];
        _oneImageView = oneImageView;
        // 添加手势
        oneImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gas = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewClick)];
        [oneImageView addGestureRecognizer:gas];
    }
    return _oneImageView;
}

- (ODInfiniteScrollView *)infiniteScrollView
{
    if (_infiniteScrollView == nil) {
        ODInfiniteScrollView *infiniteScrollView = [[ODInfiniteScrollView alloc] init];
        infiniteScrollView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:infiniteScrollView];
        _infiniteScrollView = infiniteScrollView;
        // 设置代理
        infiniteScrollView.delegate = self;
        // 设置pageControl颜色
        infiniteScrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        infiniteScrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    }
    return _infiniteScrollView;
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
        button.titleLabel.backgroundColor = [UIColor whiteColor];
        button.titleLabel.layer.masksToBounds = YES;
    }
}

- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    
    if (banners.count == 0) {           // 没有图片
        self.oneImageView.image = [UIImage imageNamed:@"placeholderImage"];
        return;
    } else if(banners.count == 1) {     // 一张图片
        ODTakeOutBannerModel *firstM = banners.firstObject;
        [self.oneImageView sd_setImageWithURL:[NSURL OD_URLWithString:firstM.img_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
    } else {                            // 多张图片
        NSMutableArray *arrayM = [NSMutableArray array];
        for (ODTakeOutBannerModel *banner in banners) {
            [arrayM addObject:banner.img_url];
        }
        // 传递地址数组(不为空时)
        if ( arrayM.count ) self.infiniteScrollView.images = arrayM;
    }
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
         
- (void)headerImageViewClick
{
    [self bannarClick:0];
}

- (void)bannarClick:(NSInteger)index
{
    if ( !self.banners.count ) return;
    ODTakeOutBannerModel *banner = self.banners[index];
    if ( !banner.banner_url.length ) return;
    ODPublicWebViewController *webViewVc = [[ODPublicWebViewController alloc] init];
    webViewVc.webUrl = banner.banner_url;
    webViewVc.navigationTitle = banner.title;
    webViewVc.isShowProgress = YES;
    // 跳转
    UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVc = tabBarVc.selectedViewController;
    [navVc pushViewController:webViewVc animated:YES];
}

#pragma mark - ODInfiniteScrollViewDelegate
- (void)infiniteScrollViewDidClickImage:(ODInfiniteScrollView *)infiniteScrollView index:(NSInteger)index
{
    [self bannarClick:index];
}

@end

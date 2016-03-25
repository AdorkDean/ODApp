//
//  ODBazaarViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarViewController.h"

@interface ODBazaarViewController () <UIScrollViewDelegate>

/** scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 指示器 */
@property (nonatomic, weak) UIView *lineView;

@end

/** 下划线高度 */
static CGFloat const lineHeight = 1;

@implementation ODBazaarViewController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    // 创建自定义导航栏
    [self setupCustomNav];
    // 添加子控制器
    [self setupChilidVc];
    // 创建ScrollView
    [self createScrollView];
}

#pragma mark - 初始化方法
/**
 *  设置导航栏
 */
- (void)setupNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"欧动集市";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(publishButtonClick) image:[UIImage imageNamed:@"发布任务icon"] highImage:nil];
}
/**
 *  创建自定义导航栏
 */
- (void)setupCustomNav
{
    NSArray *array = @[@"换技能", @"求帮助"];
    NSUInteger count = array.count;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRGBString:@"#484848" alpha:1] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRGBString:@"#ffffff" alpha:1]];
        [button setFrame:CGRectMake((KScreenWidth * 0.5) * i, 0, KScreenWidth * 0.5, ODBazaaeExchangeNavHeight)];
        [self.view addSubview:button];
        
        [button addTarget:self action:@selector(changeController:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 创建指示器
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (ODBazaaeExchangeNavHeight - lineHeight), KScreenWidth * 0.5, lineHeight)];
    lineView.backgroundColor = [UIColor colorWithRGBString:@"#ffd802" alpha:1];
    [self.view addSubview:lineView];
    self.lineView = lineView;
}

/**
 *  创建ScrollView
 */
- (void)createScrollView
{
    // ScrollView 高度
    CGFloat height = KScreenHeight - ODNavigationHeight - ODBazaaeExchangeNavHeight - ODTabBarHeight;
    
    CGRect frame = CGRectMake(0, ODBazaaeExchangeNavHeight, KScreenWidth, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 设置偏移量
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * KScreenWidth, 0);
    // 默认加载第一个界面
    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 *  添加子控制器
 */
- (void)setupChilidVc
{
    ODBazaaeExchangeSkillViewController *exchangeSkill = [[ODBazaaeExchangeSkillViewController alloc] init];
    [self addChildViewController:exchangeSkill];

    ODBazaarRequestHelpViewController *requestHelp = [[ODBazaarRequestHelpViewController alloc] init];
    [self addChildViewController:requestHelp];
}

/**
 *  设置指示器
 */
- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    // 添加动画效果
    [UIView animateWithDuration:animateDuration animations:^{
        self.lineView.od_x = KScreenWidth * 0.5 * index;
    }];
    
    // 设置scrollView的contentOffset
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x = KScreenWidth * index;
    [self.scrollView setContentOffset:offSet animated:YES];
}

#pragma mark - UIScrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.scrollView]) return;
    NSInteger index = scrollView.contentOffset.x / self.view.od_width;
    self.index = index;
    
    // 加载第二界面
    UIViewController *childVc = self.childViewControllers[index];
    // 如果已经加载子控制器,  直接返回
    if (childVc.isViewLoaded) return;
    childVc.view.frame = CGRectMake(KScreenWidth * index, 0, KScreenWidth, scrollView.od_height);
    [scrollView addSubview:childVc.view];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.scrollView]) return;
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - 事件方法
/**
 *  点击发布按钮
 */
- (void)publishButtonClick
{
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    } else {
        if (self.index == 0) {
            ODBazaarReleaseSkillViewController *releaseSkill = [[ODBazaarReleaseSkillViewController alloc] init];
            [self.navigationController pushViewController:releaseSkill animated:YES];
        } else {
            ODBazaarReleaseTaskViewController *releaseTask = [[ODBazaarReleaseTaskViewController alloc] init];
            releaseTask.isBazaar = YES;
            [self.navigationController pushViewController:releaseTask animated:YES];
        }
    }
}

- (void)changeController:(UIButton *)button
{
    self.index = button.od_x / (KScreenWidth * 0.5);
}

@end

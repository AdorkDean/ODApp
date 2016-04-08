//
//  ODTabBarController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODTabBar.h"
#import "ODTabBarController.h"
#import "ODNavigationController.h"

#import "ODHomeFindViewController.h"
#import "ODNewActivityCenterViewController.h"
#import "ODBazaarViewController.h"
#import "ODCommumityViewController.h"
//#import "ODLandMainController.h"

#import "ODPersonalCenterViewController.h"
#import "ODPersonalCenterController.h"

@interface ODTabBarController () <ODTabBarDelegate>

@end

@implementation ODTabBarController {
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSArray *_ctrlsArray;
}


#pragma mark - init

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self setTabBar];
}

- (void)createViewControllers {
    
    // 根据网络配置，显示不同的tabbar内容
    ODOtherConfigInfoModel *config = [[ODUserInformation sharedODUserInformation] getConfigCache];
    if (config == nil || config.auditing == 1) {
        _titleArray = @[@"欧动社区", @"中心活动", @"个人中心"];
        _imageArray = @[@"icon_community", @"icon_Center - activity",  @"icon_Personal Center"];
        _ctrlsArray = @[[[ODCommumityViewController alloc] init], [[ODNewActivityCenterViewController alloc] init],  [[ODPersonalCenterController alloc] init]];
    } else {
        _titleArray = @[@"首页发现", @"中心活动", @"欧动集市", @"欧动社区", @"个人中心"];
        _imageArray = @[@"icon_home-find", @"icon_Center - activity", @"icon_market", @"icon_community", @"icon_Personal Center"];
        _ctrlsArray = @[[[ODHomeFindViewController alloc] init], [[ODNewActivityCenterViewController alloc] init], [[ODBazaarViewController alloc] init], [[ODCommumityViewController alloc] init], [[ODPersonalCenterController alloc] init]];
    }
    
    for (NSInteger i = 0; i < _ctrlsArray.count; i++) {
        [self setupOneChildVc:[[ODNavigationController alloc] initWithRootViewController:_ctrlsArray[i]] image:[NSString stringWithFormat:@"%@_default", _imageArray[i]] selectedImage:[NSString stringWithFormat:@"%@_Selected", _imageArray[i]] title:_titleArray[i]];
    }
}

- (void)setTabBar {
    ODTabBar *tabBar = [[ODTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    tabBar.od_delegate = self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSInteger userCenterIndex = _titleArray.count - 1;
    self.selectedViewController = self.childViewControllers[selectedIndex];
    if (selectedIndex == userCenterIndex && [ODUserInformation sharedODUserInformation].openID.length == 0) return;
    self.currentIndex = selectedIndex;
}

- (void)setupOneChildVc:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title {
    childVc.tabBarItem.title = title;

    if (image.length) childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (selectedImage.length) childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:childVc];
}

#pragma mark - ODTabBarDelegate

- (void)od_tabBar:(ODTabBar *)od_tabBar selectIndex:(NSInteger)selectIndex {
    NSInteger userCenterIndex = _titleArray.count - 1;
    if (selectIndex == userCenterIndex && [ODUserInformation sharedODUserInformation].openID.length == 0) {
        self.selectedIndex = self.currentIndex;
        ODPersonalCenterViewController *perVC = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:perVC animated:YES completion:nil];
    }
    else {
        self.selectedIndex = selectIndex;
        if (selectIndex != userCenterIndex) {
            self.currentIndex = self.selectedIndex;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end

//
//  ODTabBarController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
#import "ODTabBar.h"
#import "ODTabBarController.h"
#import "ODNavigationController.h"

#import "ODHomeFoundViewController.h"
#import "ODCenterActivityViewController.h"
#import "ODBazaarViewController.h"
#import "ODCommumityViewController.h"
#import "ODLandMainController.h"

#import "ODPersonalCenterViewController.h"

@interface ODTabBarController ()<ODTabBarDelegate>

@end

@implementation ODTabBarController


#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createViewControllers];
    [self setTabBar];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBar layoutSubviews];
}

- (void)createViewControllers
{
    NSArray *titleArray = @[@"首页发现",@"中心活动",@"欧动集市",@"欧动社区",@"个人中心"];
    NSArray *imageArray = @[@"icon_home-find",@"icon_Center - activity",@"icon_market",@"icon_community",@"icon_Personal Center"];
    NSArray *controllers = @[[[ODHomeFoundViewController alloc]init],[[ODCenterActivityViewController alloc]init],[[ODBazaarViewController alloc]init],[[ODCommumityViewController alloc]init],[[ODLandMainController alloc]init]];
    for (NSInteger i = 0; i < controllers.count; i++)
    {
        [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:controllers[i]] image:[NSString stringWithFormat:@"%@_default",imageArray[i]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[i]] title:titleArray[i]];
    }
}

-(void)setTabBar
{
    ODTabBar *tabBar = [[ODTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    tabBar.od_delegate = self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.tabBar layoutSubviews];
    self.selectedViewController = self.childViewControllers[selectedIndex];
    if (selectedIndex == 4 && [ODUserInformation getData].openID.length == 0)        return;
    self.currentIndex = selectedIndex;
}

- (void)setupOneChildVc:(UIViewController *)childVc image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    childVc.tabBarItem.title = title;
            
    if (image.length) childVc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (selectedImage.length) childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:childVc];
}

#pragma mark - ODTabBarDelegate
- (void)od_tabBar:(ODTabBar *)od_tabBar selectIndex:(NSInteger)selectIndex
{
    if (selectIndex == 4 && [ODUserInformation getData].openID.length == 0)
    {
        self.selectedIndex = self.currentIndex;
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        self.selectedIndex = selectIndex;
        if (selectIndex != 4)
        {
            self.currentIndex = self.selectedIndex;
        }
    }
}

@end

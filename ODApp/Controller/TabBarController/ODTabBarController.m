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
    
    [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:[[ODHomeFoundViewController alloc]init]] image:[NSString stringWithFormat:@"%@_default",imageArray[0]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[0]] title:titleArray[0]];
    [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:[[ODCenterActivityViewController alloc]init]] image:[NSString stringWithFormat:@"%@_default",imageArray[1]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[1]] title:titleArray[1]];
    [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:[[ODBazaarViewController alloc]init]] image:[NSString stringWithFormat:@"%@_default",imageArray[2]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[2]] title:titleArray[2]];
    [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:[[ODCommumityViewController alloc]init]] image:[NSString stringWithFormat:@"%@_default",imageArray[3]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[3]] title:titleArray[3]];
    [self setupOneChildVc:[[ODNavigationController alloc]initWithRootViewController:[[ODLandMainController alloc]init]] image:[NSString stringWithFormat:@"%@_default",imageArray[4]] selectedImage:[NSString stringWithFormat:@"%@_Selected",imageArray[4]] title:titleArray[4]];
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
    if (selectIndex == 4 && [[ODUserInformation getData].openID isEqualToString:@""])
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

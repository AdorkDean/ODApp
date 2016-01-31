//
//  ODNavigationController.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationController.h"

@interface ODNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) id touchDelegate;

@end

@implementation ODNavigationController

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffd802" alpha:1]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    navigationBar.translucent = YES;
    navigationBar.hidden = YES;
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navigationBar setTitleTextAttributes:dictM];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _touchDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = self.childViewControllers.count > 0;
    [super pushViewController:viewController animated:animated];
}



@end

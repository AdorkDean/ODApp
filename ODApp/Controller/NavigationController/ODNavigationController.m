//
//  ODNavigationController.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationController.h"

@interface ODNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation ODNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.interactivePopGestureRecognizer.delegate = self;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    self.tabBarController.tabBar.hidden = NO;
    return vc;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"gestureRecgnizer = %@,,childControllers = %zd",gestureRecognizer,self.childViewControllers.count);
    
    return self.childViewControllers.count > 1;
}


@end

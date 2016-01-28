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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    _touchDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.childViewControllers[0])
    {
        self.interactivePopGestureRecognizer.delegate = _touchDelegate;
        self.tabBarController.tabBar.hidden = NO;
    }
}

@end

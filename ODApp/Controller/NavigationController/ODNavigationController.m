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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    _touchDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = self.childViewControllers.count > 0;
    [super pushViewController:viewController animated:animated];
}



@end

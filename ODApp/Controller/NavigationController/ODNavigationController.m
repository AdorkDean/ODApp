//
//  ODNavigationController.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationController.h"

@interface ODNavigationController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) id touchDelegate;

@end

@implementation ODNavigationController

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage OD_imageWithColor:[UIColor colorWithHexString:@"#ffd802" alpha:1]]
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
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 自己创建一个全屏手势,调用系统的滑动返回功能
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(popViewControllerAnimated:) color:nil highColor:nil title:@"返回"];
         viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.childViewControllers.count > 1;
}


@end

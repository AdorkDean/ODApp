//
//  ODBazaarReleaseTaskViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarReleaseTaskViewController.h"

@interface ODBazaarReleaseTaskViewController ()

@end

@implementation ODBazaarReleaseTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationInit];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    [self addTitleViewWithName:@"新任务"];
    [self addItemWithName:@"返回" target:self action:@selector(leftClick:) isLeft:YES];
    [self addItemWithName:@"确认" target:self action:@selector(rightClick:) isLeft:NO];
}

-(void)leftClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick:(UIButton *)button
{
    
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    ODTabBarController * tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

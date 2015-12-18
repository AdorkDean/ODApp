//
//  ODPersonalCenterViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODPersonalCenterViewController.h"

@interface ODPersonalCenterViewController ()

@end

@implementation ODPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    [self addTitleViewWithName:@"个人中心"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

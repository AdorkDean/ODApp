//
//  ODCenterActivityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterActivityViewController.h"

@interface ODCenterActivityViewController ()

@end

@implementation ODCenterActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    [self addTitleViewWithName:@"中心活动"];
    [self addItemWithName:@"场地预约" target:self action:@selector(rightClick:) isLeft:NO];
}

-(void)rightClick:(UIButton *)button
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

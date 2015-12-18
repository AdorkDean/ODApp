//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"

@interface ODCommumityViewController ()

@end

@implementation ODCommumityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    [self addTitleViewWithName:@"欧动社区"];
    [self addItemWithName:@"发布话题" target:self action:@selector(rightClick:) isLeft:NO];
}

-(void)rightClick:(UIButton *)button
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

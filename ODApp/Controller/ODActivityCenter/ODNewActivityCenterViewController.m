//
//  ODNewActivityCenterViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNewActivityCenterViewController.h"
#import "ODCenterActivityListViewController.h"

@interface ODNewActivityCenterViewController ()

@end

@implementation ODNewActivityCenterViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"中心活动列表";
    
    ODCenterActivityListViewController *centerVC = [ODCenterActivityListViewController new];
    [self.view addSubview:centerVC.tableView];
}



@end

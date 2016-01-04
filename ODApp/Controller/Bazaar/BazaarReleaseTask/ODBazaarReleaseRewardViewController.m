//
//  ODBazaarReleaseRewardViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarReleaseRewardViewController.h"

@interface ODBazaarReleaseRewardViewController ()

@end

@implementation ODBazaarReleaseRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationInit];
    [self createRequest];
    [self createTaskRewardLabel];
    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"新任务" font:16 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //返回按钮
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28,35, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 28,35, 20) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmButtonClick:(UIButton *)button
{
    
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

#pragma mark - 创建任务奖励试图
-(void)createTaskRewardLabel
{
    self.taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 68, kScreenSize.width - 8, 34) text:@"  选择任务奖励" font:16 alignment:@"left" color:@"#b0b0b0"  alpha:1 maskToBounds:YES];
    self.taskRewardLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.view addSubview:self.taskRewardLabel];
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(kScreenSize.width - 8 - 30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.taskRewardLabel addSubview:lineView];
    
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 8 - 25, 10, 20, 14) target:self sel:@selector(taskRewardButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.taskRewardLabel addSubview:button];
}

-(void)taskRewardButtonClick:(UIButton *)button
{
    
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
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
}



@end

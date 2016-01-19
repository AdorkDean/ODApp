//
//  ODCenterIntroduceController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODCenterIntroduceController.h"




@interface ODCenterIntroduceController ()

@property (nonatomic, strong)ODHomeFoundViewController *homeDetail;


@end


@implementation ODCenterIntroduceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navigationInit];
    [self createWebView];
}

- (void)viewWillAppear:(BOOL)animated
{

    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

- (void)navigationInit
{

    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 180) / 2, 28, 180, 20) text:self.activityTitle font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    

    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16, 44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:backButton];
}

- (void)backButtonClick:(UIButton *)button
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createWebView
{

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

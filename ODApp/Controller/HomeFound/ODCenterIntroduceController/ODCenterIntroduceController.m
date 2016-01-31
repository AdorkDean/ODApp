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
    self.title = self.activityTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}


- (void)navigationInit
{

    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
  
    

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

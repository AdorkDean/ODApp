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
    self.navigationItem.title = self.activityTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
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

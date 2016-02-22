//
//  ODFindJobController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODFindJobController.h"

@interface ODFindJobController ()

@end

@implementation ODFindJobController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"找兼职";

    [self createWebView];
}

- (void)createWebView
{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];

    NSString *store_id = @"2";
    
    self.webUrl = [NSString stringWithFormat:@"%@?access_token=%@&store_id=%@&open_id=%@",ODFindJobUrl ,[ODUserInformation sharedODUserInformation].openID, store_id, [ODUserInformation sharedODUserInformation].openID];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ODFindJobController.m
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODFindJobController.h"

@interface ODFindJobController ()

@end

@implementation ODFindJobController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"找兼职";

    [self createWebView];
}

- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.webView.delegate = self;
    NSString *store_id = @"2";
    self.webUrl = [NSString stringWithFormat:@"%@?access_token=%@&store_id=%@&open_id=%@", ODFindJobUrl, [ODUserInformation sharedODUserInformation].openID, store_id, [ODUserInformation sharedODUserInformation].openID];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ODProgressHUD showProgressIsLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ODProgressHUD dismiss];
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end

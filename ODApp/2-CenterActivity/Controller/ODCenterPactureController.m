//
//  ODCenterPactureController.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCenterPactureController.h"
#import "ODTabBarController.h"

@interface ODCenterPactureController () <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *web;


@end

@implementation ODCenterPactureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.activityName;
    [self initWebView];
}


- (void)initWebView {
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 50)];
    self.web.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];

    [self.web loadRequest:request];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ODProgressHUD showProgressIsLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ODProgressHUD dismiss];
    [self.view addSubview:self.web];
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

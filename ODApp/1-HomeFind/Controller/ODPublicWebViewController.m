//
//  ODPublicWebViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPublicWebViewController.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>

@interface ODPublicWebViewController ()<UIWebViewDelegate>

@end

@implementation ODPublicWebViewController

#pragma mark - set方法和懒加载

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    self.navigationItem.title = navigationTitle;
}

- (void)setWebUrl:(NSString *)webUrl
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
}

- (void)setIsShowProgress:(BOOL)isShowProgress
{
    if (isShowProgress)
    {
        self.webView.delegate = self;
    }
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
        if (self.bgColor != nil) {
            _webView.backgroundColor = self.bgColor;
        } else {
            _webView.backgroundColor = [UIColor backgroundColor];
        }
        [self.view addSubview:self.webView];
    }
    return _webView;
}

#pragma mark - lifeCycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [ODProgressHUD showProgressIsLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [ODProgressHUD dismiss];
}

@end

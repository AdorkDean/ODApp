//
//  ODFindFavorableController.m
//  ODApp
//
//  Created by Bracelet on 16/2/20.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODFindFavorableController.h"

@interface ODFindFavorableController ()

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) NSString *webUrl;

@end

@implementation ODFindFavorableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"敬请期待";

    [self createWebView];
}

- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];

    self.webUrl = @"http://h5.odong.com/woqu/expect";

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
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

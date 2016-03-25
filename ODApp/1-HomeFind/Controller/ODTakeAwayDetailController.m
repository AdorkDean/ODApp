//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>

#import "ODTakeAwayDetailController.h"

@interface ODTakeAwayDetailController ()


@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;


@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"饮料";
    self.view = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight)];
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://h5.test.odong.com/native/order?id=1"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)createWebView {
    
    
    NSString *webUrl = @"http://h5.test.odong.com/native/order?id=1";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    [self.view addSubview:self.webView];
}


@end

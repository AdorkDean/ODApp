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

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *shopCartButton;

@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"饮料";
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
    self.view = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - 50)];
    
    NSString *webUrl = @"www.baidu.com";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    [self.view addSubview:self.webView];
}

#pragma mark - LazyLoad

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(100, KScreenHeight - 50, KScreenWidth - 100, 50)];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buyButton];
    }
    return _buyButton;
}

- (UIButton *)shopCartButton {
    if (!_shopCartButton) {
        _shopCartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, 100, 50)];
        _shopCartButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_shopCartButton setTitle:@"购物车" forState:UIControlStateNormal];
        [_shopCartButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
        [_shopCartButton addTarget:self action:@selector(shopCartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shopCartButton];
    }
    return _buyButton;
}

#pragma mark - Action

- (void)buyButtonAction:(UIButton *)sender {

    
}

- (void)shopCartButtonAction:(UIButton *)sender {
    
    
}


@end

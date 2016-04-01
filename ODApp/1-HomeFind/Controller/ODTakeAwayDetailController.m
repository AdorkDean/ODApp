//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "ODTakeAwayDetailController.h"

#import <Masonry.h>
#import "ODHttpTool.h"
#import "ODUserInformation.h"
#import "ODAPPInfoTool.h"

#import "ODShopCartView.h"

@interface ODTakeAwayDetailController ()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.takeAwayTitle;
    [self createWebView];
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    
    // 订单详情页
    if (self.isOrderDetail) {
        NSString *urlString = [[ODHttpTool getRequestParameter:@{ @"order_id" : self.order_id}]od_URLDesc];
        NSString *url = [ODWebUrlNativeOrderInfo stringByAppendingString:urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
    }
    // 商品详情页
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
        [self setupShopCart];
    }    
}

#pragma mark - Create UIWebView
- (void)createWebView {
    float footHeight = 0;
    if (!self.isOrderDetail) {
        footHeight = 49;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - footHeight)];
    [self.view addSubview:self.webView];
}


#pragma mark - 购物车
- (void)setupShopCart
{
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    [self.view addSubview:shopCart];
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(49);
    }];
}
@end

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
    [self setupShopCart];
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    if (self.isCart) {
        NSString *urlString = [[ODHttpTool getRequestParameter:@{@"open_id":@"766148455eed214ed1f8"}]od_URLDesc];
        NSString *url = [ODWebUrlNativeCart stringByAppendingString:urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=1", ODWebUrlNative]]]];
    }    
}

- (void)setupShopCart
{
    ODShopCartView *shopCart = [ODShopCartView shopCart];
    [self.view addSubview:shopCart];
    [shopCart makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(55);
    }];
}
@end

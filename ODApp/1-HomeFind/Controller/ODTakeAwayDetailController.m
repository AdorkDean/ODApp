//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeAwayDetailController.h"

#import "ODHttpTool.h"
#import "ODUserInformation.h"
#import "ODAPPInfoTool.h"

@interface ODTakeAwayDetailController ()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.takeAwayTitle;
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    if (self.isCart) {
        NSString *urlString = [[ODHttpTool getRequestParameter:@{@"open_id":@"766148455eed214ed1f8"}]od_URLDesc];
        NSString *url = [NSString stringWithFormat:@"%@?%@", ODWebUrlNativeCart,urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:url]]];
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:@"http://h5.test.odong.com/native/cart?city_id=321&device_id=test&platform=android&platform_version=5.1.0&channel=xiaomi&app_version=1.0.1&network_type=wifi&latitude=31.2379598551&longitude=121.5392227367&open_id=766148455eed214ed1f8"]]];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
    }    
}


@end

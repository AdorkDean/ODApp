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
//        NSString *url1 = [NSString stringWithFormat:@"%@?%@", ODWebUrlNativeCart,urlString];
        NSString *url1 = [ODWebUrlNativeCart stringByAppendingString:urlString];
        NSString *url = @"http://h5.test.odong.com/native/cart?app_version=1.0&platform_version=&device_id=&channel=appstore&city_id=321&platform=iphone&latitude=&longitude=&network_type=&open_id=766148455eed214ed1f8";
        
        url1 = [url1	stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *strUrl = [url1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        BOOL result = [url isEqualToString:url1];
        
        
        NSURL *url2 = [NSURL OD_URLWithString:urlString];
        
        NSLog(@"%@", url);
        NSLog(@"%@", url1);
        
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:strUrl]]];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
    }    
}


@end

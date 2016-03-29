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
//        NSString *city_id = [NSString stringWithFormat:@"city_id=%@",[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].openID]];
//        NSString *platform = @"platform=iphone";
//        NSString *channel = @"channel=appstore";
//        NSString *app_version = [NSString stringWithFormat:@"app_version=%@", [ODAPPInfoTool APPVersion]];
//        NSString *open_id = [NSString stringWithFormat:@"open_id=%@", [NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].openID]];
        NSString *open_id = @"766148455eed214ed1f8";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@?open_id=%@", ODWebUrlNativeCart, open_id]]]];
        
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
    }    
}


@end

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
        NSString *urlString = [[ODHttpTool getRequestParameter:@{}]od_URLDesc];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@?%@", ODWebUrlNativeCart,urlString]]]];
    }
    else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", ODWebUrlNative, self.product_id]]]];
    }    
}


@end

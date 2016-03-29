//
//  ODTakeAwayDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeAwayDetailController.h"

@interface ODTakeAwayDetailController ()
@property (nonatomic, strong) PontoDispatcher *pontoDispatcher;
@end

@implementation ODTakeAwayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.takeAwayTitle;
    
    self.pontoDispatcher = [[PontoDispatcher alloc] initWithHandlerClassesPrefix:@"Ponto" andWebView:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order?id=%@", ODWebUrlNative, self.product_id]]]];
}


@end

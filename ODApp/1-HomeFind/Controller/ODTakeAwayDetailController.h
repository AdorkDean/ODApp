//
//  ODTakeAwayDetailController.h
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "PontoDispatcher.h"

@interface ODTakeAwayDetailController : UIViewController <PontoDispatcherCallbackDelegate>

@property (nonatomic,strong) UIWebView *webView;


@end

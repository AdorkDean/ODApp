//
//  ODTakeAwayDetailController.h
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PontoDispatcher.h"

@interface ODTakeAwayDetailController : UIViewController<PontoDispatcherCallbackDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end


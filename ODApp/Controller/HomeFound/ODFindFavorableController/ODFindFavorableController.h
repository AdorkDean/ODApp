//
//  ODFindFavorableController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"

#import "AFNetworking.h"

#import "ODUserInformation.h"
#import "ODAPIManager.h"

@interface ODFindFavorableController : ODBaseViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSString *webUrl;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;


@end

//
//  ODFindJobController.h
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"


#import "ODUserInformation.h"
#import "ODAPIManager.h"


@interface ODFindJobController : ODBaseViewController <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) NSString *webUrl;



@end

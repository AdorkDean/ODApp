//
//  ODCenterIntroduceController.h
//  ODApp
//
//  Created by Bracelet on 16/1/6.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODClassMethod.h"
#import "ODTabBarController.h"
#import "ODHomeFoundViewController.h"
#import "ODCenterIntroduceModel.h"



@interface ODCenterIntroduceController : ODBaseViewController

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, strong) NSString *activityTitle;
@property(nonatomic, strong) NSString *webUrl;


@end

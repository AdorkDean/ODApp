//
//  ODCenterIntroduceController.h
//  ODApp
//
//  Created by 代征钏 on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODTabBarController.h"
#import "ODAPIManager.h"
#import "ODHomeFoundViewController.h"
#import "ODCenterIntroduceModel.h"

#import "AFNetworking.h"


@interface ODCenterIntroduceController : ODBaseViewController

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong)NSString *activityTitle;
@property (nonatomic, strong)NSString *webUrl;


@end

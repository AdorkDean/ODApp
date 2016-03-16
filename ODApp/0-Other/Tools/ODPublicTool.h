//
//  ODPublicTool.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/11.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODProgressHUD.h"
#import "WXApi.h"
#import "UMSocial.h"

@interface ODPublicTool : NSObject

+(void)shareAppWithTarget:(id)target dictionary:(NSDictionary *)dict controller:(UIViewController *)controller;

@end

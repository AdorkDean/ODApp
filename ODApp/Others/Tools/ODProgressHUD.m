//
//  ODProgressHUD.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODProgressHUD.h"
#import <SVProgressHUD.h>

@implementation ODProgressHUD
+ (void)initialize
{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeBlack)];
}

+ (void)showProgressIsLoading
{
    [self showProgressWithStatus:ODAlertIsLoading];
}

+ (void)showProgressWithStatus:(NSString *)status
{
    [SVProgressHUD showWithStatus:status];
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [SVProgressHUD showErrorWithStatus:status];
}



+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

@end

//
//  ODProgressHUD.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

//#define SV_APP_EXTENSIONS


#import "ODProgressHUD.h"
#import <SVProgressHUD.h>
#import <UIView+Toast.h>

@implementation ODProgressHUD
#pragma mark - 蒙版提示语
NSString * const ODAlertIsLoading = @"正在加载。。。";

+ (void)initialize
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
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

+ (void)showToast:(UIView *)view msg:(NSString *)msg
{
    CGPoint center = CGPointMake(view.frame.size.width / 2, view.frame.size.height - 100);
    [view makeToast:msg duration:3 position:[NSValue valueWithCGPoint:center]];
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

//- (void)createProgressHUDWithAlpha:(float)alpha withAfterDelay:(float)afterDelay title:(NSString *)title
//{
//    
//    self.HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    
//    self.HUD.delegate  = self;
//    
//    self.HUD.color = [UIColor colorWithHexString:@"#000000" alpha:alpha];
//    self.HUD.mode = MBProgressHUDModeText;
//    self.HUD.labelText = title;
//    
//    self.HUD.margin = 10.f;
//    self.HUD.yOffset = 150.f;
//    self.HUD.removeFromSuperViewOnHide = YES;
//    [self.HUD hide:YES afterDelay:afterDelay];
//    
//}

@end

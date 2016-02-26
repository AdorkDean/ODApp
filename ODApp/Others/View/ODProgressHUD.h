//
//  ODProgressHUD.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODProgressHUD : NSObject

/**
 *  网络正在请求
 */
+ (void)showProgressIsLoading;

/**
 *  网络正在请求的信息
 */
+ (void)showProgressWithStatus:(NSString *)status;

/**
 *  提示信息
 */
+ (void)showInfoWithStatus:(NSString *)status;

/**
 *  成功提示信息
 */
+ (void)showSuccessWithStatus:(NSString *)status;

/**
 *  失败提示信息
 */
+ (void)showErrorWithStatus:(NSString *)status;

/**
 *  让进度条消失
 */
+ (void)dismiss;

@end

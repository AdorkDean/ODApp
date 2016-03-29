//
//  H5ToMobileRequest.m
//  ODApp
//
//  Created by Bracelet on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "PontoH5ToMobileRequest.h"

#import "ODHttpTool.h"

#import "ODUserInformation.h"

#import "ODPersonalCenterViewController.h"
#import "ODBuyTakeOutViewController.h"


@implementation PontoH5ToMobileRequest {
}


+ (id)instance {
    
    return [[self alloc] init];
}

#pragma mark - 直接购买
- (void)buyNow:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", params);
        NSLog(@"%@",params[@"id"]);
        [self buyNowRequestData:params[@"id"]];
        
        UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navVc = tabBarVc.selectedViewController;
        
        if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
            ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
            [navVc presentViewController:vc animated:YES completion:nil];
        }
        else {
            ODBuyTakeOutViewController *vc = [[ODBuyTakeOutViewController alloc] init];
            [navVc pushViewController:vc animated:YES];
        }
    }
}

- (void)buyNowRequestData:(NSString *)paramasId {
    NSDictionary *parameter = @{
                                @"object_type" : @"1",
                                @" object_id" :[NSString stringWithFormat:@"%@", paramasId]
                                };
    [ODHttpTool getWithURL:ODUrlShopcartOrder parameters:parameter modelClass:[NSObject class] success:^(id model) {
        NSLog(@"12333333");
    }
                   failure:^(NSError *error) {
                       
                   }];
}

#pragma mark - 购物车
- (void)orderNow:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"params ------->  %@", params);
        [self orderNowRequestData:params];
        
        UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navVc = tabBarVc.selectedViewController;
        ODBuyTakeOutViewController *vc = [[ODBuyTakeOutViewController alloc] init];
        [navVc pushViewController:vc animated:YES];
    }
}

- (void)orderNowRequestData:(NSString *)paramasId {
    NSDictionary *parameter = @{
                                @"object_type" : @"1",
                                @" object_id" :[NSString stringWithFormat:@"%@", paramasId]
                                };
    [ODHttpTool getWithURL:ODUrlShopcartOrder parameters:parameter modelClass:[NSObject class] success:^(id model) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end

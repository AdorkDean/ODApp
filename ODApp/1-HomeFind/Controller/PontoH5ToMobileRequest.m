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

- (void)buyNow:(id)params {
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@", params);
        NSLog(@"%@",params[@"id"]);
        [self getRequestData:params[@"id"]];
        
        UITabBarController *tabBarVc = (id)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *navVc = tabBarVc.selectedViewController;
        
        if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
            ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
            [navVc presentViewController:vc animated:YES completion:nil];
        }
        else {
//            UIViewController *vc = [UIViewController new];
            ODBuyTakeOutViewController *vc = [[ODBuyTakeOutViewController alloc] init];
            vc.title = @"123";
            vc.view.backgroundColor = [UIColor randomColor];            
            [navVc pushViewController:vc animated:YES];
        }
    }
}

- (void)getRequestData:(NSString *)paramas{
    NSDictionary *parameter = @{
                                @"object_type" : @"1",
                                @" object_id" :[NSString stringWithFormat:@"%@", paramas]
                                };
    [ODHttpTool getWithURL:ODUrlShopcartOrder parameters:parameter modelClass:[NSObject class] success:^(id model) {
        NSLog(@"12333333");
    }
    failure:^(NSError *error) {
    
    }];
}


@end

//
//  ODMyOrderDetailModel.m
//  ODApp
//
//  Created by Bracelet on 16/1/11.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODMyOrderDetailModel.h"

@implementation ODMyOrderDetailDevicesModel


@end

@implementation ODMyOrderDetailModel

+ (void)initialize
{

    [ODMyOrderDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        
        return @{
                 @"devices":[ODMyOrderDetailDevicesModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryAll(ODMyOrderDetailModel)
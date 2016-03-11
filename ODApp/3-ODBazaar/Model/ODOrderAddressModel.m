//
//  ODOrderAddressModel.m
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderAddressModel.h"

@implementation ODOrderAddressDefModel

@end

@implementation ODOrderAddressModel
+ (void)initialize
{
    [ODOrderAddressModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list":[ODOrderAddressDefModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryAll(ODOrderAddressModel)
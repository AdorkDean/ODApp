//
//  ODMyTakeOutModel.m
//  ODApp
//
//  Created by 王振航 on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyTakeOutModel.h"

@implementation ODMyTakeOutProductsModel

@end

@implementation ODMyTakeOutModel

+ (void)initialize
{
    [ODMyTakeOutModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"products" :[ODMyTakeOutProductsModel class]
                 };
    }];
}

@end

ODRequestResultIsArrayAll(ODMyTakeOutModel)

ODRequestResultIsDictionaryProperty(ODMyTakeOutProductsModel)
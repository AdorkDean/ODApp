//
//  ODBuyTakeOutModel.m
//  ODApp
//
//  Created by 王振航 on 16/3/28.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBuyTakeOutModel.h"


@implementation ODBuyTakeOutProductsModel

@end


@implementation ODBuyTakeOutModel

+ (void)initialize
{
    [ODBuyTakeOutModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"products" :[ODBuyTakeOutProductsModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryAll(ODBuyTakeOutModel)

ODRequestResultIsDictionaryProperty(ODBuyTakeOutProductsModel)

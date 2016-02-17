//
//  ODLocationModel.m
//  ODApp
//
//  Created by 代征钏 on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODLocationModel.h"

@implementation ODLocationModel

+ (void)initialize
{

    [ODLocationModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"dis1play":[ODCityNameModel class]
                 
                 };
    }];
}


@end

ODRequestResultIsDictionaryImplementation(ODLocationModel)

@implementation ODCityNameModel


@end
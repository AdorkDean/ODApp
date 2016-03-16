//
//  ODLocationModel.m
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODLocationModel.h"

@implementation ODLocationModel

+ (void)initialize
{

    [ODLocationModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"all":[ODCityNameModel class]
                 
                 };
    }];
}


@end

ODRequestResultIsDictionaryImplementation(ODLocationModel)

@implementation ODCityNameModel


@end
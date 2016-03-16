//
//  ODHomeInfoModel.m
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODHomeInfoModel.h"
#import "ODBazaarExchangeSkillModel.h"

@implementation ODHomeInfoModel
+ (void)initialize
{
    [ODHomeInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"swaps" :[ODBazaarExchangeSkillModel class],
                 @"activitys" :[ODHomeInfoActivitiesModel class]
                 };
    }];

}
@end
ODRequestResultIsDictionaryImplementation(ODHomeInfoModel)

@implementation ODHomeInfoActivitiesModel

@end


@implementation ODHomeInfoSwapModel


@end
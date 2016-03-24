//
//  ODStoreTimelineModel.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODStoreTimelineModel.h"

@implementation ODStoreTimelineCaoModel

@end

@implementation ODStoreTimelineModel

+ (void)initialize
{
    [ODStoreTimelineModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                    @"cao":[ODStoreTimelineCaoModel class]
                 };
    }];
}

@end

ODRequestResultIsArrayAll(ODStoreTimelineModel)


//
//  ODCommunityDetailInfoModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/9.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCommunityDetailInfoModel.h"

ODRequestModelImplementation(ODCommunityDetailInfoImgs_bigModel)


@implementation ODCommunityDetailInfoModel

+ (void)initialize
{
    [ODCommunityDetailInfoModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"imgs_big" :[ODCommunityDetailInfoImgs_bigModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryImplementation(ODCommunityDetailInfoModel)

//
//  ODActivityDetailModel.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityDetailModel.h"

@implementation ODActivityDetailAppliesModel


@end

@implementation ODActivityDetailVIPModel


@end

@implementation ODActivityDetailModel

+ (void)initialize
{
    
    [ODActivityDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"savants" :[ODActivityDetailVIPModel class],
                 @"applies" :[ODActivityDetailAppliesModel class]
        };
    }];
}

@end


ODRequestResultIsDictionaryImplementation(ODActivityDetailModel)
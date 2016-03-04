//
//  ODReleaseModel.m
//  ODApp
//
//  Created by Bracelet on 16/2/18.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODReleaseModel.h"

@implementation ODReleaseModel

+ (void)initialize
{

    [ODReleaseModel mj_setupObjectClassInArray:^NSDictionary *{

        return @{
                 @"img_small":[ODReleaseLovesModel class]
                 
                 };
    }];
}


@end
ODRequestResultIsArrayImplementation(ODReleaseModel)

@implementation ODReleaseLovesModel


@end
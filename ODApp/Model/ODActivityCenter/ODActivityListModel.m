//
//  ODActivityListModel.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODActivityListModel.h"

@implementation ODActivityListModel

@end


@implementation ODActivityListResultModel

+ (void)initialize
{
    [ODActivityListResultModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"result" : [ODActivityListModel class]
                 };
    }];
}

@end
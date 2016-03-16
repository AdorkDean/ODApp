//
//  ODOrderDataModel.m
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderDataModel.h"

@implementation ODOrderDataTimesModel


@end

@implementation ODOrderDataModel

+ (void)initialize {

    [ODOrderDataModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"times" : [ODOrderDataTimesModel class]
                 };
        
    }];
}

@end

ODRequestResultIsArrayAll(ODOrderDataModel)
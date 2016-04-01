//
//  ODTakeOutConfirmModel.m
//  ODApp
//
//  Created by Bracelet on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeOutConfirmModel.h"

@implementation odTakeOUtConfirmProductsModel

@end

@implementation ODTakeOutConfirmModel

+ (void)initialize
{
    [ODTakeOutConfirmModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"products" :[odTakeOUtConfirmProductsModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryAll(ODTakeOutConfirmModel)

ODRequestResultIsDictionaryProperty(odTakeOUtConfirmProductsModel)
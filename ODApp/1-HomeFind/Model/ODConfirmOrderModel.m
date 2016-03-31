//
//  ODConfirmOrderModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODConfirmOrderModel.h"

ODRequestModelImplementation(ODConfirmOrderModelShopcart_list)

@implementation ODConfirmOrderModel

+ (void)initialize
{
    [ODConfirmOrderModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"shopcart_list":[ODConfirmOrderModelShopcart_list class]
                 };
    }];
}
@end

ODRequestResultIsDictionaryImplementation(ODConfirmOrderModel)
//
//  ODBazaarExchangeSkillModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarExchangeSkillModel.h"

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_smallModel)

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_bigModel)

@implementation ODBazaarExchangeSkillModel

+ (void)initialize
{
    [ODBazaarExchangeSkillModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"imgs_small" :[ODBazaarExchangeSkillImgs_smallModel class],
                 @"imgs_big" :[ODBazaarExchangeSkillImgs_bigModel class]
                 };
    }];
}

@end

ODRequestResultIsArrayImplementation(ODBazaarExchangeSkillModel)

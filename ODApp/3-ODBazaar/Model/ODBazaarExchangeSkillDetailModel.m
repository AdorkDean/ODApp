//
//  ODBazaarExchangeSkillDetailModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarExchangeSkillDetailModel.h"

ODRequestModelImplementation(ODBazaarExchangeSkillDetailImgs_smallModel)

ODRequestModelImplementation(ODBazaarExchangeSkillDetailImgs_bigModel)

@implementation ODBazaarExchangeSkillDetailModel

+ (void)initialize
{
    [ODBazaarExchangeSkillDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"imgs_small" :[ODBazaarExchangeSkillDetailImgs_smallModel class],
                 @"imgs_big" :[ODBazaarExchangeSkillDetailImgs_bigModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryAll(ODBazaarExchangeSkillDetailModel)

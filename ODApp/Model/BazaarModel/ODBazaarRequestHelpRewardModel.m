//
//  ODBazaarRequestHelpRewardModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/9.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarRequestHelpRewardModel.h"

ODRequestModelImplementation(ODBazaarRequestHelpTask_rewardModel)

@implementation ODBazaarRequestHelpRewardModel

+ (void)initialize
{
    [ODBazaarRequestHelpRewardModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"task_reward" :[ODBazaarRequestHelpTask_rewardModel class]
                 };
    }];
}

@end

ODRequestResultIsDictionaryImplementation(ODBazaarRequestHelpRewardModel)

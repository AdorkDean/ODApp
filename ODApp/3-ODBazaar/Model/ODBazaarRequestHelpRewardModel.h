//
//  ODBazaarRequestHelpRewardModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/9.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBazaarRequestHelpTask_rewardModel : NSObject

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int type;

@end

@interface ODBazaarRequestHelpRewardModel : NSObject

@property (nonatomic, copy) NSString *wx_ticket;

@property (nonatomic, copy) NSString *wx_access_token;

@property (nonatomic, strong) NSArray *task_reward;

@property (nonatomic, strong) NSDictionary *experience_center;

@end

ODRequestResultIsDictionaryProperty(ODBazaarRequestHelpRewardModel)
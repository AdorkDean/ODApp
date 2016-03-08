//
//  ODBazaarRequestHelpModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarRequestHelpModel.h"

@implementation ODBazaarRequestHelpTasksModel

@end

@implementation ODBazaarRequestHelpModel

+ (void)initialize
{
    [ODBazaarRequestHelpModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"tasks":[ODBazaarRequestHelpTasksModel class]
                 };
    }];
}
@end

ODRequestResultIsDictionaryImplementation(ODBazaarRequestHelpModel)

//
//  ODBazaarModel.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarModel.h"

@implementation ODBazaarModel

@end

@implementation ODBazaarTasksModel
+ (void)initialize
{
    [ODBazaarTasksModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"tasks":[ODBazaarModel class]
                 };
    }];
}
@end

ODRequestResultIsDictionaryAll(ODBazaarTasksModel)
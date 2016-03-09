//
//  ODCommunityBbsModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCommunityBbsModel.h"

ODRequestModelImplementation(ODCommunityBbsListModel)

ODRequestModelImplementation(ODCommunityBbsUsersModel)



@implementation ODCommunityBbsModel

+ (void)initialize
{
    [ODCommunityBbsModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bbs_list":[ODCommunityBbsListModel class]
                 };
    }];
}
@end

ODRequestResultIsDictionaryImplementation(ODCommunityBbsModel)
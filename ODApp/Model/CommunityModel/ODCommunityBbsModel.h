//
//  ODCommunityBbsModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODCommunityBbsUsersModel : NSObject

@property (nonatomic, assign) int gender;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *avatar_url;

@end

@interface ODCommunityBbsListModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int reply_num;

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, assign) int user_id;

@property (nonatomic, assign) int view_num;

@property (nonatomic, strong) NSArray *imgs_big;

@property (nonatomic, strong) NSArray *tags;

@end

@interface ODCommunityBbsModel : NSObject

@property (nonatomic, strong) NSArray *bbs_list;

@property (nonatomic, strong) NSDictionary *users;

@end

ODRequestResultIsDictionaryProperty(ODCommunityBbsModel)


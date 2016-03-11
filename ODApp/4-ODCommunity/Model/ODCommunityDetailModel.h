//
//  ODCommunityDetailModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/28.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//


@interface ODCommunityDetailModel : NSObject

@property (nonatomic, assign) int bbs_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) int id;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) int floor;

@property (nonatomic, copy) NSString *parent_user_nick;

@property (nonatomic, assign) int parent_id;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, assign) int user_id;

@property (nonatomic, strong) NSDictionary *user;

@end

ODRequestResultIsArrayProperty(ODCommunityDetailModel)

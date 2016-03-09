//
//  ODCommunityDetailInfoModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/9.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODCommunityDetailInfoImgs_bigModel : NSObject

@property (nonatomic, assign) float y;

@property (nonatomic, assign) float rat;

@property (nonatomic, assign) float x;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *img_url;

@end

@interface ODCommunityDetailInfoModel : NSObject

@property (nonatomic, assign) int share_num;

@property (nonatomic, strong) NSArray *bbs_imgs;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) int city_id;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, assign) int user_id;

@property (nonatomic, copy) NSString *violation_reason;

@property (nonatomic, copy) NSString *updated_at;

@property (nonatomic, assign) int swap_type;

@property (nonatomic, strong) NSDictionary *share;

@property (nonatomic, assign) int swap_status;

@property (nonatomic, assign) int bbs_reward_id;

@property (nonatomic, strong) NSArray *imgs_big;

@property (nonatomic, assign) int type;

@property (nonatomic, assign) int id;

@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, assign) int bbs_status;

@property (nonatomic, copy) NSString *bbs_reward_name;

@property (nonatomic, assign) int view_num;

@property (nonatomic, assign) int task_status;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, assign) int task_type;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, assign) int love_num;

@property (nonatomic, assign) int price;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) int love_id;

@end

ODRequestResultIsDictionaryProperty(ODCommunityDetailInfoModel)

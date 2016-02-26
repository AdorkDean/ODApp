//
//  ODActivityDetailModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODActivityDetailAppliesModel : NSObject

@property (nonatomic, assign) int gender;

@property (nonatomic, strong) NSString *nick;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, assign) int id;

@property (nonatomic, strong) NSString *open_id;

@property (nonatomic, strong) NSString *sign;

@property (nonatomic, strong) NSString *avatar_url;

@end

@interface ODActivityDetailVIPModel : NSObject

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *nick;

@property (nonatomic, assign) int gender;

@property (nonatomic, strong) NSString *sign;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *open_id;

@property (nonatomic, assign) int user_auth_status;

@property (nonatomic, strong) NSString *profile;

@property (nonatomic, strong) NSString *school_name;

@end


@interface ODActivityDetailModel : NSObject

@property (nonatomic, assign) int love_cnt;

@property (nonatomic, strong) NSString *time_str;

@property (nonatomic, copy) NSArray *replies;

@property (nonatomic, strong) NSString *apply_time_str;

@property (nonatomic, assign) int is_online;

@property (nonatomic, assign) int activity_id;

@property (nonatomic, assign) int love_id;

@property (nonatomic, strong) NSString *icon_url;

@property (nonatomic, assign) int apply_cnt;

@property (nonatomic, strong) NSString *apply_status_str;

@property (nonatomic, strong) NSString *lng;

@property (nonatomic, assign) int store_id;

@property (nonatomic, strong) NSString *store_name;

@property (nonatomic, assign) int browse_num;

@property (nonatomic, assign) int share_cnt;

@property (nonatomic, strong) NSString *store_address;

@property (nonatomic, strong) NSString *contact_info;

@property (nonatomic, strong) NSString *organization_name;

@property (nonatomic, strong) NSString *lat;

@property (nonatomic, strong) NSArray *savants;

@property (nonatomic, assign) int apply_status;

@property (nonatomic, strong) NSArray *applies;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, assign) int need_verify;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSMutableDictionary *share;

@end

ODRequestResultIsDictionaryProperty(ODActivityDetailModel)


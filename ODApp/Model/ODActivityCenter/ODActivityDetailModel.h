//
//  ODActivityDetailModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODActivityDetailModel : NSObject

@property (nonatomic, assign) int love_cnt;

@property (nonatomic, strong) NSString *time_str;

@property (nonatomic, copy) NSArray *replies;

@property (nonatomic, strong) NSString *apply_time_str;

@property (nonatomic, assign) int is_online;

@property (nonatomic, assign) int activity_id;

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

@property (nonatomic, assign) NSArray *savants;

@property (nonatomic, assign) int apply_status;

@property (nonatomic, strong) NSArray *applies;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, assign) int need_verify;

@property (nonatomic, strong) NSString *content;

@end

ODRequestResultIsDictionaryProperty(ODActivityDetailModel)


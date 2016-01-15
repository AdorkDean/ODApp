//
//  ActivityModel.h
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic , assign) NSInteger activity_id;
@property (nonatomic , copy) NSString *content;
@property (nonatomic , copy) NSString *icon_url;
@property (nonatomic , assign) NSInteger store_id;
@property (nonatomic , copy) NSString *store_name;
@property (nonatomic , copy) NSString *store_address;
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , assign) NSInteger browse_num;
@property (nonatomic , assign) NSInteger apply_cnt;
@property (nonatomic , copy) NSString *start_time;
@property (nonatomic , copy) NSString *end_time;
@property (nonatomic , copy) NSString *apply_start_time;
@property (nonatomic , copy) NSString *apply_end_time;
@property (nonatomic , assign) NSInteger apply_status;
@property (nonatomic , copy) NSString *reason;
@property (nonatomic , assign) NSInteger need_verify;
@property (nonatomic , copy) NSString *contact_info;
@property (nonatomic , copy) NSString *lng;
@property (nonatomic , copy) NSString *lat;


-(instancetype)initWithDict:(NSDictionary *)dict;

@end

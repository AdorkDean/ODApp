//
//  ActivityModel.m
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        self.activity_id = [dict[@"activity_id"] integerValue];
        self.content = dict[@"content"];
        self.icon_url = dict[@"icon_url"];
        self.store_id = [dict[@"store_id"] integerValue];
        self.store_address = dict[@"store_address"];
        self.store_name = dict[@"store_name"];
        self.remark = dict[@"remark"];
        self.browse_num = [dict[@"browse_num"] integerValue];
        self.apply_cnt = [dict[@"apply_cnt"] integerValue];
        self.start_time = dict[@"start_time"];
        self.end_time = dict[@"end_time"];
        self.apply_start_time = dict[@"apply_start_time"];
        self.apply_end_time = dict[@"apply_end_time"];
        self.apply_status = [dict[@"apply_status"] integerValue];
        self.reason = dict[@"reason"];
        self.need_verify = [dict[@"need_verify"] integerValue];
        self.contact_info = dict[@"contact_info"];
        self.lng = dict[@"lng"];
        self.lat = dict[@"lat"];
    }
    return self;
}




@end

//
//  ODUserModel.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserModel.h"

@implementation ODUserModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.open_id = dict[@"open_id"];
        self.mobile = dict[@"mobile"];
        self.name = dict[@"name"];
        self.school_id = [dict[@"school_id"] integerValue];
        self.school_name = dict[@"school_name"];
        self.access_token = dict[@"access_token"];
        self.store_id = [dict[@"store_id"] integerValue];
        self.avatar = dict[@"avatar"];
        self.nick = dict[@"nick"];
        self.qrcode = dict[@"qrcode"];
        self.sign = dict[@"sign"];
        self.gender = [dict[@"gender"] integerValue];
        self.my_hot_tags = dict[@"my_hot_tags"];
        self.share_download = dict[@"share_download"];
        
    }
    return self;
}




@end

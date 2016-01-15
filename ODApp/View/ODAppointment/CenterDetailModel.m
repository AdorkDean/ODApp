//
//  CenterDetailModel.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterDetailModel.h"

@implementation CenterDetailModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        self.store_id = [dict[@"store_id"] integerValue];
        self.name = dict[@"name"];
        self.pics = dict[@"pics"];
        self.tel = dict[@"tel"];
        self.lng = dict[@"lng"];
        self.lat = dict[@"lat"];
        self.address = dict[@"address"];
        self.business_hours = dict[@"business_hours"];
        self.map_md5 = dict[@"map_md5"];
        self.desc = dict[@"desc"];
        self.device_list = dict[@"device_list"];


        
    }
    return self;
}





@end

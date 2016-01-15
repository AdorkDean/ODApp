//
//  CenterActivityModel.m
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterActivityModel.h"

@implementation CenterActivityModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.icon_url = dict[@"icon_url"];
        self.content = dict[@"content"];
        self.address = dict[@"address"];
        self.date_str = dict[@"date_str"];
        self.activity_id = [dict[@"activity_id"] integerValue];
        
    }
    return self;
}




@end

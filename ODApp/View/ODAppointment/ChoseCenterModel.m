//
//  ChoseCenterModel.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ChoseCenterModel.h"

@implementation ChoseCenterModel


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        self.storeId = [dict[@"id"] integerValue];
        self.name = dict[@"name"];
        
        
        
    }
    return self;
}




@end

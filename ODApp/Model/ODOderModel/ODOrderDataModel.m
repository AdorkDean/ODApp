//
//  ODOrderDataModel.m
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderDataModel.h"

@implementation ODOrderDataModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        self.date = dict[@"date"];
        self.date_name = dict[@"date_name"];
        self.times = dict[@"times"];
        
    }
    return self;
}



@end

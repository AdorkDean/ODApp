//
//  LunBoModel.m
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "LunBoModel.h"

@implementation LunBoModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.banner_url = dict[@"banner_url"];
        self.img_url = dict[@"img_url"];
        self.title = dict[@"title"];
       
        
    }
    return self;
}



@end

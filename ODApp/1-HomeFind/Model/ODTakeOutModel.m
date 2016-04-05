//
//  ODTakeOutModel.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖模型

#import "ODTakeOutModel.h"

@implementation ODTakeOutModel

/**
 *  归档
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.product_id forKey:@"product_id"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.price_show forKey:@"price_show"];
    [encoder encodeObject:self.price_fake forKey:@"price_fake"];
    [encoder encodeObject:self.img_small forKey:@"img_small"];
    [encoder encodeObject:self.img_big forKey:@"img_big"];
    [encoder encodeObject:@(self.show_status) forKey:@"show_status"];
    [encoder encodeObject:self.show_status_str forKey:@"show_status_str"];
    [encoder encodeObject:self.store_hours forKey:@"store_hours"];
    [encoder encodeObject:self.store_sendtime forKey:@"store_sendtime"];
    [encoder encodeObject:@(self.shopNumber) forKey:@"shopNumber"];
}

/**
 *  解挡
 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.product_id = [decoder decodeObjectForKey:@"product_id"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.price_show = [decoder decodeObjectForKey:@"price_show"];
        self.price_fake = [decoder decodeObjectForKey:@"price_fake"];
        self.img_small = [decoder decodeObjectForKey:@"img_small"];
        self.img_big = [decoder decodeObjectForKey:@"img_big"];
        self.show_status = [[decoder decodeObjectForKey:@"show_status"] integerValue];
        self.show_status_str = [decoder decodeObjectForKey:@"show_status_str"];
        self.store_hours = [decoder decodeObjectForKey:@"store_hours"];
        self.store_sendtime = [decoder decodeObjectForKey:@"store_sendtime"];
        self.shopNumber = [[decoder decodeObjectForKey:@"shopNumber"] integerValue];
    }
    return self;
}

@end

ODRequestResultIsArrayAll(ODTakeOutModel)
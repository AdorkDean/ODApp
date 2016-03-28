//
//  ODSettingItem.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSettingItem.h"

@implementation ODSettingItem
+ (instancetype)itemWithIcon:(NSString *)icon name:(NSString *)name
{
    ODSettingItem *item = [[self alloc] init];
    if (icon.length) item.icon = icon;
    item.name = name;
    return item;
}

+ (instancetype)itemWithName:(NSString *)name
{
    return [self itemWithIcon:nil name:name];
}

@end

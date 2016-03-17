//
//  ODGroupItem.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODGroupItem.h"

@implementation ODGroupItem

+ (instancetype)groupWithItems:(NSArray *)items
{
    ODGroupItem *group = [[self alloc] init];
    group.items = items;
    return group;
}

@end

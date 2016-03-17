//
//  ODGroupItem.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  组模型

#import <Foundation/Foundation.h>

@interface ODGroupItem : NSObject

/** header */
@property (nonatomic, copy) NSString *header;

/** footer */
@property (nonatomic, copy) NSString *footer;

/** group */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)groupWithItems:(NSArray *)items;

@end

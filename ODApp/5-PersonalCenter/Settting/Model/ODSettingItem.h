//
//  ODSettingItem.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODSettingItem : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 头像 */
@property (nonatomic, weak) UIImage *icon;

/** subTitle */
@property (nonatomic, copy) NSString *subTitle;

+ (instancetype)itemWithIcon:(UIImage *)icon name:(NSString *)name;
+ (instancetype)itemWithName:(NSString *)name;

/** block */
@property (nonatomic, copy) void((^oprtionBlock))(NSIndexPath *indexPath);

@end

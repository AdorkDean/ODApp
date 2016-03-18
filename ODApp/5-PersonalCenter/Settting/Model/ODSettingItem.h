//
//  ODSettingItem.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
typedef enum : NSUInteger
{
    ODSettingCellColorTypeWhite = 0,
    ODSettingCellColorTypeYellow = 1,
} ODSettingCellColorType;

#import <Foundation/Foundation.h>

@interface ODSettingItem : NSObject

/** cell的背景颜色 */
@property (nonatomic, assign) ODSettingCellColorType colorType;

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

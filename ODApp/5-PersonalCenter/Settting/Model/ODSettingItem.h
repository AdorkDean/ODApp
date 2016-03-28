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
@property (nonatomic, copy) NSString *icon;

/** subTitle */
@property (nonatomic, copy) NSString *subTitle;

/**
 *  创建带图片和文字的cell
 *
 *  @param icon 图片名称
 *  @param name 文字
 */
+ (instancetype)itemWithIcon:(NSString *)icon name:(NSString *)name;

/**
 *  创建只带文字的cell
 *
 *  @param name 文字
 */
+ (instancetype)itemWithName:(NSString *)name;

/**
 *  将点击cell后需要执行的代码, 放入oprtionBlock中
 */
@property (nonatomic, copy) void((^oprtionBlock))(NSIndexPath *indexPath);

@end

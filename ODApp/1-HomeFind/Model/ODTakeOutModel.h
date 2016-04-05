//
//  ODTakeOutModel.h
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  顶外卖模型

/**
 *  外卖按钮状态
 */
typedef NS_ENUM(NSUInteger, ODTakeOutStatus)
{
    ODTakeOutStatusBuy = 1, // 购买
    ODTakeOutStatusEnd = 2  // 结束 (不能购买)
};

#import <Foundation/Foundation.h>

@interface ODTakeOutModel : NSObject <NSCoding>

/** 商品Id */
@property (nonatomic, copy) NSString *product_id;
/** 商品名称 */
@property (nonatomic, copy) NSString *title;
/** 商品内容 */
@property (nonatomic, copy) NSString *content;
/** 商品优惠价 */
@property (nonatomic, strong) NSNumber *price_show;
/** 商品原价 */
@property (nonatomic, strong) NSNumber *price_fake;
/** 商品小图 */
@property (nonatomic, copy) NSString *img_small;
/** 商品大图 */
@property (nonatomic, copy) NSString *img_big;
/** 商品状态 */
@property (nonatomic, assign) ODTakeOutStatus show_status;
/** 状态名称 */
@property (nonatomic, copy) NSString *show_status_str;
/** 服务时间 */
@property (nonatomic, copy) NSString *store_hours;
/** 送货时间 */
@property (nonatomic, copy) NSString *store_sendtime;
/** 点击商品次数 */
@property (nonatomic, assign) NSInteger shopNumber;
/** 是否已经清除购物车 */
@property (nonatomic, assign, getter = isClear) BOOL clear;

@end

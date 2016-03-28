//
//  ODBuyTakeOutModel.h
//  ODApp
//
//  Created by 王振航 on 16/3/28.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
/**
 *  订单状态
 */
typedef NS_ENUM(NSUInteger, ODOrderStatus) {
    ODOrderStatusCancel = -1,   // 已取消
    ODOrderStatusNotPaid = 1,   // 待付款
    ODOrderStatusHavePaid = 2,  // 已付款等待发货
    ODOrderStatusDelivered = 3, // 已发货
    ODOrderStatusCompleted = 4  // 已完成
};

#import <Foundation/Foundation.h>

@interface ODBuyTakeOutProductsModel : NSObject

/** 外卖商品的Id */
@property (nonatomic, copy) NSString *takeout_product_id;
/** 外卖商品的标题 */
@property (nonatomic, copy) NSString *product_title;
/** 商品的原价 */
@property (nonatomic, copy) NSString *price;
/** 商品的现价 */
@property (nonatomic, copy) NSString *price_show;
/** 数量 */
@property (nonatomic, copy) NSString *num;
/** 图片地址 */
@property (nonatomic, copy) NSString *img_small;

@end

@interface ODBuyTakeOutModel : NSObject

/** 商店名称 */
@property (nonatomic, copy) NSString *store_name;
/** 收件人姓名 */
@property (nonatomic, copy) NSString *address_name;
/** 手机号码 */
@property (nonatomic, copy) NSString *address_tel;
/** 订单状态描述 */
@property (nonatomic, copy) NSString *status_str;
/** 创建时间 */
@property (nonatomic, copy) NSString *created_at;
/** 订单Id */
@property (nonatomic, copy) NSString *order_id;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 商品价格 */
@property (nonatomic, copy) NSString *price_show;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
/** 商店Id */
@property (nonatomic, copy) NSString *store_id;
/** 商品单号 */
@property (nonatomic, copy) NSString *order_no;
/** 订单状态 */
@property (nonatomic, assign) ODOrderStatus status;

/** 商品模型 */
@property (nonatomic, strong) NSArray *products;

@end

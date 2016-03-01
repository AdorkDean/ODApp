//
//  ODMyOrderModel.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODMyOrderModel : NSObject

@property(nonatomic, copy) NSString *swap_id;
@property(nonatomic, copy) NSString *swap_type;
@property(nonatomic, copy) NSString *swap_user_avatar;
@property(nonatomic, copy) NSString *swap_user_id;
@property(nonatomic, copy) NSString *swap_user_gender;
@property(nonatomic, copy) NSString *swap_user_nick;
@property(nonatomic, copy) NSString *swap_title;
@property(nonatomic, copy) NSString *swap_img;
@property(nonatomic, copy) NSString *swap_unit;
@property(nonatomic, copy) NSString *swap_price;
@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *service_time;
@property(nonatomic, copy) NSString *order_status;
@property(nonatomic, copy) NSString *pay_status;
@property(nonatomic, copy) NSString *status_str;
@property(nonatomic, copy) NSString *order_created_at;

@end

//
//  ODOrderDetailModel.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODOrderDetailModel : NSObject

@property(nonatomic, copy) NSString *swap_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *unit;
@property(nonatomic, copy) NSString *swap_type;
@property(nonatomic, copy) NSString *love_num;
@property(nonatomic, copy) NSString *share_num;
@property(nonatomic, copy) NSString *love_id;
@property(nonatomic, strong) NSMutableArray *imgs_small;
@property(nonatomic, strong) NSMutableArray *imgs_big;
@property(nonatomic, strong) NSMutableDictionary *user;
@property(nonatomic, strong) NSMutableArray *loves;
@property(nonatomic, strong) NSMutableDictionary *share;
@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *order_status;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, copy) NSString *service_time;
@property(nonatomic, copy) NSString *user_address_id;
@property(nonatomic, copy) NSString *order_comment;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *num;
@property(nonatomic, copy) NSString *total_price;
@property(nonatomic, copy) NSString *pay_status;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *order_created_at;
@property(nonatomic, copy) NSString *order_no;
@property(nonatomic, copy) NSString *reason_num;
@property(nonatomic, copy) NSString *reason;
@property(nonatomic, strong) NSMutableDictionary *order_user;
@property(nonatomic, copy) NSString *tel400;
@property(nonatomic, copy) NSString *tel_msg;
@property(nonatomic, copy) NSString *reject_reason;
@property(nonatomic, copy) NSString *order_title;
@property(nonatomic, copy) NSString *order_content;
@property(nonatomic, copy) NSString *order_price;
@end

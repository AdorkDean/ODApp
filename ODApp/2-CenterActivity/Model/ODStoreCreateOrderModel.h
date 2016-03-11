//
//  ODStoreCreateOrderModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODStoreCreateOrderModel : NSObject

@property (nonatomic, copy) NSString *end_date_str;

@property (nonatomic, copy) NSString *store_name;

@property (nonatomic, copy) NSString *start_date;

@property (nonatomic, assign) int people_num;

@property (nonatomic, copy) NSString *school_name;

@property (nonatomic, copy) NSString *end_date;

@property (nonatomic, copy) NSString *user_mobile;

@property (nonatomic, copy) NSString *start_date_str;

@property (nonatomic, assign) int order_id;

@property (nonatomic, copy) NSString *status_str;

@property (nonatomic, strong) NSArray *devices;

@property (nonatomic, copy) NSString *purpose;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, assign) int store_id;

@property (nonatomic, copy) NSString *store_tel;

@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *content;

@end

ODRequestResultIsDictionaryProperty(ODStoreCreateOrderModel)
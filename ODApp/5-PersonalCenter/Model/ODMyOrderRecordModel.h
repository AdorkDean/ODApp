//
//  ODMyOrderRecordModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//



@interface ODMyOrderRecordModel : NSObject

@property(nonatomic, copy) NSString *order_id;
@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, copy) NSString *purpose;

@property(nonatomic, copy) NSString *date_str;

@property(nonatomic, copy) NSString *start_date_str;
@property(nonatomic, copy) NSString *end_date_str;

@property(nonatomic, copy) NSString *position_str;

@property(nonatomic, copy) NSString *status_str;

@property(nonatomic, copy) NSString *status;

@property(nonatomic, copy) NSString *due_date;


@end

ODRequestResultIsArrayProperty(ODMyOrderRecordModel)
//
//  ODMyOrderRecordModel.h
//  ODApp
//
//  Created by 代征钏 on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODMyOrderRecordModel : ODAppModel

@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *open_id;

@property (nonatomic, copy)NSString *purpose;

@property (nonatomic, copy)NSString *date_str;

@property (nonatomic, copy)NSString *start_date_str;
@property (nonatomic, copy)NSString *end_date_str;

@property (nonatomic, copy)NSString *position_str;

@property (nonatomic, copy)NSString *status_str;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *due_date;


@end

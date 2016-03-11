//
//  ODMyOrderDetailModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/11.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODMyOrderDetailModel.h"

@interface ODMyOrderDetailModel : NSObject

@property(nonatomic, copy) NSString *store_id;
@property(nonatomic, strong) NSString *order_id;

@property(nonatomic, copy) NSString *store_name;

@property(nonatomic, copy) NSString *start_date_str;
@property(nonatomic, copy) NSString *end_date_str;

@property(nonatomic, strong) NSArray *devices;

@property(nonatomic, copy) NSString *purpose;

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *people_num;

@property(nonatomic, copy) NSString *store_tel;

@property(nonatomic, copy) NSString *status_str;

@end

@interface ODMyOrderDetailDevicesModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;


@end


/*
 
 {
 "status": "success",
 "result": {
 "store_id": 1,
 "order_id": 552,
 "store_name": "上海第二工业大学体验中心",
 "store_tel": "13524776010",
 "start_date": "2016-01-09 10:00:00",
 "start_date_str": "01-09 周六 10:00",
 "end_date": "2016-01-09 10:30:00",
 "end_date_str": "01-09 周六 10:30",
 "user_name": "无名氏pUE3F",
 "user_mobile": "17751503997",
 "school_name": "",
 "purpose": "哇哈哈",
 "status": -1,
 "status_str": "取消",
 "reason": "",
 "content": "啪啪啪",
 "people_num": 3,
 "remark": "",
 "devices": [
 {
 "id": 2,
 "name": "投影仪"
 },
 {
 "id": 3,
 "name": "音响"
 }
 ]
 }
 }
 
 */


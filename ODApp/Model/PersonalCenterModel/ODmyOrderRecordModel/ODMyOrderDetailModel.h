//
//  ODMyOrderDetailModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/11.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODAppModel.h"

@interface ODMyOrderDetailModel : ODAppModel

@property (nonatomic, strong)NSString *store_id;
@property (nonatomic, strong)NSString *order_id;

@property (nonatomic, strong)NSString *store_name;

@property (nonatomic, strong)NSString *start_date_str;
@property (nonatomic, strong)NSString *end_date_str;

@property (nonatomic, strong)NSString *devices;

@property (nonatomic, strong)NSString *purpose;

@property (nonatomic, strong)NSString *content;

@property (nonatomic, strong)NSString *people_num;

@property (nonatomic, strong)NSString *store_tel;

@property (nonatomic, strong)NSString *status_str;

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


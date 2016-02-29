//
//  ODMyApplyActivityModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODMyApplyActivityModel : ODAppModel

@property (nonatomic, copy)NSString *activity_id;

@property (nonatomic, copy)NSString *store_id;

@property (nonatomic, copy)NSString *icon_url;

@property (nonatomic, copy)NSString *content;

@property (nonatomic, copy)NSString *date_str;
@property (nonatomic, copy)NSString *address;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy) NSString *apply_cnt;

@end



/*
 
 {
 "status": "success",
 "result": [
 {
 "activity_id": 446,
 "icon_url": "http://odfile.ufile.ucloud.cn/img%2F35f0aec2dd2afc6059f9992d1fe0db7f?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=w4WnFCk9ZjDVvDYlDKvov6G/JF0=&iopcmd=thumbnail&type=4&width=800",
 "content": "2016测试活动002",
 "tags": [],
 "date_hint": "",
 "apply_cnt": 13,
 "status": 0,
 "browse_num": 181,
 "address": "上海市浦东新区金海路2360号河南宿舍区门口",
 "date_str": "01月10日 - 01月20日",
 "type": 1,
 "store_id": 1
 },
 {
 "activity_id": 448,
 "icon_url": "http://odfile.ufile.ucloud.cn/img%2F35f0aec2dd2afc6059f9992d1fe0db7f?UCloudPublicKey=ucloud19581143@qq.com14397759570001695093750&Signature=w4WnFCk9ZjDVvDYlDKvov6G/JF0=&iopcmd=thumbnail&type=4&width=800",
 "content": "测试004",
 "tags": [],
 "date_hint": "",
 "apply_cnt": 9,
 "status": 0,
 "browse_num": 34,
 "address": "上海市浦东新区金海路2360号河南宿舍区门口",
 "date_str": "02月04日 - 02月06日",
 "type": 1,
 "store_id": 1
 }
 ]
 }
 
 */
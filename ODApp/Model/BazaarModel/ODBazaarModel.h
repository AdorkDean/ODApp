//
//  ODBazaarModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODBazaarModel : ODAppModel

@property(nonatomic,copy)NSString *task_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *task_status;
@property(nonatomic,copy)NSString *open_id;
@property(nonatomic,copy)NSString *user_nick;
@property(nonatomic,copy)NSString *task_start_date;
@property(nonatomic,copy)NSString *apply_num;
@property(nonatomic,copy)NSString *avatar;

/**
 *  "title": "asdasd",
 "content": "asdasdasdasdasdasdasdasdasdasdasdasdasdasd",
 "task_status": -2,
 "open_id": "766148455eed214ed1f8",
 "user_nick": "oye",
 "avatar": "",
 "tags": [],
 "task_start_date": "-0001/11/30 00:00",
 "apply_num": 0,
 "apply": []
 */

@end

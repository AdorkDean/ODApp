//
//  ODBazaarModel.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODBazaarModel : ODAppModel

@property(nonatomic, copy) NSString *task_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *task_status;
@property(nonatomic, copy) NSString *task_status_name;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *user_nick;
@property(nonatomic, copy) NSString *task_start_date;
@property(nonatomic, copy) NSString *apply_num;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *reason;

@end

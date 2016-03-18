//
//  ODBazaarRequestHelpModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBazaarRequestHelpTasksModel : NSObject

@property (nonatomic, assign) int task_status;

@property (nonatomic, assign) int apply_num;

@property (nonatomic, copy) NSString *user_nick;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, copy) NSString *task_status_name;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) NSInteger task_id;

@property (nonatomic, copy) NSString *task_start_date;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, strong) NSDictionary *apply;

@property (nonatomic, assign) int task_type;

@property (nonatomic, copy) NSString *content;

@end

@interface ODBazaarRequestHelpModel : NSObject

@property (nonatomic, strong) NSArray *hot_tags;
@property (nonatomic, strong) NSArray *tasks;




@end

ODRequestResultIsDictionaryProperty(ODBazaarRequestHelpModel)


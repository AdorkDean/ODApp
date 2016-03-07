//
//  ODLoveListModel.h
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODLoveListModel : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, assign) int user_auth_status;

@property (nonatomic, copy) NSString *profile;

@property (nonatomic, copy) NSString *school_name;

@end

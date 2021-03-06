//
//  ODUserModel.h
//  ODApp
//
//  Created by william on 16/3/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODShareModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *link;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *desc;

@end

@interface ODUserModel : NSObject

@property (copy, nonatomic) NSString *open_id;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) int school_id;
@property (copy, nonatomic) NSString *school_name;
@property (copy, nonatomic) NSString *access_token;
@property (assign, nonatomic) int store_id;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *nick;
@property (copy, nonatomic) NSString *qrcode;
@property (copy, nonatomic) NSString *sign;
@property (assign, nonatomic) int gender;
@property (assign, nonatomic) int user_auth_status;
@property (copy, nonatomic) NSString *balance;
@property (strong, nonatomic) ODShareModel *share;

@end

//
//  ODUserModel.h
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODUserModel : NSObject

@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , copy) NSString *mobile;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , assign) NSInteger school_id;
@property (nonatomic , copy) NSString *school_name;
@property (nonatomic , copy) NSString *access_token;
@property (nonatomic , assign) NSInteger store_id;
@property (nonatomic , copy) NSString *avatar;
@property (nonatomic , copy) NSString *nick;
@property (nonatomic , copy) NSString *qrcode;
@property (nonatomic , copy) NSString *sign;
@property (nonatomic , assign) NSInteger gender;
@property (nonatomic , strong) NSMutableArray *my_hot_tags;
@property (nonatomic , strong) NSMutableDictionary *share;

-(instancetype)initWithDict:(NSDictionary *)dict;


@end

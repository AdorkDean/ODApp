//
//  ODBlacklistModel.h
//  ODApp
//
//  Created by Odong-YG on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBlacklistModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, copy) NSString *avatar_url;

@end

ODRequestResultIsArrayProperty(ODBlacklistModel)

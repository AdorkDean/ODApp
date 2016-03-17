//
//  ODHomeInfoModel.h
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODHomeInfoModel : NSObject

@property(nonatomic, strong) NSArray *swaps;

@property(nonatomic, strong) NSArray *activitys;

@end

ODRequestResultIsDictionaryProperty(ODHomeInfoModel)

@interface ODHomeInfoActivitiesModel : NSObject

@property(nonatomic, assign) int id;

@property(nonatomic, copy) NSString *detail_md5;

@end

@interface ODHomeInfoSwapModel : NSObject

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *unit;

@property(nonatomic, strong) NSArray *imgs_big;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *price;

@property(nonatomic, assign) int swap_type;

@property(nonatomic, assign) int love_num;

@property(nonatomic, assign) int share_num;

@property(nonatomic, strong) NSArray *imgs_small;

@property(nonatomic, strong) NSDictionary *share;

@property(nonatomic, assign) int love_id;

@property(nonatomic, strong) NSDictionary *user;

@property(nonatomic, strong) NSArray *loves;

@property(nonatomic, copy) NSString *swap_id;

@end
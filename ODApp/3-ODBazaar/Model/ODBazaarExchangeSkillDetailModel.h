//
//  ODBazaarExchangeSkillDetailModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODBazaarExchangeSkillDetailImgs_smallModel : NSObject

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *img_url;

@end

@interface ODBazaarExchangeSkillDetailImgs_bigModel : NSObject

@property (nonatomic, assign) int y;

@property (nonatomic, assign) int rat;

@property (nonatomic, assign) int x;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *img_url;

@end

@interface ODBazaarExchangeSkillDetailModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *status_str;

@property (nonatomic, strong) NSArray *imgs_big;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) int price;

@property (nonatomic, assign) int swap_type;

@property (nonatomic, assign) int love_num;

@property (nonatomic, assign) int share_num;

@property (nonatomic, strong) NSArray *imgs_small;

@property (nonatomic, strong) NSDictionary *share;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, assign) int love_id;

@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, strong) NSArray *loves;

@property (nonatomic, assign) NSString *swap_id;

@end



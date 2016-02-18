//
//  ODBazaarExchangeSkillModel.h
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAppModel.h"

@interface ODBazaarExchangeSkillModel : ODAppModel
@property(nonatomic,copy)NSString *swap_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *unit;
@property(nonatomic,copy)NSString *swap_type;
@property(nonatomic,copy)NSString *love_num;
@property(nonatomic,copy)NSString *share_num;
@property(nonatomic,strong)NSArray *imgs_small;
@property(nonatomic,strong)NSArray *imgs_big;
@property(nonatomic,strong)NSDictionary *user;
@property(nonatomic,strong)NSArray *loves;
@property(nonatomic,strong)NSMutableDictionary *share;
@end

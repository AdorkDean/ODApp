//
//  ODConfirmOrderModel.h
//  ODApp
//
//  Created by Odong-YG on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODConfirmOrderModelShopcart_list : NSObject

@property(nonatomic, copy)NSString *id;

@property(nonatomic, copy)NSString *obj_id;

@property(nonatomic, copy)NSString *obj_type;

@property(nonatomic, copy)NSString *obj_title;

@property(nonatomic, copy)NSString *img_small;

@property(nonatomic, copy)NSString *price;

@property(nonatomic, copy)NSString *price_show;

@property(nonatomic, copy)NSString *price_fake;

@property(nonatomic, copy)NSString *num;

@end

@interface ODConfirmOrderModel : NSObject

@property (nonatomic, strong) NSDictionary *address;

@property (nonatomic, strong) NSDictionary *pay_type;

@property (nonatomic, strong) NSArray *shopcart_list;

@end

ODRequestResultIsDictionaryProperty(ODConfirmOrderModel)



//
//  ODOrderAddressModel.h
//  ODApp
//
//  Created by 王振航 on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODOrderAddressDefModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *is_default;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *address_title;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *lng;

@end


@interface ODOrderAddressModel : NSObject

@property (nonatomic, strong) ODOrderAddressDefModel *def;

@property (nonatomic, strong) NSArray *list;

@end


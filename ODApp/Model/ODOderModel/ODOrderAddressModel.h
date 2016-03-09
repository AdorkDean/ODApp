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

@property (nonatomic, assign) NSString *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int is_default;

@property (nonatomic, copy) NSString *tel;

@end


@interface ODOrderAddressModel : NSObject

@property (nonatomic, strong) ODOrderAddressDefModel *def;

@property (nonatomic, strong) NSArray *list;

@end


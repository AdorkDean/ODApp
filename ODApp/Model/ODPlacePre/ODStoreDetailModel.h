//
//  ODStoreDetailModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODStoreDetailDeviceListModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;

@end

@interface ODStoreDetailModel : NSObject

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *business_hours;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *device_list;

@property (nonatomic, copy) NSString *map_md5;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, assign) int store_id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *pics;

@end


ODRequestResultIsDictionaryProperty(ODStoreDetailModel)

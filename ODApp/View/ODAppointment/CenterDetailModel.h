//
//  CenterDetailModel.h
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterDetailModel : NSObject

@property (nonatomic , assign) NSInteger store_id;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , strong) NSMutableArray *pics;
@property (nonatomic , copy) NSString *tel;
@property (nonatomic , copy) NSString *lng;
@property (nonatomic , copy) NSString *lat;
@property (nonatomic , copy) NSString *address;
@property (nonatomic , copy) NSString *business_hours;
@property (nonatomic , copy) NSString *map_md5;
@property (nonatomic , copy) NSString *desc;
@property (nonatomic , strong) NSMutableArray *device_list;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end

//
//  ODHomeFoundModel.h
//  ODApp
//
//  Created by Bracelet on 16/1/5.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODAppModel.h"


@interface ODHomeFoundModel : ODAppModel

- (instancetype)initWithDict:(NSDictionary *)dict;


@property(nonatomic, copy) NSString *banner_url;
@property(nonatomic, copy) NSString *img_url;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *activitys;


@end


//
//  ODLocationModel.h
//  ODApp
//
//  Created by Bracelet on 16/2/17.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODLocationModel : NSObject

@property(nonatomic, strong) NSDictionary *display;
@property(nonatomic, strong) NSDictionary *requset;
@property(nonatomic, strong) NSArray *all;

@end

ODRequestResultIsDictionaryProperty(ODLocationModel)


@interface ODCityNameModel : NSObject

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *name;

@end
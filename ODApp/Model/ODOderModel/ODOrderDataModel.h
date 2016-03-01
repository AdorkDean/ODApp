//
//  ODOrderDataModel.h
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODOrderDataModel : NSObject

@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *date_name;
@property(nonatomic, strong) NSMutableArray *times;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

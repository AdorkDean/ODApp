//
//  ChoseCenterModel.h
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoseCenterModel : NSObject


@property(nonatomic, assign) NSInteger storeId;
@property(nonatomic, copy) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

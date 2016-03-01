//
//  CenterActivityModel.h
//  ODApp
//
//  Created by zhz on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterActivityModel : NSObject

@property(nonatomic, assign) NSInteger activity_id;
@property(nonatomic, copy) NSString *icon_url;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *date_str;


- (instancetype)initWithDict:(NSDictionary *)dict;


@end

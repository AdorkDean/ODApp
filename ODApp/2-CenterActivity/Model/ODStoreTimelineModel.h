//
//  ODStoreTimelineModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODStoreTimelineCaoModel : NSObject

@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *date_right_str;

@end

@interface ODStoreTimelineModel : NSObject

@property (nonatomic, strong) NSArray *cao;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *date_left_str;

@end

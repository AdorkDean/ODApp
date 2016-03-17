//
//  ODOrderDataModel.h
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODOrderDataTimesModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *request;

@end

@interface ODOrderDataModel : NSObject

@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *date_name;
@property(nonatomic, strong) NSMutableArray *times;

@end

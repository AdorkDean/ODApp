//
//  ODActivityListModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODActivityListModel : NSObject

@property(nonatomic, assign) int apply_cnt;

@property(nonatomic, strong) NSString *content;

@property(nonatomic, assign) int status;

@property(nonatomic, assign) int type;

@property(nonatomic, strong) NSString *address;

@property(nonatomic, strong) NSString *date_str;

@property(nonatomic, strong) NSString *icon_url;

@property(nonatomic, assign) int browse_num;

@property(nonatomic, assign) int activity_id;

@property(nonatomic, strong) NSArray *tags;

@property(nonatomic, strong) NSString *date_hint;

@end

ODRequestResultIsArrayProperty(ODActivityListModel)

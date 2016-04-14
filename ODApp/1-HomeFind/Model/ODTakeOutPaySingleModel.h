//
//  ODTakeOutPaySingleModel.h
//  ODApp
//
//  Created by 刘培壮 on 16/4/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODSingleton.h"
#import <Foundation/Foundation.h>

@interface ODTakeOutPaySingleModel : NSObject

Single_Interface(ODTakeOutPaySingleModel)

/** 参数 */
@property (nonatomic,strong) NSDictionary *params;

/** order_no */
@property (nonatomic,copy) NSString *order_no;

/** order_id */
@property (nonatomic,copy) NSString *order_id;

@end

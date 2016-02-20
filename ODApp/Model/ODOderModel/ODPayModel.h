//
//  ODPayModel.h
//  ODApp
//
//  Created by zhz on 16/2/19.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODPayModel : NSObject

@property (nonatomic , copy) NSString *appid;
@property (nonatomic , copy) NSString *nonce_str;
@property (nonatomic , copy) NSString *out_trade_no;
@property (nonatomic , copy) NSString *package;
@property (nonatomic , copy) NSString *partnerid;
@property (nonatomic , copy) NSString *prepay_id;
@property (nonatomic , copy) NSString *sign;
@property (nonatomic ) UInt32 timeStamp;


@end

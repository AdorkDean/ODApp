//
//  ODPaySuccessController.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayController.h"

@interface ODPaySuccessController : ODPayController

//Single_Interface(ODPaySuccessController)

@property(nonatomic, copy) NSString *payStatus;

/** 参数 */
@property (nonatomic,strong) NSDictionary *params;

///** order_no */
//@property (nonatomic,copy) NSString *order_no;

@end

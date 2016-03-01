//
//  ODBindingMobileController.h
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODBindingMobileController : ODBaseViewController

@property(nonatomic, copy) void(^getTextBlock)(NSString *text);


@end

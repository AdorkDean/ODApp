//
//  ODUserGenderController.h
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"

@interface ODUserGenderController : ODBaseViewController


@property(nonatomic, copy) void(^getTextBlock)(NSString *text);

@end

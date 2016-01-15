//
//  ODChoseCenterController.h
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODChoseCenterController : ODBaseViewController


@property(nonatomic,copy)void(^storeCenterNameBlock)(NSString *name , NSString *storeId , NSInteger storeNumber);


@end

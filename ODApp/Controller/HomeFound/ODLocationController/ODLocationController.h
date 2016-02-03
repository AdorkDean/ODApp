//
//  ODLocationController.h
//  ODApp
//
//  Created by 代征钏 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ODLocationController : ODBaseViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) UIImageView *centerImageView;


@end

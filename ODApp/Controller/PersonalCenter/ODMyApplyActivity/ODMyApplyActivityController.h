//
//  ODMyApplyActivityController.h
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODBaseViewController.h"

#import "ODClassMethod.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailController.h"

#import "ODNewActivityDetailViewController.h"

@interface ODMyApplyActivityController : ODBaseViewController

@property (nonatomic, strong) UILabel *noReusltLabel;

@property (nonatomic, assign) int pageCount;

@property (nonatomic, assign) BOOL isRefresh;

@end

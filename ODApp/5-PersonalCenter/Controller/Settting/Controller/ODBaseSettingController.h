//
//  ODBaseSettingController.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODGroupItem.h"
#import "ODSettingItem.h"
#import "ODSettingCell.h"

#import "ODArrowItem.h"
#import "ODSwitchItem.h"
#import "ODCheckItem.h"

@interface ODBaseSettingController : UITableViewController

/** 组模型 */
@property (nonatomic, strong) NSMutableArray *groups;

@end

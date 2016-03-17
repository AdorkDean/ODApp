//
//  ODSettingCell.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODSettingItem;

@interface ODSettingCell : UITableViewCell

/** 数据 */
@property (nonatomic, strong) ODSettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)style;

@end

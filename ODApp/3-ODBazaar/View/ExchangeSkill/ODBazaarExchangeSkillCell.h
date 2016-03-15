//
//  ODBazaarExchangeSkillCell.h
//  ODApp
//
//  Created by 王振航 on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODBazaarExchangeSkillModel;

@interface ODBazaarExchangeSkillCell : UITableViewCell

@property(nonatomic, strong) ODBazaarExchangeSkillModel *model;

@property (nonatomic, strong) NSArray *dataArray;

@end

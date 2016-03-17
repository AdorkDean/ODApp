//
//  ODLocationCell.h
//  ODApp
//
//  Created by Bracelet on 16/3/14.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODLocationModel.h"

@interface ODLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (nonatomic, strong) ODCityNameModel *model;

@end

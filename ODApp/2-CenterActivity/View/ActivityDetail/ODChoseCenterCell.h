//
//  ODChoseCenterCell.h
//  ODApp
//
//  Created by Bracelet on 16/3/11.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ODStorePlaceListModel.h"

@interface ODChoseCenterCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) ODStorePlaceListModel *model;

@end

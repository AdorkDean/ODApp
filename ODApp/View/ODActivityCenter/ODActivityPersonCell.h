//
//  ODActivityPersonCell.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODActivityPersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activePersonNumLabel;
/**
 *  模型数据
 */
@property (nonatomic, strong) NSArray *activePersons;
@end

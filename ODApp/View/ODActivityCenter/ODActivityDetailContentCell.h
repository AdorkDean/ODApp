//
//  ODActivityDetailContentCell.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODActivityDetailContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  cell的高度
 */
@property(nonatomic, assign) CGFloat height;

@end

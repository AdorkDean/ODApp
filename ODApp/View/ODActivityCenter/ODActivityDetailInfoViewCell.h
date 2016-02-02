//
//  ODActivityDetailInfoViewCell.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODActivityDetailInfoViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

/**
 *  详细信息
 */
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

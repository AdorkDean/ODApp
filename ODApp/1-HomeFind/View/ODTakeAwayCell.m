//
//  ODTakeAwayCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖cell

#import "ODTakeAwayCell.h"

@interface ODTakeAwayCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 优惠价格 */
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
/** 原始价格 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
/** 购买按钮 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end

@implementation ODTakeAwayCell

#pragma mark - 初始化方法
- (void)awakeFromNib
{
    // 取消选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
    self.discountPriceLabel.textColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
    self.originalPriceLabel.textColor = [UIColor colorWithRGBString:@"#d0d0d0" alpha:1];
}

- (void)setDatas:(ODTakeAwayModel *)datas
{
    _datas = datas;
    
    // 设置数据
}

#pragma mark - 事件方法
- (IBAction)buyTakeAway
{
}


@end

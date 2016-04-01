//
//  ODTakeOutCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖cell

#import "ODTakeOutCell.h"

#import "ODTakeOutModel.h"
#import "ODBuyTakeOutViewController.h"
#import <UIImageView+WebCache.h>
#import "ODShopCartListCell.h"

@interface ODTakeOutCell()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 优惠价格 */
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
/** 原始价格 */
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
/** 购买按钮 */
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end

@implementation ODTakeOutCell

#pragma mark - 初始化方法
- (void)awakeFromNib
{
    // 取消选中样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.textColor = [UIColor blackColor];
    self.discountPriceLabel.textColor = [UIColor colorRedColor];
    self.originalPriceLabel.textColor = [UIColor colorGrayColor];
    
    [self stopBlendedLayers];
}

- (void)stopBlendedLayers
{
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.discountPriceLabel.backgroundColor = [UIColor whiteColor];
    self.originalPriceLabel.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.layer.masksToBounds = YES;
    self.discountPriceLabel.layer.masksToBounds = YES;
    self.originalPriceLabel.layer.masksToBounds = YES;
}

- (void)setDatas:(ODTakeOutModel *)datas
{
    _datas = datas;
    
    // 设置数据
    UIImage *placehoderImage = [UIImage imageNamed:@"placeholder_picture"];
    __weakSelf;
    [self.shopImageView sd_setImageWithURL:[NSURL OD_URLWithString:datas.img_small] placeholderImage:placehoderImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( !image ) return;
        weakSelf.shopImageView.image = [image od_roundedCornerImage:10.0f];
    }];
    self.titleLabel.text = datas.title;
    self.discountPriceLabel.text = [NSString stringWithFormat:@"¥%@", datas.price_show];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥%@", datas.price_fake];

    // 设置按钮不同情况下的状态
    self.buyButton.enabled = (datas.show_status == ODTakeOutStatusBuy);
    
    // 添加中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:
                                                      self.originalPriceLabel.text attributes:attribtDic];
    self.originalPriceLabel.attributedText = attribtStr;
    
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusClick:) name:ODNotificationShopCartAddNumber object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minusClick:) name:ODNotificationShopCartminusNumber object:nil];
}


- (void)plusClick:(NSNotification *)note
{
    ODShopCartListCell *cell = note.object;
    
    self.datas.shopNumber = cell.takeOut.shopNumber;
}

- (void)minusClick:(NSNotification *)note
{
    ODShopCartListCell *cell = note.object;
    self.datas.shopNumber = cell.takeOut.shopNumber;
}

#pragma mark - 事件方法
- (IBAction)buyTakeAway:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(takeOutCell:didClickedButton:)])
    {
        [self.delegate takeOutCell:self didClickedButton:self.datas];
    }
}


@end

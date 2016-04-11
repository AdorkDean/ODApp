//
//  ODTakeOutCell.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖cell

#import "ODTakeOutCell.h"

#import "ODTakeOutModel.h"
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
    // 适配小屏幕
    [self sizeToFitScreen];
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

- (void)sizeToFitScreen
{
    if (KScreenWidth == 320) { // 4寸屏
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.discountPriceLabel.font = [UIFont systemFontOfSize:16];
        self.originalPriceLabel.font = self.titleLabel.font;
    }
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
    self.discountPriceLabel.text = [NSString stringWithFormat:@"¥ %@", datas.price_show];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", datas.price_fake];
    // 设置按钮不同情况下的状态
    if (datas.show_status == ODTakeOutStatusBuy) {
        [self.buyButton setTitle:@"" forState:UIControlStateNormal];
        [self.buyButton setBackgroundImage:[UIImage imageNamed:@"button_purchase-1"] forState:UIControlStateNormal];
        [self.buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if (datas.show_status == ODTakeOutStatusEnd){
        [self.buyButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.buyButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.buyButton setTitleColor:[UIColor colorGrayColor] forState:UIControlStateNormal];
    } else {
        [self.buyButton setTitle:@"已告罄" forState:UIControlStateNormal];
        [self.buyButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.buyButton setTitleColor:[UIColor colorGrayColor] forState:UIControlStateNormal];
    }
    // 添加中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:
                                                      self.originalPriceLabel.text attributes:attribtDic];
    self.originalPriceLabel.attributedText = attribtStr;
    // 清空购买数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShopNumber:) name:ODNotificationShopCartRemoveALL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShopNumber:) name:ODNotificationShopCartminusNumber object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearShopNumber:(NSNotification *)note
{
    self.datas.shopNumber = 0;
}

#pragma mark - 事件方法
- (IBAction)buyTakeAway:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(takeOutCell:didClickedButton:userInfo:)])
    {
        [self.delegate takeOutCell:self didClickedButton:self.datas userInfo:@{@"position" : [NSValue valueWithCGPoint:[self convertPoint:self.buyButton.center toView:self.superview]]}];
    }
}


@end

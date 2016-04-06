//
//  ODShopCartView.h
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODTakeOutModel, ODShopCartListHeaderView;

@interface ODShopCartView : UIView

+ (instancetype)shopCart;

/** 购买商品方法 */
- (void)addShopCount:(ODTakeOutModel *)data;

- (void)dismiss;

- (void)shopCartHeaderViewDidClickClearButton:(ODShopCartListHeaderView *)headerView;

@end

//
//  ODShopCartListHeaderView.h
//  ODApp
//
//  Created by 王振航 on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODShopCartListHeaderView;

@protocol ODShopCartListHeaderViewDelegate <NSObject>

@optional
- (void)shopCartHeaderViewDidClickClearButton:(ODShopCartListHeaderView *)headerView;

@end

@interface ODShopCartListHeaderView : UIView

+ (instancetype)headerView;

/** 代理 */
@property (nonatomic, weak) id<ODShopCartListHeaderViewDelegate> delegate;

@end

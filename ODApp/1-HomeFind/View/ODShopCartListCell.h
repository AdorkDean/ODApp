//
//  ODShopCartListCell.h
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODTakeOutModel, ODShopCartListCell;

@protocol ODShopCartListCellDelegate <NSObject>

@optional
- (void)shopCartListcell:(ODShopCartListCell *)cell DidClickPlusButton:(ODTakeOutModel *)currentData;
- (void)shopCartListcell:(ODShopCartListCell *)cell DidClickMinusButton:(ODTakeOutModel *)currentData;
@end

@interface ODShopCartListCell : UITableViewCell

/** 模型 */
@property (nonatomic, strong) ODTakeOutModel *takeOut;

/** 总数组 */
@property (nonatomic, strong) NSMutableArray *datas;

/** 代理 */
@property (nonatomic, weak) id<ODShopCartListCellDelegate> delegate;

@end

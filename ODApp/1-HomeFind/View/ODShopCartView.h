//
//  ODShopCartView.h
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODShopCartView : UIView

+ (instancetype)shopCart;
/** 价格 */
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
/** 数量 */
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

/** 数据 */
@property (nonatomic, strong) NSMutableDictionary *shops;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 是否展开 */
@property (nonatomic, assign, getter=isOpened) BOOL opened;

/** 购物车列表 */
@property (nonatomic, strong) UITableView *shopCartView;

@end

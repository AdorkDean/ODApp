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

@property (nonatomic, strong) NSMutableDictionary *shops;

/** <#desc#> */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign, getter=isOpened) BOOL isOpened;

/** 购物车列表 */
@property (nonatomic, strong) UITableView *shopCartView;

@end

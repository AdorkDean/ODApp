//
//  ODShopCartView.h
//  ODApp
//
//  Created by 王振航 on 16/3/31.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODTakeOutModel;

@interface ODShopCartView : UIView

+ (instancetype)shopCart;

- (void)addShopCount:(ODTakeOutModel *)data;

@end

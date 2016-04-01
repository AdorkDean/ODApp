//
//  ODShopCartListHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODShopCartListHeaderView.h"

@implementation ODShopCartListHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (IBAction)clearButtonClick
{
    if ([self.delegate respondsToSelector:@selector(shopCartHeaderViewDidClickClearButton:)])
    {
        [self.delegate shopCartHeaderViewDidClickClearButton:self];
    }
}

@end

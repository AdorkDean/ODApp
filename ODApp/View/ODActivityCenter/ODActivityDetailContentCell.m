//
//  ODActivityDetailContentCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityDetailContentCell.h"

@implementation ODActivityDetailContentCell
- (CGFloat)height
{
    // 强制布局cell内部的所有子控件(label根据文字多少计算出自己最真实的尺寸)
    [self layoutIfNeeded];
    // 计算cell的高度
    return CGRectGetMaxY(self.contentLabel.frame) + 12.5;
}

@end

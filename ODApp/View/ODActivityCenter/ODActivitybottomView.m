//
//  ODActivitybottomView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/16.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivitybottomView.h"

@implementation ODActivitybottomView

- (void)awakeFromNib
{
    [self.shareBtn setImage:[UIImage imageNamed:@"icon_share_activity"] forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"icon_Zambia_default"] forState:UIControlStateNormal];
    [self.goodBtn setImage:[UIImage imageNamed:@"icon_Zambia_default"] forState:UIControlStateHighlighted];
    [self.goodBtn setImage:[UIImage imageNamed:@"icon_Zambia_Selected"] forState:UIControlStateSelected];
    [self.goodBtn setTitle:@"赞" forState:UIControlStateNormal];
}


@end

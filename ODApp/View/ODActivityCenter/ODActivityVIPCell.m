//
//  ODActivityVIPCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODActivityVIPCell.h"

@implementation ODActivityVIPCell
- (void)awakeFromNib
{
    self.VIPHeadImgView.layer.cornerRadius = self.VIPHeadImgView.od_height / 2;
    self.VIPHeadImgView.clipsToBounds = YES;
}

@end

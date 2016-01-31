//
//  ODSkillDetailReusableView.m
//  ODApp
//
//  Created by 代征钏 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODSkillDetailReusableView.h"

@implementation ODSkillDetailReusableView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 150) / 2, 10, 150, 20) text:@"我去＊代买早饭" font:16 alignment:@"center" color:@"#000000" alpha:1];
        self.priceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 100) / 2, CGRectGetMaxY(self.titleLabel.frame) + 5, 100, 20) text:@"10元 / 次" font:15 alignment:@"center" color:@"#000000" alpha:1];
        
        self.contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.priceLabel.frame) + 10, kScreenSize.width - 20,[ODHelp textHeightFromTextString:@"dfsdfsdf" width:kScreenSize.width - 10 miniHeight:20 fontSize:14] ) text:@"dfdfs" font:14 alignment:@"left" color:@"#000000" alpha:1];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}

@end

//
//  ODHomeFoundFooterView.m
//  ODApp
//
//  Created by 代征钏 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODHomeFoundFooterView.h"

@implementation ODHomeFoundFooterView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        UIView *moreSkillView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 5, kScreenSize.width, 20) tag:0 color:@"#ffffff"];

        UIImageView *moreSkillImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width / 2 - 80,  6, 12, 8)];
        moreSkillImageView.image =[UIImage imageNamed:@"icon_gesture"];
        
        [moreSkillView addSubview:moreSkillImageView];
        
        self.moreSkillButton = [ODClassMethod creatButtonWithFrame:CGRectMake((kScreenSize.width - 120) / 2, 0, 120, 20) target:self sel:nil tag:0 image:nil title:@"想了解更多技能？ 憋说话，点我！" font:7];
        [self.moreSkillButton setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
        [moreSkillView addSubview:self.moreSkillButton];
        
        [self addSubview:moreSkillView];
    }
    return self;
}


@end

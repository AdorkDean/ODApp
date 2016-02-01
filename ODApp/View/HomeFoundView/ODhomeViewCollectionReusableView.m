//
//  ODhomeViewCollectionReusableView.m
//  ODApp
//
//  Created by 代征钏 on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODhomeViewCollectionReusableView.h"

@implementation ODhomeViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {

        //title的八个按钮
        self.activityView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 130) tag:0 color:@"#ffffff"];
        [self addSubview:self.activityView];
        
        float aroundSpace = 30;
        float spaceX = (kScreenSize.width - 30 * 2 - 40 * 4) / 3;
        float labelWidth = 40;
        float labelHeight = 15;
        
        self.findActivityButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace - 20, 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *findActivityImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + 7.5, 10, 25.5, 30) imageName:@"icon_activity" tag:0];
        self.findActivityLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace, CGRectGetMaxY(findActivityImageView.frame) + 5, labelWidth, labelHeight) text:@"找活动" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.findActivityLabel.userInteractionEnabled = NO;
        [self addSubview:findActivityImageView];
        [self addSubview:self.findActivityButton];
        [self addSubview:self.findActivityLabel];
        
        self.orderPlaceButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX - 20, 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *orderPlaceImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX + 5, 10, 30, 30) imageName:@"icon_field" tag:0];
        self.orderPlaceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + 40 + spaceX, CGRectGetMaxY(orderPlaceImageView.frame) + 5, labelWidth, labelHeight) text:@"约场地" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.orderPlaceLabel.userInteractionEnabled = NO;
        [self addSubview:self.orderPlaceLabel];
        [self addSubview:orderPlaceImageView];
        [self addSubview:self.orderPlaceButton];
        
        self.findFavorableButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2 - 20, 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *findFavorableImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2 + 5, 10, 30, 30) imageName:@"icon_Discount" tag:0];
        self.findFavorableLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + 40 * 2 + spaceX * 2, CGRectGetMaxY(findFavorableImageView.frame) + 5, labelWidth, labelHeight) text:@"找优惠" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.findFavorableLabel.userInteractionEnabled = NO;
        [self addSubview:self.findFavorableLabel];
        [self addSubview:findFavorableImageView];
        [self addSubview:self.findFavorableButton];
        
        self.findJobButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 - 20, 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *finJobImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 + 5, 10, 33, 30) imageName:@"icon_Work-study" tag:0];
        self.findJobLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3, CGRectGetMaxY(finJobImageView.frame) + 5, labelWidth, labelHeight) text:@"找兼职" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.findJobLabel.userInteractionEnabled = NO;
        [self addSubview:finJobImageView];
        [self addSubview:self.findJobButton];
        [self addSubview:self.findJobLabel];

 
        self.searchCircleButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace - 20, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *searchCircleImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 36.5, 30) imageName:@"icon_circle_small" tag:0];
        self.searchCircleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace, CGRectGetMaxY(searchCircleImageView.frame) + 5, labelWidth, labelHeight) text:@"寻圈子" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.searchCircleLabel.userInteractionEnabled = NO;
        [self addSubview:searchCircleImageView];
        [self addSubview:self.searchCircleButton];
        [self addSubview:self.searchCircleLabel];
        
        self.searchHelpButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX - 20, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *searchHelpImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 36, 30) imageName:@"icon_help" tag:0];
        self.searchHelpLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + 40 + spaceX, CGRectGetMaxY(searchCircleImageView.frame) + 5, labelWidth, labelHeight) text:@"求帮助" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.searchHelpLabel.userInteractionEnabled = NO;
        [self addSubview:self.searchHelpLabel];
        [self addSubview:searchHelpImageView];
        [self addSubview:self.searchHelpButton];
        
        self.changeSkillButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2 - 20, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *changeSkillImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 38, 30) imageName:@"icon_Skill_big" tag:0];
        self.changeSkillLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + 40 * 2 + spaceX * 2, CGRectGetMaxY(searchCircleImageView.frame) + 5, labelWidth, labelHeight) text:@"换技能" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.changeSkillLabel.userInteractionEnabled = NO;
        [self addSubview:self.changeSkillLabel];
        [self addSubview:changeSkillImageView];
        [self addSubview:self.changeSkillButton];
        
        self.moreButton = [ODClassMethod creatButtonWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 - 20, CGRectGetMaxY(self.findActivityLabel.frame) + 10, 80, 50) target:self sel:nil tag:0 image:@"" title:nil font:0];
        UIImageView *moreImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 + 5, CGRectGetMaxY(self.findActivityLabel.frame) + 10 + 3, 35, 25) imageName:@"icon_more" tag:0];
        self.moreLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3, CGRectGetMaxY(searchCircleImageView.frame) + 5, labelWidth, labelHeight) text:@"更多" font:12 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
        self.moreLabel.userInteractionEnabled = NO;
        [self addSubview:moreImageView];
        [self addSubview:self.moreButton];
        [self addSubview:self.moreLabel];
        
       //热门活动
        self.hotActivityView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.activityView.frame) + 5, kScreenSize.width, 160) tag:0 color:@"#ffffff"];
        [self addSubview:self.hotActivityView];
        
        UIImageView *hotActivityImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(8, 5, 17, 16) imageName:@"icon_Hot activity" tag:0];
        [self.hotActivityView addSubview:hotActivityImageView];
        
        UILabel *hotActivityLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(hotActivityImageView.frame) + 5, 5, 60, 20) text:@"热门活动" font:14 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
        [self.hotActivityView addSubview:hotActivityLabel];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(hotActivityLabel.frame) + 5, (kScreenSize.width - 30), 160)];
        [self.hotActivityView addSubview:self.scrollView];
        
        //寻圈子
        self.searchCircleView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.hotActivityView.frame) + 5, kScreenSize.width, 180) tag:0 color:@"#ffffff"];
        [self addSubview:self.searchCircleView];

        
        UIImageView *searchCircleImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(8, 10, 15, 12) imageName:@"icon_circle_small" tag:0];
        UILabel *searchCircleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(searchCircleImage.frame)+ 5, 5, 60, 20) text:@"寻圈子" font:14 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
        [self.searchCircleView addSubview:searchCircleImage];
        [self.searchCircleView addSubview:searchCircleLabel];
        
        UIView *searchCircleBtnView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(searchCircleLabel.frame) + 5, kScreenSize.width, 130) tag:0 color:@"#ffd802"];
        [self.searchCircleView addSubview:searchCircleBtnView];
        
        self.emotionButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, CGRectGetMaxY(searchCircleLabel.frame) + 5, kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_emotion" title:@"" font:0];
        [self.searchCircleView addSubview:self.emotionButton];
        
        self.funnyButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.emotionButton.frame), CGRectGetMaxY(searchCircleLabel.frame) + 5, kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_Funny" title:@"" font:0];
        [self.searchCircleView addSubview:self.funnyButton];
        
        self.moviesButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.funnyButton.frame), CGRectGetMaxY(searchCircleLabel.frame) + 5, kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_Movies" title:@"" font:0];
        [self.searchCircleView addSubview:self.moviesButton];
        
        self.quadraticButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.moviesButton.frame), CGRectGetMaxY(searchCircleLabel.frame) + 5, kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_quadratic element" title:@"" font:0];
        [self.searchCircleView addSubview:self.quadraticButton];
        

        self.lifeButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionButton.frame), kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_Life" title:@"" font:0];
        [self.searchCircleView addSubview:self.lifeButton];
        
        self.starButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.emotionButton.frame), CGRectGetMaxY(self.emotionButton.frame), kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_Star" title:@"" font:0];
        [self.searchCircleView addSubview:self.starButton];
        
        self.beautifulButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.funnyButton.frame), CGRectGetMaxY(self.emotionButton.frame), kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_beautiful" title:@"" font:0];
        [self.searchCircleView addSubview:self.beautifulButton];
        
        self.petButton = [ODClassMethod creatButtonWithFrame:CGRectMake(CGRectGetMaxX(self.moviesButton.frame), CGRectGetMaxY(self.emotionButton.frame), kScreenSize.width / 4, 65) target:0 sel:nil tag:0 image:@"button_Pet" title:@"" font:0];
        [self.searchCircleView addSubview:self.petButton];
        
        UIImageView *gestureImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width / 2 - 80, CGRectGetMaxY(self.lifeButton.frame) + 5, 12, 8) imageName:@"icon_gesture" tag:0];
        [self.searchCircleView addSubview:gestureImageView];
        self.gestureButton = [ODClassMethod creatButtonWithFrame:CGRectMake((kScreenSize.width - 120) / 2, CGRectGetMaxY(self.lifeButton.frame), 120, 20) target:0 sel:nil tag:0 image:nil title:@"想加入更多圈子么？ 憋说话，点我！" font:7];
        [self.gestureButton setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
        [self.searchCircleView addSubview:self.gestureButton];
        
        
        
        
        //技能交换
        self.changeSkillView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchCircleView.frame) + 5, kScreenSize.width, 30) tag:0 color:@"#ffffff"];
        [self addSubview: self.changeSkillView];
        
        UIImageView *changeSkillImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(8, 10, 15, 12) imageName:@"icon_Skill_small" tag:0];
        UILabel *changeSkillLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(changeSkillImage.frame) + 5, 10, 80, 14) text:@"技能交换" font:14 alignment:@"left" color:@"#000000" alpha:1];
        
        [self.changeSkillView addSubview:changeSkillImage];
        [self.changeSkillView addSubview:changeSkillLabel];
    }
    
    return self;
    
}


@end

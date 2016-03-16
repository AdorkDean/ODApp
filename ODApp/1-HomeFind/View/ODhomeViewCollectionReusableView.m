//
//  ODhomeViewCollectionReusableView.m
//  ODApp
//
//  Created by Bracelet on 16/1/7.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODhomeViewCollectionReusableView.h"

@implementation ODhomeViewCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
#pragma mark - Top Eight Button
        
        self.activityView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 140) tag:0 color:@"#ffffff"];
        self.activityView.backgroundColor = [UIColor redColor];
        [self addSubview:self.activityView];
        
        float aroundSpace = 40;
        float spaceX = (kScreenSize.width - 40 * 2 - 40 * 4) / 3;
        float labelWidth = 40;
        float labelHeight = 10;
        float buttonWidth = (KScreenWidth - ODLeftMargin * 2) / 4;
        float buttonHeight = 140 / 2;
        
        NSArray *topEightTitleArray = @[ @"找活动", @"约场地", @"找优惠", @"找兼职", @"寻圈子", @"求帮助", @"换技能", @"更多" ];
        //        NSArray *topEightImageArray = @[ @"icon_activity", @"icon_field", @"icon_Discount", @"icon_Work-study", @"icon_circle_big", @"icon_help", @"icon_Skill_big", @"icon_more" ];
        
        for (NSInteger j = 0; j < 2; j++) {
            for (NSInteger i = 0; i < 4; i ++) {
                UIButton *topEightButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin + buttonWidth * i, buttonHeight * j, buttonWidth, buttonHeight)];
                topEightButton.tag = 100 + (i + 4 * j);
                if (j==0&&i == 1) {
                    topEightButton.backgroundColor = [UIColor purpleColor];
                    self.topEightLabel.backgroundColor = [UIColor blueColor];
                }
            
                [topEightButton addTarget:self action:@selector(topEightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.activityView addSubview:topEightButton];
                
                self.topEightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + buttonWidth * i, buttonHeight * (j + 1) - labelHeight - ODLeftMargin / 2 * (j + 1), buttonWidth, labelHeight)];
                self.topEightLabel.text = topEightTitleArray[i + 4 * j];
                self.topEightLabel.textAlignment = NSTextAlignmentCenter;
                self.topEightLabel.font = [UIFont systemFontOfSize:10];
                [self.activityView addSubview:self.topEightLabel];
                
                //                self.topEightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((KScreenWidth - 80) / 5) * (i + 1), buttonHeight * j + ODLeftMargin,  20, 20)];
                //                self.topEightImageView.image = [UIImage imageNamed:topEightImageArray[i + 4 * j]];
                //                [self.activityView addSubview:self.topEightImageView];
            }
        }
        
        UIImageView *findActivityImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + 7.5, 15, 25.5, 30) imageName:@"icon_activity" tag:0];
        
        [self.activityView addSubview:findActivityImageView];
        
        UIImageView *orderPlaceImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX + 5, 15, 30, 30) imageName:@"icon_field" tag:0];
        
        [self.activityView addSubview:orderPlaceImageView];
        
        UIImageView *findFavorableImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2 + 5, 15, 30, 30) imageName:@"icon_Discount" tag:0];
        
        [self.activityView addSubview:findFavorableImageView];
        
        UIImageView *finJobImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 + 5, 15, 33, 30) imageName:@"icon_Work-study" tag:0];
        
        [self.activityView addSubview:finJobImageView];
        
        UIImageView *searchCircleImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace, 77.5, 36.5, 30) imageName:@"icon_circle_big" tag:0];
        
        [self.activityView addSubview:searchCircleImageView];
        
        UIImageView *searchHelpImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth + spaceX, 77.5, 36, 30) imageName:@"icon_help" tag:0];
        
        [self.activityView addSubview:searchHelpImageView];
        
        UIImageView *changeSkillImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 2 + spaceX * 2, 77.5, 38, 30) imageName:@"icon_Skill_big" tag:0];
        
        [self.activityView addSubview:changeSkillImageView];
        
        UIImageView *moreImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(aroundSpace + labelWidth * 3 + spaceX * 3 + 5, 77.5 + 3, 35, 25) imageName:@"icon_more" tag:0];
        
        [self.activityView addSubview:moreImageView];
        
        
#pragma mark - Hot Activity
        
        self.hotActivityView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.activityView.frame) + 6, kScreenSize.width, 160) tag:0 color:@"#ffffff"];
        [self addSubview:self.hotActivityView];
        
        UIImageView *hotActivityImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(ODLeftMargin, 5, 17, 16) imageName:@"icon_Hot activityNew" tag:0];
        [self.hotActivityView addSubview:hotActivityImageView];
        
        UILabel *hotActivityLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(hotActivityImageView.frame) + 7.5, 5, 60, 20) text:@"热门活动" font:14 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
        [self.hotActivityView addSubview:hotActivityLabel];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(hotActivityLabel.frame) + 10, (kScreenSize.width - 17.5), 110)];
        [self.hotActivityView addSubview:self.scrollView];
        
        
#pragma mark - Search Circle
        
        self.searchCircleView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.hotActivityView.frame) + 6, kScreenSize.width, 198) tag:0 color:@"#ffffff"];
        [self addSubview:self.searchCircleView];
        
        UIImageView *searchCircleImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(ODLeftMargin, 10, 15, 12.5) imageName:@"icon_circle_smallNew" tag:0];
        UILabel *searchCircleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(searchCircleImage.frame)+ 7.5, 5, 60, 20) text:@"寻圈子" font:14 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
        [self.searchCircleView addSubview:searchCircleImage];
        [self.searchCircleView addSubview:searchCircleLabel];
        
        UIView *searchCircleBtnView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(searchCircleLabel.frame) + 10, kScreenSize.width, 130) tag:0 color:@"#ffd802"];
        [self.searchCircleView addSubview:searchCircleBtnView];
        
        NSArray *searchCircleImageArray = @[ @"button_emotion", @"button_Funny", @"button_Movies", @"button_quadratic element", @"button_Life", @"button_Star", @"button_beautiful", @"button_Pet" ];
        
        for (int j = 0 ; j < 2; j++) {
            for (int i = 0; i < 4; i++) {
                self.searchCircleButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width / 4 * i, CGRectGetMaxY(searchCircleLabel.frame)+ 10 + 65 * j, kScreenSize.width / 4, 65)];
                [self.searchCircleButton setImage:[UIImage imageNamed:searchCircleImageArray[i + 4 * j]] forState:UIControlStateNormal];
                self.searchCircleButton.tag = 1000 + (i + 4 * j);
                [self.searchCircleButton addTarget:self action:@selector(searchCircleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.searchCircleView addSubview: self.searchCircleButton];
            }
        }
        
        UIImageView *gestureImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width / 2 - 90, CGRectGetMaxY(self.searchCircleButton.frame) + 13, 12, 8) imageName:@"icon_gesture" tag:0];
        [self.searchCircleView addSubview:gestureImageView];
        self.gestureButton = [ODClassMethod creatButtonWithFrame:CGRectMake((kScreenSize.width - 160) / 2, CGRectGetMaxY(self.searchCircleButton.frame) + 8, 160, 20) target:0 sel:nil tag:0 image:nil title:@"想加入更多圈子么？ 憋说话，点我！" font:9];
        [self.gestureButton setTitleColor:[UIColor colorWithHexString:@"#555555" alpha:1] forState:UIControlStateNormal];
        [self.searchCircleView addSubview:self.gestureButton];
        
#pragma mark - Skill Change
        self.changeSkillView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchCircleView.frame) + 6, kScreenSize.width, 35) tag:0 color:@"#ffffff"];
        [self addSubview: self.changeSkillView];
        
        UIImageView *changeSkillImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(ODLeftMargin, 9, 18, 14) imageName:@"icon_Skill_smallNew" tag:0];
        UILabel *changeSkillLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(CGRectGetMaxX(changeSkillImage.frame) + 10, 10, 80, 14) text:@"技能交换" font:14 alignment:@"left" color:@"#000000" alpha:1];
        
        [self.changeSkillView addSubview:changeSkillImage];
        [self.changeSkillView addSubview:changeSkillLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.changeSkillView.frame), KScreenWidth - ODLeftMargin * 2, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        [self addSubview:lineView];
    }
    return self;
}

- (void)topEightButtonClick:(UIButton *)button {
    
    if (self.topEightButtonTag) {
        self.topEightButtonTag(button.tag);
    } 
}

- (void)searchCircleButtonClick:(UIButton *)button {
    if (self.searchCircleButtonTag) {
        self.searchCircleButtonTag(button.tag);
    }
    
}


@end

//
//  ODhomeViewCollectionReusableView.h
//  ODApp
//
//  Created by Bracelet on 16/1/7.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODClassMethod.h"

@interface ODhomeViewCollectionReusableView : UICollectionReusableView

// Top Eight Button
@property(nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UILabel *topEightLabel;
@property (nonatomic, strong) UIImageView *topEightImageView;

@property (nonatomic, copy) void(^ topEightButtonTag)(NSInteger topEightTag);
@property (nonatomic, copy) void(^ searchCircleButtonTag)(NSInteger searchCircleTag);

// 热门活动
@property(nonatomic, strong) UIView *hotActivityView;
@property(nonatomic, strong) UIScrollView *scrollView;

// 寻圈子
@property(nonatomic, strong) UIView *searchCircleView;
@property (nonatomic, strong) UIButton *searchCircleButton;
@property(nonatomic, strong) UIButton *gestureButton;

// 技能交换
@property(nonatomic, strong) UIView *changeSkillView;
@property(nonatomic, strong) UIButton *moreSkillButton;


@end

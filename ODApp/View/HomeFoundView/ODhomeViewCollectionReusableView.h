//
//  ODhomeViewCollectionReusableView.h
//  ODApp
//
//  Created by 代征钏 on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "ODClassMethod.h"

@interface ODhomeViewCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong)SDCycleScrollView *cycleSecrollerView;

@property (nonatomic, strong)UIView *activityView;

@property (nonatomic, strong)UIButton *lazyButton;
@property (nonatomic, strong)UILabel *lazyLabel;

@property (nonatomic, strong)UIButton *chatButton;
@property (nonatomic, strong)UILabel *chatLabel;

@property (nonatomic, strong)UIButton *activityButton;
@property (nonatomic, strong)UILabel *activityLabel;

@property (nonatomic, strong)UIButton *placeButton;
@property (nonatomic, strong)UILabel *placeLabel;

@property (nonatomic, strong)UIView *themeView;
@property (nonatomic, strong)UIImageView *themeImageView;
@property (nonatomic, strong)UILabel *themeLabel;


@end

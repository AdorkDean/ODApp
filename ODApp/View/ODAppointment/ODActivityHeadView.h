//
//  ODActivityHeadView.h
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface ODActivityHeadView : UICollectionReusableView


@property (nonatomic , strong) SDCycleScrollView *cycleScrollerView;


@property (nonatomic , strong) UIButton *centerButton;


@property (nonatomic ,strong) UIImageView *coverImageView;
@property (nonatomic ,strong) UILabel *centerNameLabel;
@property (nonatomic ,strong) UIImageView *jiantou;




@end

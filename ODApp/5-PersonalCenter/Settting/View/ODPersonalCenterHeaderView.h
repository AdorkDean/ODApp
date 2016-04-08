//
//  ODPersonalCenterHeaderView.h
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  个人中心 - 头部视图

#import <UIKit/UIKit.h>
@class ODUserModel;

@interface ODPersonalCenterHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *orderInfoView;

/** 用户模型 */
@property (nonatomic, strong) ODUserModel *user;

+ (instancetype)headerView;

@end

//
//  ODActivePersonInfoView.h
//  ODApp
//
//  Created by 刘培壮 on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODActivePersonInfoView : UIView
/**
 *  模型数据
 */
@property(nonatomic, strong) NSArray *activePersons;

@property(strong, nonatomic) UIScrollView *headImgsView;

@end

//
//  ODNavigationBarView.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODNavigationBarView : UIView

/**
 *  左边按钮
 */
@property(nonatomic, weak) ODBarButton *leftBarButton;

/**
 *  右边按钮
 */
@property(nonatomic, weak) ODBarButton *rightBarButton;

@property(nonatomic, copy) NSString *title;

+ (instancetype)navigationBarView;
@end

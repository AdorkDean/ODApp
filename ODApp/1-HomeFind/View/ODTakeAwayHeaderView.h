//
//  ODTakeAwayHeaderView.h
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODTakeAwayHeaderView;

@protocol ODTakeAwayHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(ODTakeAwayHeaderView *)headerView didClickedMenuButton:(NSInteger)index;

@end

@interface ODTakeAwayHeaderView : UIView

/**
 *  快速创建View
 */
+ (instancetype)headerView;

/** 广告图片数组 */
@property (nonatomic, strong) NSArray *banners;

/** 代理 */
@property (nonatomic, weak) id<ODTakeAwayHeaderViewDelegate> delegate;

@end

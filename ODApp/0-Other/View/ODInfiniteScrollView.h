//
//  ODInfiniteScrollView.h
//  ODApp
//
//  Created by 王振航 on 16/3/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  无限滚动ScrollView

#import <UIKit/UIKit.h>
@class ODInfiniteScrollView;

@protocol ODInfiniteScrollViewDelegate <NSObject>

- (void)infiniteScrollViewDidClickImage:(ODInfiniteScrollView *)infiniteScrollView index:(NSInteger)index;

@end

@interface ODInfiniteScrollView : UIView
/** 图片数组 */
@property (nonatomic, strong) NSArray *images;
/** pageControl */
@property (nonatomic, weak, readonly) UIPageControl *pageControl;
@property (nonatomic, assign, getter = isScrollDirectionPortrait) BOOL scrollDirectionPortrait;

/** delegate */
@property (nonatomic, weak) id<ODInfiniteScrollViewDelegate> delegate;

@end

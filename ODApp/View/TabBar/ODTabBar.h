//
//  ODTabBar.h
//  ODApp
//
//  Created by 刘培壮 on 16/1/28.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODTabBar;
@protocol ODTabBarDelegate <NSObject>
@optional
- (void)od_tabBar:(ODTabBar *)od_tabBar selectIndex:(NSInteger)selectIndex;

@end

@interface ODTabBar : UITabBar
/**
 *  tabBarItems
 */
@property (nonatomic, strong) NSArray *tabBarItems;
/**
 *  代理
 */
@property(nonatomic, weak) id <ODTabBarDelegate> od_delegate;

@end

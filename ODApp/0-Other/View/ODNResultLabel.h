//
//  ODNoResultLabel.h
//  ODApp
//
//  Created by Bracelet on 16/3/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODNoResultLabel : UILabel
- (void)showOnSuperView:(UIView *)view;

- (void)showOnSuperView:(UIView *)view title:(NSString *)title;

- (void)show;

- (void)showWithTitle:(NSString *)title;

- (void)hidden;

@end

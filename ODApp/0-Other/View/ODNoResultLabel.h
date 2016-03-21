//
//  ODNoResultLabel.h
//  ODApp
//
//  Created by Bracelet on 16/3/21.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODNoResultLabel : UILabel

- (void)showOnSuperView:(UIView *)view;

- (void)showOnSuperView:(UIView *)view title:(NSString *)title;

- (void)showWithTitle:(NSString *)title;

- (void)show;

- (void)hidden;

@end

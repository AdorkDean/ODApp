//
//  ODNoResultLabel.m
//  ODApp
//
//  Created by Bracelet on 16/3/21.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODNoResultLabel.h"

@implementation ODNoResultLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)showOnSuperView:(UIView *)view
{
    if (![view.subviews containsObject:self])
    {
        [view addSubview:self];
        self.frame = CGRectMake((self.superview.od_width - 160)/2, self.superview.od_height/2, 160, 30);
    }
    self.hidden = NO;
}

- (void)showOnSuperView:(UIView *)view title:(NSString *)title {
    [self showOnSuperView:view];
    self.text = title;
}

- (void)showWithTitle:(NSString *)title {
    [self show];
    self.text = title;
}


- (void)show
{
    [self showOnSuperView:[UIApplication sharedApplication].keyWindow];
}

- (void)hidden
{
    self.hidden = YES;
}

@end

//
//  ODTabBarButton.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/27.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODTabBarButton.h"

@implementation ODTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
//    if (state == UIControlStateNormal)
    {
        [self setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:state];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 7.5, self.frame.size.width, 25);
    self.titleLabel.frame = CGRectMake(0, 37, self.frame.size.width, 18);
}
@end

//
//  ODNavigationBarView.m
//  ODApp
//
//  Created by 刘培壮 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODNavigationBarView.h"

@implementation ODNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"ffd802" alpha:1];
        // 注册button
        ODBarButton *rightBtn = [ODBarButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(kScreenSize.width - 60, 16,50, 44);
        [self addSubview:rightBtn];
        self.rightBarButton = rightBtn;
        // 返回button
        ODBarButton *backButton = [ODBarButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(17.5, 16,44, 44);
        [self addSubview:backButton];
        self.leftBarButton = backButton;
    }
    return self;
}

+ (instancetype)navigationBarView
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, ODNavigationHeight)];
}

@end

//
//  ODCommunityHeaderView.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityHeaderView.h"

@implementation ODCommunityHeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createHeaderLabel];
    }
    return self;
}


-(void)createHeaderLabel
{
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 40) tag:0 color:@"#ffffff"];
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 7.5, 100, 25) text:@"最新话题" font:16 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(10, 39, kScreenSize.width , 1) tag:0 color:@"#f3f3f3"];
    [view addSubview:label];
    [view addSubview:lineView];
    [self addSubview:view];
}

@end

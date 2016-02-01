//
//  ODChoseTimeView.m
//  ODApp
//
//  Created by zhz on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODChoseTimeView.h"

@implementation ODChoseTimeView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
    }
    return self;

}


- (void)addViews
{
    self.backgroundColor = [UIColor redColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"服务时间";
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 20)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"(该时间将影响订单自动确认时间)";
    contentLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:contentLabel];

    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 50)];
    scroller.backgroundColor = [UIColor yellowColor];
    scroller.contentSize = CGSizeMake(3 * scroller.frame.size.width, 60);
    [self addSubview:scroller];
    
    
    for (int i = 0; i < 7; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(5 + i * scroller.frame.size.width / 3, 5 , scroller.frame.size.width / 3 - 10, 40);
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:[NSString stringWithFormat:@"周%d" , i + 1] forState:UIControlStateNormal];
        [scroller addSubview:button];
        
    }
    
    
    
  

    
}

- (void)text:(UIButton *)sender
{
    [self createButton];
}



- (void)createButton
{
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.frame.size.width / 4, 90, self.frame.size.width / 4, (self.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%d点" , i + 1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(text:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

       
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.frame.size.width / 4, 90 + (self.frame.size.height - 80) / 4, self.frame.size.width / 4, (self.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%d点" , i + 1] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.frame.size.width / 4, 90 + 2 *(self.frame.size.height - 80) / 4, self.frame.size.width / 4, (self.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%d点" , i + 1] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i * self.frame.size.width / 4, 90 + 3 *(self.frame.size.height - 80) / 4, self.frame.size.width / 4, (self.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%d点" , i + 1] forState:UIControlStateNormal];
        [self addSubview:button];
    }

}



@end

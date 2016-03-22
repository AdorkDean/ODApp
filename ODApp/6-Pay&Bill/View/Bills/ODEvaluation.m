//
//  ODEvaluation.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODEvaluation.h"

@implementation ODEvaluation

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
    }
    return self;
    
}


- (void)addViews
{
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.95;
   
    self.userInteractionEnabled = YES;
    
    
    
    
    for (int i = 1; i < 6; i++) {
        self.starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.starButton.frame = CGRectMake((self.frame.size.width - 200) / 6 * i + 40 * (i - 1), 100, 40, 30);
        [self.starButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
        self.starButton.tag = 1000 + i;
        [self.starButton addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.starButton];
    }
    
    
    
    
    
//    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.firstButton.frame = CGRectMake((self.frame.size.width - 200) / 6, 100, 40, 30);
//    [self.firstButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
//    [self addSubview:self.firstButton];
//    
//    
//    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.secondButton.frame = CGRectMake(((self.frame.size.width - 200) / 6 ) * 2 + 40, 100, 40, 30);
//    [self.secondButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
//    [self addSubview:self.secondButton];
//    
//    
//    
//    
//    self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.thirdButton.frame = CGRectMake(((self.frame.size.width - 200) / 6 ) * 3 + 80, 100, 40, 30);
//    [self.thirdButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
//    [self addSubview:self.thirdButton];
//    
//    
//    
//    self.fourthButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.fourthButton.frame = CGRectMake(((self.frame.size.width - 200) / 6 ) * 4 + 120, 100, 40, 30);
//    [self.fourthButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
//    [self addSubview:self.fourthButton];
//    
//    
//    
//    self.fiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.fiveButton.frame = CGRectMake(((self.frame.size.width - 200) / 6 ) * 5 + 160, 100, 40, 30);
//    [self.fiveButton setImage:[UIImage imageNamed:@"3K$7ZE(Z[0WTC}}}G8DR14P"] forState:UIControlStateNormal];
//    [self addSubview:self.fiveButton];

    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, kScreenSize.width - 100, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"任务已完成请评价";
    self.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.titleLabel];
    
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 200, kScreenSize.width - 60, 150)];
    self.contentTextView.text = @"请输入评价内容";
    self.contentTextView.textColor = [UIColor lightGrayColor];
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.layer.cornerRadius = 5;
    self.contentTextView.layer.borderColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1.0f].CGColor;
    self.contentTextView.layer.borderWidth = 0.5;
    [self addSubview:self.contentTextView];
    
    
    self.determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.determineButton.frame = CGRectMake(30, 370, kScreenSize.width - 60, 35);
    self.determineButton.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
    [self.determineButton setTitle:@"确认完成" forState:UIControlStateNormal];
    [self.determineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.determineButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.determineButton.layer.masksToBounds = YES;
    self.determineButton.layer.cornerRadius = 5;
    self.determineButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.determineButton.layer.borderWidth = 0.5;


    [self addSubview:self.determineButton];

    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(kScreenSize.width - 50, 20, 30, 30);
    [self.cancelButton setImage:[UIImage imageNamed:@"分享页关闭icon"] forState:UIControlStateNormal];

    [self addSubview:self.cancelButton];

    
    
    
}


- (void)starButtonClick:(UIButton *)button {
    if (self.starButtonTag) {
        self.starButtonTag(button.tag);
    }
}



@end

//
//  ODPaySuccessView.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPaySuccessView.h"

@implementation ODPaySuccessView


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
    
    self.isSuccessView = [[UIImageView alloc] initWithFrame:CGRectMake(81, 50, self.frame.size.width - 162, 200)];
    self.isSuccessView.image = [UIImage imageNamed:@"icon_background_"];
    [self addSubview:self.isSuccessView];
    
    
    self.isSuccessLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.isSuccessView.frame.origin.y + 200 + 32.5, kScreenSize.width - 40, 20)];
    self.isSuccessLabel.text = @"您的订单已支付成功";
    self.isSuccessLabel.textAlignment = NSTextAlignmentCenter;
    self.isSuccessLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.isSuccessLabel];
    
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.firstButton.frame = CGRectMake((kScreenSize.width - 260 - 17.5) / 2, self.isSuccessLabel.frame.origin.y + 20 + 32.5, 130, 30);
      [self.firstButton setBackgroundImage:[UIImage imageNamed:@"button_pay success_Order details_"] forState:UIControlStateNormal];
    [self addSubview:self.firstButton];
    
    
    self.secondButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.secondButton.frame = CGRectMake(self.firstButton.frame.origin.x + self.firstButton.frame.size.width + 17.5, self.isSuccessLabel.frame.origin.y + 20 + 32.5, 130, 30);
    [self.secondButton setBackgroundImage:[UIImage imageNamed:@"button_pay success_Go shopping again_"] forState:UIControlStateNormal];
    [self addSubview:self.secondButton];
    
    
    
}

@end

//
//  ODActivityHeadView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODActivityHeadView.h"
#import "ODClassMethod.h"
@implementation ODActivityHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        self.cycleScrollerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height / 3.2)];
        
        
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, (kScreenSize.height / 3.2) + 8, kScreenSize.width - 120, 35)];
        
        
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.layer.cornerRadius = 5;
        self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.coverImageView.layer.borderWidth = 1;
        self.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        self.coverImageView.userInteractionEnabled = YES;
        
        self.centerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.coverImageView.frame.size.width - 40, 25)];
        self.centerNameLabel.backgroundColor = [UIColor whiteColor];
        self.centerNameLabel.text = @"选择所在中心";
        self.centerNameLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.centerNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.coverImageView addSubview:self.centerNameLabel];
        
        
        self.jiantou = [[UIImageView alloc] initWithFrame:CGRectMake(self.coverImageView.frame.size.width - 30, 10, 15, 15)];
        self.jiantou.image = [UIImage imageNamed:@"场地预约icon2"];
        [self.coverImageView addSubview:self.jiantou];
        
        
        
        
        
        if (iPhone4_4S || iPhone5_5s) {
            self.centerNameLabel.font = [UIFont systemFontOfSize:13];
        }
        else if (iPhone6_6s) {
            self.centerNameLabel.font = [UIFont systemFontOfSize:17];
            
        }else {
            self.centerNameLabel.font = [UIFont systemFontOfSize:18];
        }
        
        
        
        
        
        self.centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.centerButton.frame = CGRectMake(self.coverImageView.frame.origin.x + self.coverImageView.frame.size.width + 4,(kScreenSize.height / 3.2) + 8, kScreenSize.width - self.coverImageView.frame.size.width - 12, 35);
        [self.centerButton setTitle:@"进入中心详情" forState:UIControlStateNormal];
        [self.centerButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
        self.centerButton.layer.masksToBounds = YES;
        self.centerButton.layer.cornerRadius = 5;
        self.centerButton.layer.borderColor = [UIColor colorWithHexString:@"b0b0b0" alpha:1].CGColor;
        self.centerButton.layer.borderWidth = 1;
        self.centerButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
        
        
        
        
        [self addSubview:self.cycleScrollerView];
        [self addSubview:self.coverImageView];
        [self addSubview:self.centerButton];
        
        
        
    }
    return self;
}







@end

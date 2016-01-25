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
        
        self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.searchButton.frame = CGRectMake(4, (kScreenSize.height / 3.2) + 8, kScreenSize.width - 120, 35);
        [self.searchButton setTitle:@"选择所在中心" forState:UIControlStateNormal];
        if (iPhone4_4S || iPhone5_5s) {
            self.searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        else if (iPhone6_6s) {
            self.searchButton.titleLabel.font = [UIFont systemFontOfSize:17];
            
        }else {
            self.searchButton.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        [self.searchButton setTitleColor:[UIColor colorWithHexString:@"#8e8e8e" alpha:1] forState:UIControlStateNormal];
        self.searchButton.layer.masksToBounds = YES;
        self.searchButton.layer.cornerRadius = 5;
        self.searchButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.searchButton.layer.borderWidth = 1;
        self.searchButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        
        
        
        self.searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 5);
        self.searchButton.layer.masksToBounds = YES;
        self.searchButton.layer.cornerRadius = 5;
        self.searchButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.searchButton.layer.borderWidth = 1;
        UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 120 - 30, 8, 15, 15) imageName:@"场地预约icon2@3x" tag:0];
        
        [self.searchButton addSubview:image];
     
        self.centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.centerButton.frame = CGRectMake(self.searchButton.frame.origin.x + self.searchButton.frame.size.width + 4,(kScreenSize.height / 3.2) + 8, kScreenSize.width - self.searchButton.frame.size.width - 12, 35);
        [self.centerButton setTitle:@"进入中心详情" forState:UIControlStateNormal];
        [self.centerButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
        self.centerButton.layer.masksToBounds = YES;
        self.centerButton.layer.cornerRadius = 5;
        self.centerButton.layer.borderColor = [UIColor colorWithHexString:@"b0b0b0" alpha:1].CGColor;
        self.centerButton.layer.borderWidth = 1;
        self.centerButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
        
      
        
        
        [self addSubview:self.cycleScrollerView];
        [self addSubview:self.searchButton];
        [self addSubview:self.centerButton];
        
        
        
    }
    return self;
}







@end

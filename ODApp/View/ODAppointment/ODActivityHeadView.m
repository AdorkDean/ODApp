//
//  ODActivityHeadView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODActivityHeadView.h"
//获取屏幕尺寸匹配当前手机型号
#define iPhone4_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1920, 1080), [[UIScreen mainScreen] currentMode].size) : NO)

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
        
        
     
        
        self.centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.centerButton.frame = CGRectMake(self.searchButton.frame.origin.x + self.searchButton.frame.size.width + 4,(kScreenSize.height / 3.2) + 8, kScreenSize.width - self.searchButton.frame.size.width - 12, 35);
        [self.centerButton setTitle:@"进入中心详情" forState:UIControlStateNormal];
        
        
        
        [self addSubview:self.cycleScrollerView];
        [self addSubview:self.searchButton];
        [self addSubview:self.centerButton];
        
        
        
    }
    return self;
}







@end

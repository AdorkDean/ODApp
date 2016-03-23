//
//  ODTakeAwayHeaderView.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODTakeAwayHeaderView.h"

@interface ODTakeAwayHeaderView()


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuView;

@property (weak, nonatomic) IBOutlet UIView *indicatorLine;
@end

@implementation ODTakeAwayHeaderView

/**
 *  快速创建View
 */
+ (instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark - 初始化方法
/**
 *  初始化
 */
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 添加点击事件
    for (UIButton *button in self.menuView) {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 事件方法
/**
 *  切换指示器, 重新发送请求
 */
- (void)buttonClick:(UIButton *)button
{
    [UIView animateWithDuration:0.15 animations:^{
        self.indicatorLine.od_centerX = button.od_centerX;
    }];
    
    // 更新参数
}

@end

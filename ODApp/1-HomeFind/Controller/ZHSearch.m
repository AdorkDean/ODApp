//
//  ZHSearch.m
//  01-Status
//
//  Created by 王振航 on 15/10/14.
//  Copyright © 2015年 WZH. All rights reserved.
//

#import "ZHSearch.h"

@implementation ZHSearch

+ (instancetype)search
{
    ZHSearch *search = [[self alloc] init];
    // 设置背景图片
    [search setBackground:[UIImage imageNamed:@"searchbar_textfield_background"]];
    // 设置宽和高
    search.od_width = kScreenSize.width - 20;
    search.od_height = 30;
    
    // 添加左边放大镜图标
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    icon.od_width = 30;
    icon.od_height = 30;
    // 居中显示
    icon.contentMode = UIViewContentModeCenter;
//    search`
    search.leftView = icon;
    search.leftViewMode = UITextFieldViewModeAlways;
    
    return search;
}

@end

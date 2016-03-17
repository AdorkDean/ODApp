//
//  ODBazaarRequestHelpModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/7.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarRequestHelpModel.h"

@implementation ODBazaarRequestHelpTasksModel

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        CGFloat contentX = 68;
        CGFloat maxWidth = KScreenWidth - contentX - 15;
        CGFloat statusHeight = [@"任务开始" od_SizeWithFont:[UIFont systemFontOfSize:11.0f] maxWidth:maxWidth].height;
        
        CGFloat contentY = 14 + 16 + 8;
        
        CGSize contentSize = [self.content od_SizeWithFont:[UIFont systemFontOfSize:11.5f] maxWidth:maxWidth];
        if (contentSize.height > 28) contentSize.height = 28;
        _contentFrame = (CGRect){{contentX, contentY}, contentSize};
        
        CGFloat bottomMargin = 12.5 + statusHeight + 10;
        
        _cellHeight = CGRectGetMaxY(_contentFrame) + bottomMargin + 6;
    }
    
    return _cellHeight;
}

@end

@implementation ODBazaarRequestHelpModel

+ (void)initialize
{
    [ODBazaarRequestHelpModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"tasks":[ODBazaarRequestHelpTasksModel class]
                 };
    }];
}
@end

ODRequestResultIsDictionaryImplementation(ODBazaarRequestHelpModel)

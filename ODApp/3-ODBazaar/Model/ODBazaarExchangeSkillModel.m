//
//  ODBazaarExchangeSkillModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarExchangeSkillModel.h"
#import "ODBazaarPhotosView.h"

static CGFloat const bottomMargin = (30 / 2);
static CGFloat const photoBottomMargin = (25 / 2);

@implementation ODBazaarExchangeSkillUserModel

@end

@implementation ODBazaarExchangeSkillModel

@synthesize rowHeight = _rowHeight;

+ (void)initialize
{
    [ODBazaarExchangeSkillModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"imgs_small" :[ODBazaarExchangeSkillImgs_smallModel class],
                 @"imgs_big" :[ODBazaarExchangeSkillImgs_bigModel class]
                 };
    }];
}

/**
 *  计算行高
 */
- (CGFloat)rowHeight
{
    if (!_rowHeight) {
        // 计算名称文字高度
        CGFloat nameLabelHeight = [self.title od_SizeWithFont:[UIFont systemFontOfSize:11.5]].height;
        CGFloat nickLabelHeight = [self.user.nick od_SizeWithFont:[UIFont systemFontOfSize:11]].height;
        
        // 配图X/Y值
        CGFloat photosViewX = 75;
        CGFloat photosViewY = 45 + nameLabelHeight + nickLabelHeight;
        
        CGSize photosViewSize = [ODBazaarPhotosView zh_sizeWithConnt:self.imgs_small.count];
        _photosFrame = (CGRect){{photosViewX, photosViewY}, photosViewSize};
    
        // 计算正文文字高度
        CGFloat contentLabelHeight = [self.content od_SizeWithFont:[UIFont systemFontOfSize:11] maxWidth:(photosViewSize.width - 17 / 2)].height;
        
//        self.content
        if (contentLabelHeight >= 35) contentLabelHeight = 35;
        
        CGFloat loveHeight = [[NSString stringWithFormat:@"%d", self.love_num] od_SizeWithFont:[UIFont systemFontOfSize:9]].height;
        
        _rowHeight = CGRectGetMaxY(_photosFrame) + (bottomMargin * 2) +
                     (contentLabelHeight + photoBottomMargin) +
                     ODBazaaeExchangeCellMargin + loveHeight;
    }
    return _rowHeight;
}

@end

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_smallModel)

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_bigModel)

ODRequestResultIsArrayImplementation(ODBazaarExchangeSkillModel)

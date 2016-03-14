//
//  ODBazaarExchangeSkillModel.m
//  ODApp
//
//  Created by Odong-YG on 16/3/8.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarExchangeSkillModel.h"
#import "ODBazaarPhotosView.h"

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_smallModel)

ODRequestModelImplementation(ODBazaarExchangeSkillImgs_bigModel)


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


- (CGFloat)rowHeight
{
    if (!_rowHeight) {
        
        CGFloat bottomMargin = 30;
        
        // 计算名称文字高度
        CGFloat nameH = [self.title od_SizeWithFont:[UIFont systemFontOfSize:11.5]].height;
        CGFloat nickH = [self.user[@"nick"] od_SizeWithFont:[UIFont systemFontOfSize:11]].height;
        
        // 配图X/Y值
        CGFloat photosViewX = 75;
        CGFloat photosViewY = 45 + nameH + nickH;
        
        CGSize photosViewSize = [ODBazaarPhotosView zh_sizeWithConnt:self.imgs_small.count];
        
        _photosFrame = (CGRect){{photosViewX, photosViewY}, photosViewSize};
        
//        _rowHeight = ;
    
        // 计算正文文字高度
        CGFloat contentH = [self.content od_SizeWithFont:[UIFont systemFontOfSize:11] maxWidth:KScreenWidth - 75 - 35 / 2].height;
        
        CGFloat loveH = [[NSString stringWithFormat:@"%d", self.love_num] od_SizeWithFont:[UIFont systemFontOfSize:9]].height;
        
        _rowHeight = CGRectGetMaxY(_photosFrame) + bottomMargin + contentH + 25 / 2 + 6 + loveH;
        
    }
    
    return _rowHeight;
}


@end

ODRequestResultIsArrayImplementation(ODBazaarExchangeSkillModel)

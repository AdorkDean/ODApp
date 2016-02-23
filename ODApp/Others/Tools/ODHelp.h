//
//  ODHelp.h
//  ODApp
//
//  Created by Odong-YG on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ODHelp : NSObject

//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat) textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size;





@end

//
//  ODHelp.m
//  ODApp
//
//  Created by Odong-YG on 15/12/23.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
#import "ODAPPInfoTool.h"
#import "ODHelp.h"

@implementation ODHelp

+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}
//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    //iOS7之后
    /*
     第一个参数: 预设空间 宽度固定  高度预设 一个最大值
     第二个参数: 行间距
     第三个参数: 属性字典 可以设置字体大小
     */
    //xxxxxxxxxxxxxxxxxx
    //ghjdgkfgsfgskdgfjk
    //sdhgfsdjkhgfjd
    
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
//        NSString *str = [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;

        
}

//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度(可设置最小高度)
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat) textWidth miniHeight:(CGFloat)miniHeight fontSize:(CGFloat)size{

    //iOS7之后
    /*
     第一个参数: 预设空间 宽度固定  高度预设 一个最大值
     第二个参数: 行间距
     第三个参数: 属性字典 可以设置字体大小
     */
    //xxxxxxxxxxxxxxxxxx
    //ghjdgkfgsfgskdgfjk
    //sdhgfsdjkhgfjd

    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
    
    if (rect.size.height < miniHeight)
    {
        return miniHeight;
    }
    else
    {
        //返回计算出的行高
        return rect.size.height + 10;
    }
}



@end

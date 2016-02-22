//
//  ODRoundTimeDrawView.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODRoundTimeDrawView.h"

@implementation ODRoundTimeDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _firstTimeIsFree = YES;
        _secondTimeIsFree = YES;
        _thirdTimeIsFree = YES;
    }
    return self;
}

- (void)setFirstTimeIsFree:(BOOL)firstTimeIsFree
{
    _firstTimeIsFree = firstTimeIsFree;
    [self setNeedsDisplay];
}

- (void)setSecondTimeIsFree:(BOOL)secondTimeIsFree
{
    _secondTimeIsFree = secondTimeIsFree;
    [self setNeedsDisplay];
}

- (void)setThirdTimeIsFree:(BOOL)thirdTimeIsFree
{
    _thirdTimeIsFree = thirdTimeIsFree;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSArray *dataArray =  @[@1,@1,@1];
    
    //画第一个扇形
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = self.bounds.size.width;
    
    CGFloat startA = 0;
    CGFloat angle = 0;
    CGFloat endA = - M_PI_2;
    NSInteger index = 0;
    for (NSNumber *num in dataArray) {
        
        //画第二个扇形
        startA = endA;
        angle = num.intValue / 3.0 * M_PI * 2;
        endA = startA + angle;
        //画弧
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        
        //添加一根线到圆心
        [path addLineToPoint:center];
        UIColor *color;
        //设置颜色
        if (index == 0)
        {
            color = self.firstTimeIsFree ? [UIColor redColor] : [UIColor whiteColor];
        }
        else if (index == 1)
        {
            color = self.secondTimeIsFree ? [UIColor redColor] : [UIColor whiteColor];
        }
        else if (index == 2)
        {
            color = self.thirdTimeIsFree ? [UIColor redColor] : [UIColor whiteColor];
        }
        [color set];
        //填充
        [path stroke];
        [path fill];
        index ++;
    }
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    [[UIColor redColor]set];
    [path1 stroke];
    

}


@end

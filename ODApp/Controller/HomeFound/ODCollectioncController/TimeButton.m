//
//  TimeButton.m
//  ODApp
//
//  Created by zhz on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "TimeButton.h"

@implementation TimeButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
    }
    return self;

}


- (void)addViews
{
    
    
     self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    label1.backgroundColor = [UIColor blackColor];
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 0.5 , 0, 0.5, self.frame.size.height)];
    label2.backgroundColor = [UIColor blackColor];
    [self addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    label3.backgroundColor = [UIColor blackColor];
    [self addSubview:label3];
    
    
    
}


@end

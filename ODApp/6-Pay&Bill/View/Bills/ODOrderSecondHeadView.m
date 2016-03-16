//
//  ODOrderSecondHeadView.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderSecondHeadView.h"

@implementation ODOrderSecondHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        self.secondOrderView = [ODSecondOrderView getView];
        self.secondOrderView.frame = self.frame;
        [self addSubview:self.secondOrderView];
        
        
        
        
    }
    return self;
}




@end

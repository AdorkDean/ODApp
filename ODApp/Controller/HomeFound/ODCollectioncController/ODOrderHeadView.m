//
//  ODOrderHeadView.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderHeadView.h"

@implementation ODOrderHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        
        self.orderView = [ODOrderView getView];
        self.orderView.frame = self.frame;
        [self addSubview:self.orderView];
        
        
        
        
    }
    return self;
}




@end

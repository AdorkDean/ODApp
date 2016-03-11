//
//  ODOrderThirdHeadView.m
//  ODApp
//
//  Created by zhz on 16/2/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderThirdHeadView.h"

@implementation ODOrderThirdHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.thirdOrderView = [ODThirdOrderView getView];
        self.thirdOrderView.frame = self.frame;
        [self addSubview:self.thirdOrderView];
        
        
        
        
    }
    return self;
}





@end

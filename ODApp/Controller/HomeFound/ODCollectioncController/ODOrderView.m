//
//  ODOrderView.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderView.h"

@implementation ODOrderView

+(instancetype)getView
{
    ODOrderView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODOrderView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    
    return view;
    
    
    
    
}

@end

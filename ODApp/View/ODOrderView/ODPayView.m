//
//  ODPayView.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPayView.h"

@implementation ODPayView

+(instancetype)getView
{
    ODPayView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODPayView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    return view;
    
    
    
    
}

@end

//
//  ODSecondOrderView.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSecondOrderView.h"

@implementation ODSecondOrderView

+(instancetype)getView
{
    ODSecondOrderView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODSecondOrderView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
  
  
    return view;
    
    
    
    
}

@end

//
//  ODOrderDetailView.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderDetailView.h"

@implementation ODOrderDetailView


+(instancetype)getView
{
    ODOrderDetailView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODOrderDetailView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
    
    
    
    
}




@end

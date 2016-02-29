//
//  ODThirdOrderView.m
//  ODApp
//
//  Created by zhz on 16/2/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODThirdOrderView.h"

@implementation ODThirdOrderView
+(instancetype)getView
{
    ODThirdOrderView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODThirdOrderView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
 
    return view;
    
    
    
    
}

@end

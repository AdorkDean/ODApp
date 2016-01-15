//
//  ODBindingMobileView.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBindingMobileView.h"

@implementation ODBindingMobileView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ODBindingMobileView" owner:nil options:nil] firstObject];
    
}

@end

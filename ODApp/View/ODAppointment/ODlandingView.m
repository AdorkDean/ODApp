//
//  ODlandingView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODlandingView.h"

@implementation ODlandingView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ODlandingView" owner:nil options:nil] firstObject];
    
}

@end

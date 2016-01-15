//
//  ODRegisteredView.m
//  ODApp
//
//  Created by zhz on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODRegisteredView.h"

@implementation ODRegisteredView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ODRegisteredView" owner:nil options:nil] firstObject];
    
}

@end

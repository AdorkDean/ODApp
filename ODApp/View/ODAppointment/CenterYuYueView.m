//
//  CenterYuYueView.m
//  ODApp
//
//  Created by zhz on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterYuYueView.h"

@implementation CenterYuYueView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CenterYuYueView" owner:nil options:nil] firstObject];
    
}

@end

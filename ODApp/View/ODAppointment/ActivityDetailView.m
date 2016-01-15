//
//  ActivityDetailView.m
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ActivityDetailView.h"

@implementation ActivityDetailView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ActivityDetailView" owner:nil options:nil] firstObject];
    
}

@end

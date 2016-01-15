//
//  ODCenderDetailView.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenderDetailView.h"

@implementation ODCenderDetailView

+(instancetype)getView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ODCenderDetailView" owner:nil options:nil] firstObject];
    
}

@end

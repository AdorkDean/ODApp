//
//  ODOrderView.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderView.h"

@implementation ODOrderView

+(instancetype)getView
{
    ODOrderView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODOrderView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    
    return view;
    
    
    
    
}

@end

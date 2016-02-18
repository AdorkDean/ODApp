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
    view.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.messageTextView.scrollEnabled = NO;
    
    return view;
    
    
    
    
}

@end

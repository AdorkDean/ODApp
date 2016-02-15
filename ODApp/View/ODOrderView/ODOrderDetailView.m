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
    
    
    view.serviceTypeLabel.layer.masksToBounds = YES;
    view.serviceTypeLabel.layer.cornerRadius = 5;
    view.serviceTypeLabel.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    view.serviceTypeLabel.textColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.serviceTypeLabel.layer.borderWidth = 1;
    
    view.userButtonView.layer.masksToBounds = YES;
    view.userButtonView.layer.cornerRadius = 19;
    view.userButtonView.layer.borderColor = [UIColor clearColor].CGColor;
    view.userButtonView.layer.borderWidth = 1;

    
    view.firstLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.secondLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.thirdLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.fourthLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.fiveLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.sixLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.sevenLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.eightLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.nineLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    view.tenLabel.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    view.typeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    view.allPriceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
    return view;
    
    
    
    
}




@end
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
   ODCenderDetailView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODCenderDetailView" owner:nil options:nil] firstObject];
    
    if (iPhone4_4S) {
       view.scrollerHeight.constant = 210;
        
    }else if (iPhone5_5s) {
        
       view.scrollerHeight.constant = 210;
    }else if (iPhone6_6s) {
        
       view.scrollerHeight.constant = 270;
        
    }else {
        view.scrollerHeight.constant = 290;
    }

   view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    
    view.detailTextView.layer.masksToBounds = YES;
    view.detailTextView.layer.cornerRadius = 5;
    view.detailTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.detailTextView.layer.borderWidth = 1;
    view.detailTextView.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.detailTextView.scrollEnabled = NO;
    
    view.informationLabel.layer.masksToBounds = YES;
    view.informationLabel.layer.cornerRadius = 5;
    view.informationLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.informationLabel.layer.borderWidth = 1;
    
    view.appointmentButton.layer.masksToBounds = YES;
    view.appointmentButton.layer.cornerRadius = 5;
    view.appointmentButton.layer.borderColor = [UIColor colorWithHexString:@"b0b0b0" alpha:1].CGColor;
    view.appointmentButton.layer.borderWidth = 1;
    view.appointmentButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    [view.appointmentButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];

    
    view.firstLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.secondLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.thirdLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.fourLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.phoneLabel.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
    view.centerNameLabel.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
    view.addressTextView.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
    view.timeTextView.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.timeTextView.scrollEnabled = NO;
   
    
    return view;
    
}

@end

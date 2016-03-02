//
//  ODOrderDetailView.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderDetailView.h"

@implementation ODOrderDetailView

-(void)awakeFromNib
{

    self.lineOneHeightConstraint.constant = 0.5;
    self.lineTwoHeightConstraint.constant = 0.5;
    self.lineThreeHeightConstraint.constant = 0.5;
    self.lineFourHeightConstraint.constant = 0.5;
    self.lineFiveHeightConstraint.constant = 0.5;
    self.lineSixHeightConstraint.constant = 0.5;
    self.lineSevenHeightConstraint.constant = 0.5;
    
}


+(instancetype)getView
{
    ODOrderDetailView *view =  [[[NSBundle mainBundle] loadNibNamed:@"ODOrderDetailView" owner:nil options:nil] firstObject];
    
    
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    
    view.swapTypeLabel.layer.masksToBounds = YES;
    view.swapTypeLabel.layer.cornerRadius = 5;
    view.swapTypeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.swapTypeLabel.textColor = [UIColor lightGrayColor];
    view.swapTypeLabel.layer.borderWidth = 1;
    view.swapTypeLabel.textAlignment = NSTextAlignmentCenter;
    
    view.userButtonView.layer.masksToBounds = YES;
    view.userButtonView.layer.cornerRadius = 19;
    view.userButtonView.layer.borderColor = [UIColor clearColor].CGColor;
    view.userButtonView.layer.borderWidth = 1;

    
 
    
    view.typeLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    view.allPriceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    
    return view;
    
    
    
    
}




@end

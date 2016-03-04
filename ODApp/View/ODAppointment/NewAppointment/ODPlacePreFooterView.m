//
//  ODPlacePreFooterView.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPlacePreFooterView.h"
#import "UIView+ODPlaceView.h"

@implementation ODPlacePreFooterView

- (void)awakeFromNib
{
    [self.phoneBaseView od_setBorder];
    [self.submitBtn od_setBorder];
    self.pupurseTextView.placeholder_OD = @"请输入活动目的";
    self.contentTextView.placeholder_OD = @"请输入活动内容";
    self.numTextView.placeholder_OD = @"请输入参加人数";
    self.numTextView.keyboardType = UIKeyboardTypeNumberPad;
}

- (CGFloat)viewHeight
{
    [self.phoneBaseView layoutIfNeeded];
    return CGRectGetMaxY(self.submitBtn.frame);
}

- (IBAction)phoneClicked:(UIButton *)sender
{
    [self callToNum:sender.currentTitle];
}
@end

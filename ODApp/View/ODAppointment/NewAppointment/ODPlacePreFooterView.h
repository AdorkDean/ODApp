//
//  ODPlacePreFooterView.h
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODPlacePreTextView.h"

@interface ODPlacePreFooterView : UIView

/** 视图高度 */
@property (nonatomic,assign) CGFloat viewHeight;

@property (weak, nonatomic) IBOutlet ODPlacePreTextView *pupurseTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet ODPlacePreTextView *contentTextView;
@property (weak, nonatomic) IBOutlet ODPlacePreTextView *numTextView;
@property (weak, nonatomic) IBOutlet UIView *phoneBaseView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)phoneClicked:(UIButton *)sender;

@end

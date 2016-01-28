//
//  ODCenderDetailView.h
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODCenderDetailView : UIView


+(instancetype)getView;


@property (weak, nonatomic) IBOutlet UITextView *detailTextView;


@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (weak, nonatomic) IBOutlet UIButton *appointmentButton;



@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@property (weak, nonatomic) IBOutlet UITextView *addressTextView;


@property (weak, nonatomic) IBOutlet UITextView *timeTextView;



@property (weak, nonatomic) IBOutlet UILabel *firstLabel;


@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourLabel;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;

@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;



@end

//
//  ODPayView.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODPayView : UIView

@property(weak, nonatomic) IBOutlet UILabel *orderNameLabel;

@property(weak, nonatomic) IBOutlet UILabel *firstLineLabel;
@property(weak, nonatomic) IBOutlet UILabel *secondLineLabel;
@property(weak, nonatomic) IBOutlet UILabel *thirdLineLabel;
@property(weak, nonatomic) IBOutlet UILabel *fourthLineLabel;

@property(weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

@property(weak, nonatomic) IBOutlet UIButton *weixinPaybutton;


@property(weak, nonatomic) IBOutlet UILabel *priceLabel;


@property(weak, nonatomic) IBOutlet UIButton *payButton;

@property(weak, nonatomic) IBOutlet UIImageView *treasureImageView;
@property(weak, nonatomic) IBOutlet UILabel *treasureLabel;

@property(weak, nonatomic) IBOutlet UIButton *treasurePayButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLineLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthLineLabelConstraint;

+ (instancetype)getView;


@end

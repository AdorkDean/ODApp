//
//  ActivityDetailView.h
//  ODApp
//
//  Created by zhz on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHight;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *baoMingButton;




@property (weak, nonatomic) IBOutlet UILabel *disitionLabel;


@property (weak, nonatomic) IBOutlet UIButton *centerNameButton;



@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

+(instancetype)getView;


@end

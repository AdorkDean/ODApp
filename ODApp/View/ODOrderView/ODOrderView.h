//
//  ODOrderView.h
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODOrderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *addressImgeView;



@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *choseTimeView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


+(instancetype)getView;

@end

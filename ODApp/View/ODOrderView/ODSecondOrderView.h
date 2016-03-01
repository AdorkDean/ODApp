//
//  ODSecondOrderView.h
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODSecondOrderView : UIView

@property(weak, nonatomic) IBOutlet UILabel *typeLabel;


@property(weak, nonatomic) IBOutlet UILabel *addressLabel;

@property(weak, nonatomic) IBOutlet UIImageView *addressImgeView;


+ (instancetype)getView;


@end

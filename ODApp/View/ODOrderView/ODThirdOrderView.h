//
//  ODThirdOrderView.h
//  ODApp
//
//  Created by zhz on 16/2/24.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODThirdOrderView : UIView





@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *choseTimeView;

+(instancetype)getView;

@end

//
//  ODPaySuccessView.h
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODPaySuccessView : UIView

@property(nonatomic, weak) IBOutlet UIImageView *isSuccessView;

@property(nonatomic, weak) IBOutlet UILabel *isSuccessLabel;


@property(nonatomic, weak) IBOutlet UIButton *firstButton;
@property(nonatomic, weak) IBOutlet UIButton *secondButton;

+ (instancetype)getView;

@end

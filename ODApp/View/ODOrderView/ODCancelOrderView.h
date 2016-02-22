//
//  ODCancelOrderView.h
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODCancelOrderView : UIView


@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;


@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;



+(instancetype)getView;

@end

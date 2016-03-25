//
//  ODSubmitView.h
//  ODApp
//
//  Created by Bracelet on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODSubmitView : UIView

@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *enterImageView;


@end

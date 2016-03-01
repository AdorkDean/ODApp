//
//  ODInformationView.h
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODInformationView : UIView

+ (instancetype)getView;

@property(weak, nonatomic) IBOutlet UIImageView *userImageView;
@property(weak, nonatomic) IBOutlet UIImageView *signatureImageView;
@property(weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property(weak, nonatomic) IBOutlet UIImageView *nickNameImageView;
@property(weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property(weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property(weak, nonatomic) IBOutlet UILabel *genderLabel;
@property(weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property(weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property(weak, nonatomic) IBOutlet UIImageView *passWordImageView;
@property(weak, nonatomic) IBOutlet UIImageView *codeImageView;


@end

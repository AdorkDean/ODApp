//
//  CenterYuYueView.m
//  ODApp
//
//  Created by zhz on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "CenterYuYueView.h"
#import "ODClassMethod.h"
@implementation CenterYuYueView

+(instancetype)getView
{
    CenterYuYueView *view =  [[[NSBundle mainBundle] loadNibNamed:@"CenterYuYueView" owner:nil options:nil] firstObject];
    
    
    
    if (iPhone4_4S) {
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 100);
    }else if (iPhone5_5s)
    {
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 50);
    }else if (iPhone6_6s) {
        
       view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 70);
    }else {
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
    }
    

    
    
    view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    
    view.computerButton.layer.masksToBounds = YES;
    view.computerButton.layer.cornerRadius = 2;
    view.computerButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.computerButton.layer.borderWidth = 1;
    
    
    
    view.touYingButton.layer.masksToBounds = YES;
    view.touYingButton.layer.cornerRadius = 2;
    view.touYingButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.touYingButton.layer.borderWidth = 1;

    
    
    view.yinXiangButton.layer.masksToBounds = YES;
    view.yinXiangButton.layer.cornerRadius = 2;
    view.yinXiangButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.yinXiangButton.layer.borderWidth = 1;
    
    view.maiButton.layer.masksToBounds = YES;
    view.maiButton.layer.cornerRadius = 2;
    view.maiButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.maiButton.layer.borderWidth = 1;
    
    
    view.sheBeiLabel.layer.masksToBounds = YES;
    view.sheBeiLabel.layer.cornerRadius = 5;
    view.sheBeiLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.sheBeiLabel.layer.borderWidth = 1;
    
    
    view.pursoseTextView.layer.masksToBounds = YES;
    view.pursoseTextView.layer.cornerRadius = 5;
    view.pursoseTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.pursoseTextView.layer.borderWidth = 1;
    
    
    view.contentTextView.layer.masksToBounds = YES;
    view.contentTextView.layer.cornerRadius = 5;
    view.contentTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.contentTextView.layer.borderWidth = 1;
    
    
    view.peopleNumberTextField.layer.masksToBounds = YES;
    view.peopleNumberTextField.layer.cornerRadius = 5;
    view.peopleNumberTextField.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.peopleNumberTextField.layer.borderWidth = 1;
    
    
    view.phoneLabel.layer.masksToBounds = YES;
    view.phoneLabel.layer.cornerRadius = 5;
    view.phoneLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.phoneLabel.layer.borderWidth = 1;
    
    
    
    view.yuYueButton.layer.masksToBounds = YES;
    view.yuYueButton.layer.cornerRadius = 5;
    view.yuYueButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.yuYueButton.layer.borderWidth = 1;
    view.yuYueButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    
    [view.yuYueButton setTitleColor:[UIColor colorWithHexString:@"#49494b" alpha:1]
                                     forState:UIControlStateNormal];
    
    
    
    view.beginText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.endText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.sheBeiText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.purposeText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.contentText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.peopleNumberText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    view.btimeText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.eTimeText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.computerText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.touyingText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.yinxiangText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.yuYueText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    view.centerText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
    
    
    view.centerText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 5);
    view.centerText.layer.masksToBounds = YES;
    view.centerText.layer.cornerRadius = 5;
    view.centerText.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.centerText.layer.borderWidth = 1;
    view.centerText.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    UIImageView *lImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 30, 5, 15, 15) imageName:@"场地预约icon2" tag:0];
    
    [view.centerText addSubview:lImage];
    
    
    
    [view.phoneText setTitleColor:[UIColor colorWithHexString:@"#004ed9" alpha:1]
                                   forState:UIControlStateNormal];
    
    
    
    view.pursoseTextView.textColor = [UIColor lightGrayColor];
    view.pursoseTextView.text = NSLocalizedString(@"输入活动目的", nil);
    
    
    view.contentTextView.textColor = [UIColor lightGrayColor];
    view.contentTextView.text = NSLocalizedString(@"输入活动内容", nil);
    
    
    
    if (iPhone6_6s) {
        
        
        view.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
        view.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
        
        
        UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [ view.btimeText addSubview:image];
        
        
        UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [ view.eTimeText addSubview:images];
        
        
        
        
    } else if (iPhone4_4S || iPhone5_5s)
    {
        
        view.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
        view.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
        
        
        UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width - 25, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [ view.btimeText addSubview:image];
        
        
        
        UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width - 25, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [view.eTimeText addSubview:images];
        
        
    }
    else
    {
        
        view.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 9);
        view.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 9);
        
        
        UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width + 20, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [ view.btimeText addSubview:image];
        
        
        
        UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(view.btimeText.frame.size.width + 20, 6, 15, 15) imageName:@"downjiantou" tag:0];
        [ view.eTimeText addSubview:images];
        
        
        
    }
    
    
    
    
    view.btimeText.layer.masksToBounds = YES;
    view.btimeText.layer.cornerRadius = 5;
    view.btimeText.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.btimeText.layer.borderWidth = 1;
    
    view.eTimeText.layer.masksToBounds = YES;
    view.eTimeText.layer.cornerRadius = 5;
    view.eTimeText.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    view.eTimeText.layer.borderWidth = 1;
    
    
    view.peopleNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
  
    
    
    
    return view;
}



@end

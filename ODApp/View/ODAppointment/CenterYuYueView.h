//
//  CenterYuYueView.h
//  ODApp
//
//  Created by zhz on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterYuYueView : UIView


+(instancetype)getView;


@property (weak, nonatomic) IBOutlet UIButton *computerButton;
@property (weak, nonatomic) IBOutlet UIButton *touYingButton;
@property (weak, nonatomic) IBOutlet UIButton *yinXiangButton;
@property (weak, nonatomic) IBOutlet UIButton *maiButton;
@property (weak, nonatomic) IBOutlet UIView *sheBeiLabel;
@property (weak, nonatomic) IBOutlet UITextView *pursoseTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *peopleNumberTextField;
@property (weak, nonatomic) IBOutlet UIView *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginText;
@property (weak, nonatomic) IBOutlet UILabel *endText;
@property (weak, nonatomic) IBOutlet UILabel *sheBeiText;
@property (weak, nonatomic) IBOutlet UILabel *purposeText;
@property (weak, nonatomic) IBOutlet UILabel *contentText;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberText;
@property (weak, nonatomic) IBOutlet UIButton *btimeText;
@property (weak, nonatomic) IBOutlet UIButton *eTimeText;
@property (weak, nonatomic) IBOutlet UIButton *centerText;
@property (weak, nonatomic) IBOutlet UILabel *computerText;
@property (weak, nonatomic) IBOutlet UILabel *touyingText;
@property (weak, nonatomic) IBOutlet UILabel *yinxiangText;
@property (weak, nonatomic) IBOutlet UILabel *yuYueText;
@property (weak, nonatomic) IBOutlet UIButton *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *yuYueButton;



@end

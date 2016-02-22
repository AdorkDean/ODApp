//
//  ODDrawbackBuyerController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDrawbackBuyerController.h"


NSString * const ODDrawbackBuyerCELL = @"ODDrawbackBuyerCELL";
@interface ODDrawbackBuyerController ()

@end

@implementation ODDrawbackBuyerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退款";
    [self createScrollView];
}


- (void)createScrollView
{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:self.scrollView];
    
    float drawBackHeight = 43;
    
    self.drawbackMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, drawBackHeight)];
    self.drawbackMoneyLabel.text = [NSString stringWithFormat:@"您的退款金额：%.1f元",0.4];
    self.drawbackMoneyLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackMoneyLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.drawbackMoneyLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyLabel];
    
    self.drawbackReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22)];
    self.drawbackReasonLabel.text = @"      退款原因";
    self.drawbackReasonLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackReasonLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackReasonLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackReasonLabel];
    
    float drawBackReasonHeight = 40;
    
    self.placeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonLabel.frame), ODLeftMargin, drawBackReasonHeight * 5 + 4)];
    self.placeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.placeView];
    
    self.drawbackReasonOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawBackReasonHeight)];
    self.drawbackReasonOneLabel.text = @"      卖家自身原因无法服务";
    self.drawbackReasonOneLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonOneLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonOneLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackReasonOneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonOneLabel];
    
    self.drawbackReasonOneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"buy_icon"] forState:UIControlStateHighlighted];
    [self.drawbackReasonOneLabel addSubview:self.drawbackReasonOneButton];
    
    
    self.drawbackReasonTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonOneLabel.frame) + 1, KScreenWidth, drawBackReasonHeight)];
    self.drawbackReasonTwoLabel.text = @"      对服务质量不满意";
    self.drawbackReasonTwoLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonTwoLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonTwoLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackReasonTwoLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonTwoLabel];
    
    self.drawbackReasonTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.drawbackReasonTwoLabel addSubview:self.drawbackReasonTwoButton];
    
    
    self.drawbackReasonThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonTwoLabel.frame) + 1, KScreenWidth, drawBackReasonHeight)];
    self.drawbackReasonThreeLabel.text = @"      未按时交付服务";
    self.drawbackReasonThreeLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonThreeLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonThreeLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackReasonThreeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonThreeLabel];
    
    self.drawbackReasonThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.drawbackReasonThreeLabel addSubview:self.drawbackReasonThreeButton];
    
    
    self.drawbackReasonFourLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonThreeLabel.frame) + 1, KScreenWidth, drawBackReasonHeight)];
    self.drawbackReasonFourLabel.text = @"      双方已协商好退款";
    self.drawbackReasonFourLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonFourLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonFourLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackReasonFourLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonFourLabel];
    
    self.drawbackReasonFourButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.drawbackReasonFourLabel addSubview:self.drawbackReasonFourButton];
    
    
    self.drawbackReasonOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonFourLabel.frame) + 1, KScreenWidth, drawBackReasonHeight)];
    self.drawbackReasonOtherLabel.text = @"      其它";
    self.drawbackReasonOtherLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonOtherLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonOtherLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackReasonOtherLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonOtherLabel];
    
    self.drawbackReasonOtherButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.drawbackReasonFourLabel addSubview:self.drawbackReasonOtherButton];
    
    
    self.drawbackStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonOtherLabel.frame), KScreenWidth, 22)];
    self.drawbackStateLabel.text = @"      退款说明";
    self.drawbackStateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackStateLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackStateLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackStateLabel];
    
    self.drawbackStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackStateLabel.frame), KScreenWidth, 150)];
    self.drawbackStateTextView.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackStateTextView.font = [UIFont systemFontOfSize:12];
    self.drawbackStateTextView.delegate = self;
    [self.scrollView addSubview:self.drawbackStateTextView];
    
    
    self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 10, kScreenSize.width-35, 20)];
    self.contentPlaceholderLabel.text = @"请输入适当的退款理由";
    self.contentPlaceholderLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.contentPlaceholderLabel.font = [UIFont systemFontOfSize:14];
    self.contentPlaceholderLabel.userInteractionEnabled = NO;
    [self.drawbackStateTextView addSubview:self.contentPlaceholderLabel];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end

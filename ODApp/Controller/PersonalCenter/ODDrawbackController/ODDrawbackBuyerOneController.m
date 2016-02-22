//
//  ODDrawbackBuyerOneController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDrawbackBuyerOneController.h"

@interface ODDrawbackBuyerOneController ()

@end

@implementation ODDrawbackBuyerOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退款";
//    self.isSelectReason = YES;
//    self.isService = YES;
//    self.isRelease = YES;
//    self.isDrawbackState = YES;
//    self.isRefuseAndReceive = YES;
    [self createScrollView];
}


- (void)createScrollView
{

    float scrollViewHeight;
    if (self.isRefuseAndReceive || self.isRelease) {
        scrollViewHeight = KControllerHeight - ODNavigationHeight - 50;
    }
    else{
        scrollViewHeight = KControllerHeight - ODNavigationHeight;
    }
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, scrollViewHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.view addSubview:self.scrollView];
    
    float drawBackHeight = 43;
    
    float drawbackReasonHeight;
    if (self.isSelectReason) {
        drawbackReasonHeight = (drawBackHeight + 1) * 5 - 1;
    }
    else{
       drawbackReasonHeight = drawBackHeight;
    }
    
    self.darwbackMoney = @"0.1";
    self.drawbackMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, drawBackHeight)];
    self.drawbackMoneyLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    
    NSString *drawbackMoneyStr = [NSString stringWithFormat:@"您的退款金额:%@元",self.darwbackMoney];
    NSMutableAttributedString *moneyNumberStr = [[NSMutableAttributedString alloc]initWithString:drawbackMoneyStr];
    [moneyNumberStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange([moneyNumberStr length] - self.darwbackMoney.length -1, self.darwbackMoney.length)];
    self.drawbackMoneyLabel.attributedText = moneyNumberStr;
    self.drawbackMoneyLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.drawbackMoneyLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyLabel];
    

    
    self.drawbackMoneyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.drawbackMoneyLabel.frame), 0, KScreenWidth - CGRectGetMaxX(self.drawbackMoneyLabel.frame), drawBackHeight)];
    self.drawbackMoneyNumberLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    self.drawbackMoneyNumberLabel.text = [NSString stringWithFormat:@"%@",self.darwbackMoney];
    self.drawbackMoneyNumberLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackMoneyNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.drawbackMoneyNumberLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyNumberLabel];
    
    
    self.drawbackReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22)];
    self.drawbackReasonLabel.text = @"退款原因";
    self.drawbackReasonLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackReasonLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackReasonLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackReasonLabel];
    
    self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawbackReasonHeight)];
    self.drawbackReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentView];
    
    
    if (self.isSelectReason) {
        
        float reasonLabelLeftMargin = 25;
        
        self.drawbackReasonOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + reasonLabelLeftMargin, 0, KScreenWidth, drawBackHeight)];
        self.drawbackReasonOneLabel.text = @"卖家自身原因无法服务";
        self.drawbackReasonOneLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonOneLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonOneLabel.textAlignment = NSTextAlignmentLeft;
        self.drawbackReasonOneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonOneLabel];
        
        self.drawbackReasonOneButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, 12.5, 20, 20)];
        [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        [self.drawbackReasonOneButton addTarget:self action:@selector(drawbackReasonOneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonOneButton];
        
        
        self.drawbackReasonTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + reasonLabelLeftMargin, CGRectGetMaxY(self.drawbackReasonOneLabel.frame) + 1, KScreenWidth, drawBackHeight)];
        self.drawbackReasonTwoLabel.text = @"对服务质量不满意";
        self.drawbackReasonTwoLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonTwoLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonTwoLabel.textAlignment = NSTextAlignmentLeft;
        self.drawbackReasonTwoLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonTwoLabel];
        
        self.drawbackReasonTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonOneLabel.frame) + 1 + 12.5, 20, 20)];
        [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        [self.drawbackReasonTwoButton addTarget:self action:@selector(drawbackReasonTwoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.drawbackReasonContentView addSubview:self.drawbackReasonTwoButton];
        
        
        self.drawbackReasonThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + reasonLabelLeftMargin, CGRectGetMaxY(self.drawbackReasonTwoLabel.frame) + 1, KScreenWidth, drawBackHeight)];
        self.drawbackReasonThreeLabel.text = @"未按时交付服务";
        self.drawbackReasonThreeLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonThreeLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonThreeLabel.textAlignment = NSTextAlignmentLeft;
        self.drawbackReasonThreeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonThreeLabel];
        
        self.drawbackReasonThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonTwoLabel.frame) + 1 + 12.5, 20, 20)];
        [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        [self.drawbackReasonThreeButton addTarget:self action:@selector(drawbackReasonThreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.drawbackReasonContentView addSubview:self.drawbackReasonThreeButton];
        
        
        self.drawbackReasonFourLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin + reasonLabelLeftMargin, CGRectGetMaxY(self.drawbackReasonThreeLabel.frame) + 1, KScreenWidth, drawBackHeight)];
        self.drawbackReasonFourLabel.text = @"双方已协商好退款";
        self.drawbackReasonFourLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonFourLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonFourLabel.textAlignment = NSTextAlignmentLeft;
        self.drawbackReasonFourLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonFourLabel];
        
        self.drawbackReasonFourButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonThreeLabel.frame) + 1 + 12.5, 20, 20)];
        [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        [self.drawbackReasonFourButton addTarget:self action:@selector(drawbackReasonFourButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.drawbackReasonContentView addSubview:self.drawbackReasonFourButton];
        
        
        self.drawbackReasonOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin +reasonLabelLeftMargin, CGRectGetMaxY(self.drawbackReasonFourLabel.frame) + 1, KScreenWidth, drawBackHeight)];
        self.drawbackReasonOtherLabel.text = @"其它";
        self.drawbackReasonOtherLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonOtherLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonOtherLabel.textAlignment = NSTextAlignmentLeft;
        self.drawbackReasonOtherLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.drawbackReasonContentView addSubview:self.drawbackReasonOtherLabel];
        
        self.drawbackReasonOtherButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonFourLabel.frame) + 1 + 12.5, 20, 20)];
        [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        [self.drawbackReasonOtherButton addTarget:self action:@selector(drawbackReasonOtherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.drawbackReasonContentView addSubview:self.drawbackReasonOtherButton];
        
        for (int i = 1; i < 5; i++) {
            self.drawbackReasonLineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, drawBackHeight * i, KScreenWidth, 1)];
            self.drawbackReasonLineView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
            [self.drawbackReasonContentView addSubview:self.drawbackReasonLineView];
        }
    }
    else
    {
        self.drawbackReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth, drawBackHeight)];
        self.drawbackReasonContentLabel.text = [NSString stringWithFormat:@"%@",self.drawbackReason];
        self.drawbackReasonContentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonContentLabel.textAlignment = NSTextAlignmentLeft;
        [self.drawbackReasonContentView addSubview:self.drawbackReasonContentLabel];
    }
    
    float serviceGetMaxY;
    if (self.isDrawbackState) {
        serviceGetMaxY = CGRectGetMaxY(self.drawbackReasonContentView.frame) + 22 + 150;
        [self drawbackStateView];
    }
    else{
        serviceGetMaxY = CGRectGetMaxY(self.drawbackReasonContentView.frame);
    }
    
    if (self.isService) {
        self.contactServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, serviceGetMaxY, KScreenWidth, 22)];
        self.contactServiceLabel.text = @"联系客服";
        self.contactServiceLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.contactServiceLabel.font = [UIFont systemFontOfSize:12];
        self.contactServiceLabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:self.contactServiceLabel];
        
        self.servicePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contactServiceLabel.frame), KScreenWidth, drawBackHeight)];
        self.servicePhoneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.servicePhoneView];
        
        
        self.servicePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, 70, drawBackHeight)];
        self.servicePhoneLabel.text = @"客服电话：";
        self.servicePhoneLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.servicePhoneLabel.font = [UIFont systemFontOfSize:13.5];
        self.servicePhoneLabel.textAlignment = NSTextAlignmentLeft;
        self.servicePhoneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.servicePhoneView addSubview:self.servicePhoneLabel];
        
        self.servicePhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.servicePhoneLabel.frame), 0, 200, drawBackHeight)];
        [self.servicePhoneButton setTitle:[NSString stringWithFormat:@"%@",self.servicePhone] forState:UIControlStateNormal];
        self.servicePhoneButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        self.servicePhoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.servicePhoneButton setTitleColor:[UIColor colorWithHexString:@"#3c63a2" alpha:1] forState:UIControlStateNormal];
        [self.servicePhoneView addSubview:self.servicePhoneButton];
        
        self.serviceTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, drawBackHeight)];
        self.serviceTimeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.serviceTimeView];
        
        self.serviceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, drawBackHeight)];
        self.serviceTimeLabel.text = [NSString stringWithFormat:@"%@时间：%@",self.customerService, self.serviceTime];
        self.serviceTimeLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.serviceTimeLabel.font = [UIFont systemFontOfSize:13.5];
        self.serviceTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.serviceTimeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.serviceTimeLabel];
    }
    
    float scrollContentHeight;
    
    if (self.isService) {
        scrollContentHeight = CGRectGetMaxY(self.serviceTimeLabel.frame);
    }else if (self.isDrawbackState){
        scrollContentHeight = CGRectGetMaxY(self.drawbackStateContentView.frame);
    }else{
        scrollContentHeight = CGRectGetMaxY(self.drawbackReasonContentView.frame);
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,scrollContentHeight );
    
    if (self.isRelease) {
        self.releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KControllerHeight - ODNavigationHeight - 50, KScreenWidth, 50)];
        [self.releaseButton setTitle:@"提交" forState:UIControlStateNormal];
        self.releaseButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        self.releaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.releaseButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.releaseButton];
        
    }
    
    if (self.isRefuseAndReceive) {
        self.refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KControllerHeight - ODNavigationHeight - 50, KScreenWidth / 2, 50)];
        [self.refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        self.refuseButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        self.refuseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.refuseButton.backgroundColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1];
        [self.refuseButton addTarget:self action:@selector(refuseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.refuseButton];
        
        self.receiveButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth / 2, KControllerHeight - ODNavigationHeight - 50, KScreenWidth / 2, 50)];
        [self.receiveButton setTitle:@"接受" forState:UIControlStateNormal];
        self.receiveButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        self.receiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.receiveButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.releaseButton addTarget:self action:@selector(receiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.receiveButton];
    }
}


-(UIView *)drawbackStateView
{

    if (!_drawbackStateView) {
        _drawbackStateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonContentView.frame), KScreenWidth, 22 + 150)];
        self.servicePhoneView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        [self.scrollView addSubview:_drawbackStateView];
        
        self.drawbackStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth, 22)];
        self.drawbackStateLabel.text = @"退款说明";
        self.drawbackStateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.drawbackStateLabel.font = [UIFont systemFontOfSize:12];
        self.drawbackStateLabel.textAlignment = NSTextAlignmentLeft;
        [_drawbackStateView addSubview:self.drawbackStateLabel];
        
        self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackStateLabel.frame), KScreenWidth, 150)];
        self.drawbackReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [_drawbackStateView addSubview:self.drawbackReasonContentView];
        
        self.drawbackStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth - ODLeftMargin * 2, 150)];
        self.drawbackStateTextView.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackStateTextView.font = [UIFont systemFontOfSize:12];
        self.drawbackStateTextView.text = [NSString stringWithFormat:@"%@",self.drawbackState];
        self.drawbackStateTextView.delegate = self;
        [self.drawbackReasonContentView addSubview:self.drawbackStateTextView];
        
        self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 10, kScreenSize.width-35, 20)];
        self.contentPlaceholderLabel.text = @"请输入适当的退款理由";
        self.contentPlaceholderLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
        self.contentPlaceholderLabel.font = [UIFont systemFontOfSize:14];
        self.contentPlaceholderLabel.userInteractionEnabled = NO;
        [self.drawbackStateTextView addSubview:self.contentPlaceholderLabel];
        
        
    }
    return _drawbackStateView;
}


#pragma mark - Action

#pragma mark - 退款原因点击事件
-(void)drawbackReasonOneButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonOne) {
        [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonOne = !self.isSelectedReasonOne;
        
        if (self.isSelectedReasonTwo) {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree) {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour) {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther) {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonTwoButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonTwo) {
        [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        
        if (self.isSelectedReasonOne) {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonThree) {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour) {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther) {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonThreeButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonThree) {
        [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonThree = !self.isSelectedReasonThree;
        
        if (self.isSelectedReasonOne) {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo) {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonFour) {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther) {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonFourButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonFour) {
        [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonFour = !self.isSelectedReasonFour;
        
        if (self.isSelectedReasonOne) {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo) {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree) {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonOther) {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonOtherButtonClick:(UIButton *)button
{
    
    if (!self.isSelectedReasonOther) {
        [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonOther = !self.isSelectedReasonOther;
        
        if (self.isSelectedReasonOne) {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo) {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree) {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour) {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
    }    
    if (self.isSelectedReasonOther) {
        
        self.drawbackStateView.hidden = NO;
    }
    else {
        self.drawbackStateView.hidden = YES;
    }
}

#pragma mark - 拒绝 按钮点击事件
- (void)refuseButtonClick:(UIButton *)button
{

    
}

#pragma mark - 接受 按钮点击事件
- (void)receiveButtonClick:(UIButton *)button
{

    
}


#pragma mark - 提交 按钮点击事件
-(void)releaseButtonClick:(UIButton *)button
{
    if (self.isSelectedReasonOne) {
        self.drawbackReason = self.drawbackReasonOneLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonTwo) {
        self.drawbackReason = self.drawbackReasonTwoLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonThree) {
        self.drawbackReason = self.drawbackReasonThreeLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonFour) {
        self.drawbackReason = self.drawbackReasonFourLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonOther) {
        self.drawbackReason = self.drawbackStateTextView.text;
        [self releaseDrawbackRequest];
    }
}

- (void)refuseDrawbackRequest
{

    self.managerRefuse = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.managerRefuse GET:ODRefuseDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"已拒绝"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)receiveDrawbackRequest
{

    self.managerReceive = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.managerReceive GET:ODReceiveDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"已接受"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


- (void)releaseDrawbackRequest{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:ODReleaseDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        

        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"退款成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

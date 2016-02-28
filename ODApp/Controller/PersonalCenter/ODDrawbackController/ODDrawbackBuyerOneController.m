//
//  ODDrawbackBuyerOneController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDrawbackBuyerOneController.h"
#import "ODCancelOrderView.h"
@interface ODDrawbackBuyerOneController ()

@property (nonatomic ,strong) ODCancelOrderView *cancelOrderView;



@end

@implementation ODDrawbackBuyerOneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.drawbackTitle;

    self.view.userInteractionEnabled = YES;
    [self createScrollView];
}

#pragma mark - Create UIScrollView
- (void)createScrollView
{
    #pragma mark - 动态设置 ScrollView 的高度
    float scrollViewHeight;
    if (self.isRefuseAndReceive || self.isRelease)
    {
        scrollViewHeight = KControllerHeight - ODNavigationHeight - 50;
    }
    else
    {
        scrollViewHeight = KControllerHeight - ODNavigationHeight;
    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, scrollViewHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.view addSubview:self.scrollView];
    
    #pragma mark - 动态设置 退款理由 的高度
    float drawBackHeight = 43;
    float drawbackReasonHeight;
    if (self.isSelectReason)
    {
        drawbackReasonHeight = (drawBackHeight + 1) * 5 - 1;
    }
    else
    {
        self.drawbackReasonContentLabel.text = self.drawbackReason;
       drawbackReasonHeight = [ODHelp textHeightFromTextString:self.drawbackReasonContentLabel.text width:KScreenWidth - 2 * ODLeftMargin miniHeight:drawBackHeight fontSize:13.5];
    }
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
 
    self.drawbackReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22)];
    self.drawbackReasonLabel.text = @"退款原因";
    self.drawbackReasonLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackReasonLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackReasonLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackReasonLabel];
    
    self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawbackReasonHeight)];
    self.drawbackReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentView];
    
    #pragma mark - 退款原因版块 可选择
    if (self.isSelectReason)
    {
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
        
        for (int i = 1; i < 5; i++)
        {
            self.drawbackReasonLineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, drawBackHeight * i, KScreenWidth, 1)];
            self.drawbackReasonLineView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
            [self.drawbackReasonContentView addSubview:self.drawbackReasonLineView];
        }
    }
    #pragma mark - 退款原因版块 不可选择
    else
    {
        
        self.drawbackReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth - 2 * ODLeftMargin, drawbackReasonHeight)];
        if (self.drawbackReason == nil)
        {
            self.drawbackReason = @"";
        }
        
        self.drawbackReasonContentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.drawbackReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        self.drawbackReasonContentLabel.textAlignment = NSTextAlignmentLeft;
        [self.drawbackReasonContentView addSubview:self.drawbackReasonContentLabel];
    }
    
    #pragma mark - 显示 拒绝原因 版块
    if (self.isRefuseReason)
    {
        self.refuseReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonContentView.frame), KScreenWidth, 22)];
        if (self.refuseReason == nil) {
            self.refuseReason = @"";
        }
        self.refuseReasonLabel.text = @"拒绝原因";
        self.refuseReasonLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.refuseReasonLabel.font = [UIFont systemFontOfSize:12];
        self.refuseReasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:self.refuseReasonLabel];
        
        self.refuseReasonContentLabel.text = self.refuseReason;
        self.refuseReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.refuseReasonLabel.frame), KScreenWidth, [ODHelp textHeightFromTextString:self.refuseReasonContentLabel.text width:KScreenWidth - 2 * ODLeftMargin miniHeight:drawBackHeight fontSize:13.5])];
        self.refuseReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.refuseReasonContentView];
        
        self.refuseReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth, [ODHelp textHeightFromTextString:self.refuseReasonContentLabel.text width:KScreenWidth - 2 * ODLeftMargin miniHeight:drawBackHeight fontSize:13.5])];
        self.refuseReasonContentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.refuseReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        self.refuseReasonContentLabel.textAlignment = NSTextAlignmentLeft;
        [self.refuseReasonContentView addSubview:self.refuseReasonContentLabel];
    }
    
    #pragma mark - 动态设置 联系客服GetMaxY
    float serviceGetMaxY;
    if (self.isDrawbackState)
    {
        serviceGetMaxY = CGRectGetMaxY(self.drawbackReasonContentView.frame) + 22 + 150;
        [self drawbackStateView];
    }
    else if (self.isRefuseReason)
    {
        serviceGetMaxY = CGRectGetMaxY(self.refuseReasonContentView.frame);
    }
    else
    {
        serviceGetMaxY = CGRectGetMaxY(self.drawbackReasonContentView.frame);
    }
    
    #pragma mark - 显示 联系客服 版块
    if (self.isService)
    {
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
        [self.servicePhoneButton addTarget:self action:@selector(servicePhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    #pragma mark - 动态设置 ScrollView ContentSize
    float scrollContentHeight;
    if (self.isService)
    {
        scrollContentHeight = CGRectGetMaxY(self.serviceTimeLabel.frame);
    }
    else if (self.isDrawbackState)
    {
        scrollContentHeight = CGRectGetMaxY(self.drawbackStateContentView.frame);
    }
    else
    {
        scrollContentHeight = CGRectGetMaxY(self.drawbackReasonContentView.frame);
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,scrollContentHeight );
    
    #pragma mark - 显示 申请退款按钮
    if (self.isRelease)
    {
        self.releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KControllerHeight - ODNavigationHeight - 50, KScreenWidth, 50)];
        [self.releaseButton setTitle:self.confirmButtonContent forState:UIControlStateNormal];
        self.releaseButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        self.releaseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.releaseButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.releaseButton];        
    }
    
    #pragma mark - 显示 拒绝and接受按钮
    if (self.isRefuseAndReceive)
    {
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
        [self.receiveButton addTarget:self action:@selector(receiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.receiveButton];
    }
}

#pragma mark - 懒加载（退款说明）
-(UIView *)drawbackStateView
{
    if (!_drawbackStateView)
    {
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
        if (self.drawbackState == nil)
        {
            self.drawbackState = @"";
        }
        
        self.drawbackStateTextView.text = self.drawbackState;
        self.drawbackStateTextView.delegate = self;
        [self.drawbackReasonContentView addSubview:self.drawbackStateTextView];
        
        self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenSize.width-35, 20)];
        self.contentPlaceholderLabel.text = @"请输入适当的退款理由";
        self.contentPlaceholderLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
        self.contentPlaceholderLabel.font = [UIFont systemFontOfSize:14];
        self.contentPlaceholderLabel.userInteractionEnabled = NO;
        [self.drawbackStateTextView addSubview:self.contentPlaceholderLabel];
   
    }
    return _drawbackStateView;
}

#pragma mark - DataRequest

#pragma mark - 拒绝退款请求
- (void)refuseDrawbackRequest
{
    self.managerRefuse = [AFHTTPRequestOperationManager manager];
    
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.cancelOrderView.reasonTextView.text
                                , @"open_id":openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.managerRefuse GET:ODRefuseDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([responseObject[@"status"] isEqualToString:@"success"])
        {
            [ODProgressHUD showInfoWithStatus:@"已拒绝"];
            
            NSNotification *notification =[NSNotification notificationWithName:ODNotificationSellOrderThirdRefresh object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [weakSelf.cancelOrderView removeFromSuperview];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    }
                    failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {
       
    }];
}

#pragma mark - 接受退款请求
- (void)receiveDrawbackRequest
{
    self.managerReceive = [AFHTTPRequestOperationManager manager];
    
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason ,@"open_id":openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.managerReceive GET:ODReceiveDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([responseObject[@"status"] isEqualToString:@"success"])
        {
            [ODProgressHUD showInfoWithStatus:@"已接受"];

            NSNotification *notification =[NSNotification notificationWithName:ODNotificationSellOrderThirdRefresh object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    }
                     failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {

    }];
}

#pragma mark - 申请退款请求
- (void)releaseDrawbackRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];

    NSString *openId = [ODUserInformation sharedODUserInformation].openID;

    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason, @"open_id":openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:ODReleaseDrawbackUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([responseObject[@"status"] isEqualToString:@"success"])
        {
            [ODProgressHUD showInfoWithStatus:@"申请退款成功"];

//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:ODNotificationOrderListRefresh object:nil userInfo:nil];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
          
            NSNotification *notification =[NSNotification notificationWithName:ODNotificationMyOrderThirdRefresh object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {

    }];
}


#pragma mark - Action

#pragma mark - 退款原因点击事件
-(void)drawbackReasonOneButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonOne)
    {
        [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonOne = !self.isSelectedReasonOne;
        
        if (self.isSelectedReasonTwo)
        {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree)
        {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour)
        {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther)
        {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonTwoButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonTwo)
    {
        [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        
        if (self.isSelectedReasonOne)
        {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonThree)
        {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour)
        {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther)
        {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonThreeButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonThree)
    {
        [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonThree = !self.isSelectedReasonThree;
        
        if (self.isSelectedReasonOne)
        {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo)
        {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonFour)
        {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
        if (self.isSelectedReasonOther)
        {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonFourButtonClick:(UIButton *)button
{
    if (!self.isSelectedReasonFour)
    {
        [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonFour = !self.isSelectedReasonFour;
        
        if (self.isSelectedReasonOne)
        {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo)
        {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree)
        {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonOther)
        {
            [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOther = !self.isSelectedReasonOther;
        }
    }
    self.drawbackStateView.hidden = YES;
}

-(void)drawbackReasonOtherButtonClick:(UIButton *)button
{    
    if (!self.isSelectedReasonOther)
    {
        [self.drawbackReasonOtherButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.isSelectedReasonOther = !self.isSelectedReasonOther;
        
        if (self.isSelectedReasonOne)
        {
            [self.drawbackReasonOneButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonOne = !self.isSelectedReasonOne;
        }
        if (self.isSelectedReasonTwo)
        {
            [self.drawbackReasonTwoButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonTwo = !self.isSelectedReasonTwo;
        }
        if (self.isSelectedReasonThree)
        {
            [self.drawbackReasonThreeButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonThree = !self.isSelectedReasonThree;
        }
        if (self.isSelectedReasonFour)
        {
            [self.drawbackReasonFourButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
            self.isSelectedReasonFour = !self.isSelectedReasonFour;
        }
    }    
    if (self.isSelectedReasonOther)
    {
        self.drawbackStateView.hidden = NO;
    }
    else
    {
        self.drawbackStateView.hidden = YES;
    }
}

#pragma mark - 拒绝 按钮点击事件
- (void)refuseButtonClick:(UIButton *)button
{
    self.cancelOrderView = [ODCancelOrderView getView];
    self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelOrderView.reasonTextView.text = @"请输入拒绝原因";
    self.cancelOrderView.reasonTextView.delegate = self;
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.cancelOrderView];
}

#pragma mark - 接受 按钮点击事件
- (void)receiveButtonClick:(UIButton *)button
{
    [self receiveDrawbackRequest];
}

#pragma mark - 提交 按钮点击事件
-(void)releaseButtonClick:(UIButton *)button
{
    if (self.isSelectedReasonOne)
    {
        self.drawbackReason = self.drawbackReasonOneLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonTwo)
    {
        self.drawbackReason = self.drawbackReasonTwoLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonThree)
    {
        self.drawbackReason = self.drawbackReasonThreeLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonFour)
    {
        self.drawbackReason = self.drawbackReasonFourLabel.text;
        [self releaseDrawbackRequest];
    }
    if (self.isSelectedReasonOther)
    {
        self.drawbackReason = self.drawbackStateTextView.text;
        [self releaseDrawbackRequest];
    }
}

#pragma mark - 拨打电话
- (void)servicePhoneButtonClick:(UIButton *)button
{
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",self.servicePhone];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNumber]]];
    [self.view addSubview:callWebView];    
}

- (void)submitAction:(UIButton *)sender
{
    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入拒绝原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""])
    {
        [ODProgressHUD showInfoWithStatus:@"请输入拒绝原因"];
    }
    else
    {
        [self refuseDrawbackRequest];
    }
}

- (void)cancelView:(UIButton *)sender
{
    [self.cancelOrderView removeFromSuperview];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.cancelOrderView.reasonTextView)
    {
        if ([textView.text isEqualToString:@"请输入拒绝原因"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.contentPlaceholderLabel.text = @"请输入适当的退款理由";
    }
    else
    {
        self.contentPlaceholderLabel.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.cancelOrderView.reasonTextView)
    {
        if ([self.cancelOrderView.reasonTextView.text isEqualToString:@"请输入拒绝原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""])
        {
            self.cancelOrderView.reasonTextView.text = @"请输入拒绝原因";
            self.cancelOrderView.reasonTextView.textColor = [UIColor lightGrayColor];
        }
    }
    else if (textView == self.drawbackStateTextView)
    {
        if (textView.text.length == 0)
        {
            self.contentPlaceholderLabel.text = @"请输入适当的退款理由";
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

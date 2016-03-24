//
//  ODDrawbackController.m
//  ODApp
//
//  Created by Bracelet on 16/2/20.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODDrawbackController.h"
#import "ODCancelOrderView.h"

@interface ODDrawbackController ()
{
    // label 统一高度
    float uniftyHeight;
}

@property (nonatomic ,strong) ODCancelOrderView *cancelOrderView;

@property(nonatomic, strong) UIScrollView *scrollView;

// 选择原因 数组
@property (nonatomic, strong) NSArray *selectReasonArray;

// 选择图片 数组
@property (nonatomic, strong) NSArray *selectImageArray;

// 记录上一次选择的原因
@property (nonatomic, assign) long lastSelect;

// 退款金额
@property(nonatomic, strong) UILabel *drawbackMoneyLabel;

// 退款原因
@property(nonatomic, strong) UIView *drawbackReasonContentView;

// 拒绝原因
@property(nonatomic, strong) UIView *refuseReasonContentView;

// 退款说明
@property(nonatomic, strong) UIView *drawbackStateView;
@property(nonatomic, strong) UITextView *drawbackStateTextView;
@property(nonatomic, strong) UILabel *contentPlaceholderLabel;

// 联系客服
@property(nonatomic, strong) UIView *servicePhoneView;
@property(nonatomic, strong) UIView *serviceTimeView;


@property (nonatomic, strong) NSString *order_status;

@end

@implementation ODDrawbackController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
#pragma mark - 生命周期

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
    uniftyHeight = 43;
    
    // 动态设置 ScrollView 的高度
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
    self.scrollView.backgroundColor = [UIColor colorWithRGBString:@"#f3f3f3" alpha:1];
    [self.view addSubview:self.scrollView];
    
    [self createDrawbackMoneyView];
    [self createDrawbackReasonView];
    [self createRefuseReasonView];
    [self createServiceView];
    [self createEndButton];
    
    // 动态设置 ScrollView ContentSize
    float scrollContentHeight;
    if (self.isService)
    {
        scrollContentHeight = CGRectGetMaxY(self.serviceTimeView.frame);
    }
    else if (self.isDrawbackState)
    {
        scrollContentHeight = CGRectGetMaxY(self.drawbackStateView.frame);
    }
    else
    {
        scrollContentHeight = CGRectGetMaxY(self.drawbackReasonContentView.frame);
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,scrollContentHeight );
}

#pragma mark - 退款金额
- (void)createDrawbackMoneyView
{
    self.drawbackMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, uniftyHeight)];
    self.drawbackMoneyLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
    NSString *drawbackMoneyStr = [NSString stringWithFormat:@"您的退款金额:%@元",self.darwbackMoney];
    NSMutableAttributedString *moneyNumberStr = [[NSMutableAttributedString alloc]initWithString:drawbackMoneyStr];
    [moneyNumberStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBString:@"#ff6666" alpha:1] range:NSMakeRange([moneyNumberStr length] - self.darwbackMoney.length -1, self.darwbackMoney.length)];
    self.drawbackMoneyLabel.attributedText = moneyNumberStr;
    self.drawbackMoneyLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.drawbackMoneyLabel.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyLabel];
}

#pragma mark - 退款原因
- (void)createDrawbackReasonView
{
    // 退款原因内容 高度
    float drawbackReasonHeight;
    
    // 动态设置 退款原因 的高度
    if (self.isSelectReason)
    {
        drawbackReasonHeight = (uniftyHeight + 0.5) * 5 - 0.5;
    }
    else
    {
        drawbackReasonHeight = [ODHelp textHeightFromTextString:self.drawbackReason width:KScreenWidth - ODLeftMargin * 2 miniHeight:uniftyHeight fontSize:13.5];
    }
    UILabel *drawbackReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22)];
    drawbackReasonLabel.text = @"退款原因";
    drawbackReasonLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
    drawbackReasonLabel.font = [UIFont systemFontOfSize:12];
    drawbackReasonLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:drawbackReasonLabel];
    
    self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(drawbackReasonLabel.frame), KScreenWidth, drawbackReasonHeight)];
    self.drawbackReasonContentView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentView];
    
    // 退款原因 可选择
    if (self.isSelectReason)
    {
        // 退款原因Label 距离 屏幕左边的 距离
        float reasonLabelLeftMargin = ODLeftMargin + 25;
        
        self.selectReasonArray = @[@"卖家自身原因无法服务",@"对服务质量不满意",@"未按时交付服务",@"双方已协商好退款",@"其它"];
        self.selectImageArray = @[@"icon_Default address_default",@"icon_Default address_Selected"];
        
        for (int i = 0; i < self.selectReasonArray.count; i++)
        {
            // 选择原因label
            UILabel *selectReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(reasonLabelLeftMargin, (uniftyHeight + 0.5) * i - 0.5, KScreenWidth, uniftyHeight)];
            selectReasonLabel.text = self.selectReasonArray[i];
            selectReasonLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
            selectReasonLabel.font = [UIFont systemFontOfSize:13.5];
            selectReasonLabel.textAlignment = NSTextAlignmentLeft;
            selectReasonLabel.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
            [self.drawbackReasonContentView addSubview:selectReasonLabel];
            
            // 选择图片imageView
            UIImageView *selectReasonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, (uniftyHeight + 0.5) * i - 0.5 + 12.5, 20, 20)];
            selectReasonImageView.image = [UIImage imageNamed:self.selectImageArray[0]];
            selectReasonImageView.tag = 100 + i;
            [self.drawbackReasonContentView addSubview:selectReasonImageView];
            
            // 选择原因button
            UIButton *selectReasonButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin, (uniftyHeight + 0.5) * i - 0.5, KScreenHeight - ODLeftMargin, uniftyHeight)];
            selectReasonButton.tag = 1000+i;
            [selectReasonButton addTarget:self action:@selector(selectReasonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.drawbackReasonContentView addSubview: selectReasonButton];
        }
        
        for (int i = 1; i < self.selectReasonArray.count; i++)
        {
            UIView *selectReasonLineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, uniftyHeight * i, KScreenWidth, 0.5)];
            selectReasonLineView.backgroundColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
            [self.drawbackReasonContentView addSubview:selectReasonLineView];
        }
    }
    // 退款原因 不可选择
    else
    {
        UILabel *drawbackReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth - ODLeftMargin * 2, drawbackReasonHeight)];
        if (self.drawbackReason == nil)
        {
            self.drawbackReason = @"";
        }
        drawbackReasonContentLabel.text = self.drawbackReason;
        drawbackReasonContentLabel.numberOfLines = 0;
        drawbackReasonContentLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
        drawbackReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        drawbackReasonContentLabel.textAlignment = NSTextAlignmentLeft;
        [self.drawbackReasonContentView addSubview:drawbackReasonContentLabel];
    }
}

#pragma mark - 拒绝原因
- (void)createRefuseReasonView
{
    // 显示 拒绝原因
    if (self.isRefuseReason)
    {
        UILabel *refuseReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonContentView.frame), KScreenWidth, 22)];
        if (self.refuseReason == nil) {
            self.refuseReason = @"";
        }
        refuseReasonLabel.text = @"拒绝原因";
        refuseReasonLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
        refuseReasonLabel.font = [UIFont systemFontOfSize:12];
        refuseReasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:refuseReasonLabel];
        
        float refuseReasonHeight;
        refuseReasonHeight = [ODHelp textHeightFromTextString:self.refuseReason width:KScreenWidth - ODLeftMargin * 2 miniHeight:uniftyHeight fontSize:13.5];
        
        self.refuseReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(refuseReasonLabel.frame), KScreenWidth, refuseReasonHeight)];
        self.refuseReasonContentView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.refuseReasonContentView];
        
        UILabel *refuseReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth - ODLeftMargin * 2, refuseReasonHeight)];
        refuseReasonContentLabel.text = self.refuseReason;
        refuseReasonContentLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
        refuseReasonContentLabel.numberOfLines = 0;
        refuseReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
        refuseReasonContentLabel.textAlignment = NSTextAlignmentLeft;
        [self.refuseReasonContentView addSubview:refuseReasonContentLabel];
    }
}

#pragma mark - 联系客服
- (void)createServiceView
{
    // 动态设置 联系客服GetMaxY
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
    
    // 显示 联系客服
    if (self.isService)
    {
        UILabel *contactServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, serviceGetMaxY, KScreenWidth, 22)];
        contactServiceLabel.text = @"联系客服";
        contactServiceLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
        contactServiceLabel.font = [UIFont systemFontOfSize:12];
        contactServiceLabel.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:contactServiceLabel];
        
        self.servicePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contactServiceLabel.frame), KScreenWidth, uniftyHeight)];
        self.servicePhoneView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.servicePhoneView];
        
        UILabel *servicePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, 70, uniftyHeight)];
        servicePhoneLabel.text = @"客服电话：";
        servicePhoneLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
        servicePhoneLabel.font = [UIFont systemFontOfSize:13.5];
        servicePhoneLabel.textAlignment = NSTextAlignmentLeft;
        servicePhoneLabel.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [self.servicePhoneView addSubview:servicePhoneLabel];
        
        UIButton *servicePhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(servicePhoneLabel.frame), 0, 200, uniftyHeight)];
        [servicePhoneButton setTitle:[NSString stringWithFormat:@"%@",self.servicePhone] forState:UIControlStateNormal];
        servicePhoneButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        servicePhoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [servicePhoneButton setTitleColor:[UIColor colorWithRGBString:@"#3c63a2" alpha:1] forState:UIControlStateNormal];
        [servicePhoneButton addTarget:self action:@selector(servicePhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.servicePhoneView addSubview:servicePhoneButton];
        
        self.serviceTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, uniftyHeight)];
        self.serviceTimeView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:self.serviceTimeView];
        
        UILabel *serviceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, uniftyHeight)];
        serviceTimeLabel.text = [NSString stringWithFormat:@"%@时间：%@",self.customerService, self.serviceTime];
        serviceTimeLabel.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
        serviceTimeLabel.font = [UIFont systemFontOfSize:13.5];
        serviceTimeLabel.textAlignment = NSTextAlignmentLeft;
        serviceTimeLabel.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:serviceTimeLabel];
    }
}

#pragma mark - 底部按钮
- (void)createEndButton
{
    // 显示 申请退款 按钮
    if (self.isRelease)
    {
        UIButton *applyDrawbackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KControllerHeight - ODNavigationHeight - 50, KScreenWidth, 50)];
        [applyDrawbackButton setTitle:self.confirmButtonContent forState:UIControlStateNormal];
        applyDrawbackButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        applyDrawbackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [applyDrawbackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        applyDrawbackButton.backgroundColor = [UIColor colorWithRGBString:@"#ff6666" alpha:1];
        [applyDrawbackButton addTarget:self action:@selector(applyDrawbackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:applyDrawbackButton];
    }
    
    // 显示 拒绝、接受 按钮
    if (self.isRefuseAndReceive)
    {
        NSString *buttonTitle;
        NSString *buttonColor;
        for (int i = 0; i < 2; i++)
        {
            if (i == 0)
            {
                buttonTitle = @"拒绝";
                buttonColor = @"#d0d0d0";
            }
            else
            {
                buttonTitle = @"接受";
                buttonColor = @"#ff6666";
            }
            UIButton *refuseAndReceiveButton = [[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth/2 * i, KControllerHeight - ODNavigationHeight - 50, KScreenWidth / 2, 50)];
            [refuseAndReceiveButton setTitle:buttonTitle forState:UIControlStateNormal];
            refuseAndReceiveButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
            refuseAndReceiveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            refuseAndReceiveButton.tag = i + 1000;
            [refuseAndReceiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            refuseAndReceiveButton.backgroundColor = [UIColor colorWithRGBString:buttonColor alpha:1];
            [refuseAndReceiveButton addTarget:self action:@selector(refuseAndReceiveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:refuseAndReceiveButton];
        }
    }
}


#pragma mark - 退款说明
-(UIView *)drawbackStateView
{
    if (!_drawbackStateView)
    {
        _drawbackStateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonContentView.frame), KScreenWidth, 22 + 150)];
        self.servicePhoneView.backgroundColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1];
        [self.scrollView addSubview:_drawbackStateView];
        
        UILabel *drawbackStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth, 22)];
        drawbackStateLabel.text = @"退款说明";
        drawbackStateLabel.textColor = [UIColor colorWithRGBString:@"#8e8e8e" alpha:1];
        drawbackStateLabel.font = [UIFont systemFontOfSize:12];
        drawbackStateLabel.textAlignment = NSTextAlignmentLeft;
        [_drawbackStateView addSubview:drawbackStateLabel];
        
        UIView *drawbackStateContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(drawbackStateLabel.frame), KScreenWidth, 150)];
        drawbackStateContentView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:1];
        [_drawbackStateView addSubview:drawbackStateContentView];
        
        self.drawbackStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(ODLeftMargin, 22, KScreenWidth - ODLeftMargin * 2, 150)];
        self.drawbackStateTextView.textColor = [UIColor colorWithRGBString:@"#000000" alpha:1];
        self.drawbackStateTextView.font = [UIFont systemFontOfSize:12];
        if (self.drawbackState == nil)
        {
            self.drawbackState = @"";
        }
        
        self.drawbackStateTextView.text = self.drawbackState;
        self.drawbackStateTextView.delegate = self;
        [_drawbackStateView addSubview:self.drawbackStateTextView];
        
        self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenSize.width-35, 20)];
        self.contentPlaceholderLabel.text = @" 请输入适当的退款理由";
        self.contentPlaceholderLabel.textColor = [UIColor colorWithRGBString:@"#b0b0b0" alpha:1];
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
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.cancelOrderView.reasonTextView.text, @"open_id":openId};

    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapRejectRefund parameters:parameter modelClass:[NSObject class] success:^(id model) {
        
        [ODProgressHUD showInfoWithStatus:@"已拒绝"];
//        NSNotification *notification =[NSNotification notificationWithName:ODNotificationSellOrderThirdRefresh object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        
////        [weakSelf refreshDetail:@"-5"];
        [weakSelf.cancelOrderView removeFromSuperview];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        
    }
                   failure:^(NSError *error) {
                
    }];
}


#pragma mark - 接受退款请求

- (void)receiveDrawbackRequest
{
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason ,@"open_id":openId};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapConfirmRefund parameters:parameter modelClass:[NSObject class] success:^(id model) {
        
        [ODProgressHUD showInfoWithStatus:@"已接受"];
//        NSNotification *notification =[NSNotification notificationWithName:ODNotificationSellOrderThirdRefresh object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
//        [weakSelf refreshDetail:@"-3"];

        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
                   failure:^(NSError *error) {
                       
    }];
}



#pragma mark - 申请退款请求

- (void)releaseDrawbackRequest
{
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    NSDictionary *parameter = @{@"order_id":self.order_id,@"reason":self.drawbackReason, @"open_id":openId};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapOrderCancel parameters:parameter modelClass:[NSObject  class] success:^(id model) {
        
        [ODProgressHUD showInfoWithStatus:@"申请退款成功"];
//        NSNotification *notification =[NSNotification notificationWithName:ODNotificationMyOrderThirdRefresh object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
//        [weakSelf refreshDetail:@"-2"];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
                   failure:^(NSError *error) {
                
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.cancelOrderView.reasonTextView)
    {
        if ([textView.text isEqualToString:@" 请输入拒绝原因"])
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
        self.contentPlaceholderLabel.text = @" 请输入适当的退款理由";
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
        if ([self.cancelOrderView.reasonTextView.text isEqualToString:@" 请输入拒绝原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""])
        {
            self.cancelOrderView.reasonTextView.text = @" 请输入拒绝原因";
            self.cancelOrderView.reasonTextView.textColor = [UIColor lightGrayColor];
        }
    }
    else if (textView == self.drawbackStateTextView)
    {
        if (textView.text.length == 0)
        {
            self.contentPlaceholderLabel.text = @" 请输入适当的退款理由";
        }
    }
}

#pragma mark - Action

#pragma mark - 退款原因点击事件

- (void)selectReasonButtonClick:(UIButton *)button
{
    for (int i = 0; i < self.selectReasonArray.count; i++)
    {
        if (button.tag == i + 1000)
        {
            UIImageView *imageView = (UIImageView *)[self.drawbackReasonContentView viewWithTag:button.tag - 900];
            imageView.image = [UIImage imageNamed:self.selectImageArray[1]];
            self.lastSelect = button.tag - 1000;
        }
        else
        {
            UIImageView *imageView = (UIImageView *)[self.drawbackReasonContentView viewWithTag:i + 100];
            imageView.image = [UIImage imageNamed:self.selectImageArray[0]];
        }
    }
    if (self.lastSelect == 4)
    {
        self.drawbackStateView.hidden = NO;
    }
    else
    {
        self.drawbackStateView.hidden = YES;
    }
}


#pragma mark - 拒绝、接受 按钮点击事件
- (void)refuseAndReceiveButtonClick:(UIButton *)button
{
    if (button.tag == 1000)
    {
        self.cancelOrderView = [ODCancelOrderView getView];
        self.cancelOrderView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        [self.cancelOrderView.cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderView.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelOrderView.reasonTextView.text = @" 请输入拒绝原因";
        self.cancelOrderView.reasonTextView.delegate = self;
        [[[UIApplication sharedApplication]keyWindow] addSubview:self.cancelOrderView];
    }
    else
    {
        [self receiveDrawbackRequest];
    }
}

#pragma mark - 申请退款 按钮点击事件
-(void)applyDrawbackButtonClick:(UIButton *)button
{
    if (self.lastSelect != self.selectReasonArray.count - 1)
    {
        self.drawbackReason = self.selectReasonArray[self.lastSelect];
        [self releaseDrawbackRequest];
    }
    else
    {
        self.drawbackReason = self.drawbackStateTextView.text;
        if ([self.drawbackStateTextView.text isEqualToString:@""])
        {
            [ODProgressHUD showInfoWithStatus:@"请输入退款说明"];
        }
        else
        {
            [self releaseDrawbackRequest];
        }
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
    if ([self.cancelOrderView.reasonTextView.text isEqualToString:@" 请输入拒绝原因"] || [self.cancelOrderView.reasonTextView.text isEqualToString:@""])
    {
        [ODProgressHUD showInfoWithStatus:@" 请输入拒绝原因"];
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

@end

//
//  ODSubmitController.m
//  ODApp
//
//  Created by Bracelet on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSubmitOrderController.h"

#import "ODSubmitOrderView.h"

@interface ODSubmitOrderController ()

@property (nonatomic, copy) NSString *swapType;

@property (nonatomic, strong) UIView *serveWayView;
@property (nonatomic, strong) UIView *serveTimeView;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIView *serviceTimeView;

@property (nonatomic, assign) float addressY;

@property (nonatomic, strong) ODSubmitOrderView *submitOrderView;

@end

@implementation ODSubmitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"提交订单";
    [self judgeSwapType];
    [self createSkillInformationView];
    [self createFootView];
}

- (void)judgeSwapType {
    if (self.swap_type == 1) {
        self.swapType = @"上门服务";
        [self createServeWayView];
        [self createcserveTimeView];
        self.addressY = 44 * 2;
        [self createAddressView];
    }
    else if (self.swap_type == 2) {
        self.swapType = @"快递服务";
        [self createServeWayView];
        self.addressY = 44;
        [self createAddressView];
    }
    else {
        self.swapType = @"线上服务";
        [self createServeWayView];
        [self createcserveTimeView];
    }
}

- (void)createServeWayView {
    self.serveWayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    self.serveWayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.serveWayView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, 14.5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"icon_service mode"];
    [self.serveWayView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 7.5, 0, 80, 43.5)];
    label.text = @"服务方式";
    label.textColor = [UIColor colorGloomyColor];
    label.font =[UIFont systemFontOfSize:13.5];
    [self.serveWayView addSubview:label];
    
    UILabel *serveWayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, KScreenWidth - CGRectGetMaxX(label.frame) - ODLeftMargin , 43.5)];
    serveWayLabel.textAlignment = NSTextAlignmentRight;
    serveWayLabel.text = self.swapType;
    serveWayLabel.textColor = [UIColor blackColor];
    serveWayLabel.font = [UIFont systemFontOfSize:13.5];
    [self.serveWayView addSubview:serveWayLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(serveWayLabel.frame), KScreenWidth - ODLeftMargin, 0.5)];
    lineView.backgroundColor = [UIColor lineColor];
    [self.serveWayView addSubview:lineView];
}

- (void)createcserveTimeView {
    self.serveTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, KScreenWidth, 44)];
    self.serveTimeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.serveTimeView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, 14.5, 15, 15)];
    imageView.image = [UIImage imageNamed:@"icon_service time"];
    [self.serveTimeView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 7.5, 0, 80, 43.5)];
    label.text = @"服务时间";
    label.textColor = [UIColor colorGloomyColor];
    label.font =[UIFont systemFontOfSize:13.5];
    [self.serveTimeView addSubview:label];
    
    UILabel *serveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, KScreenWidth - CGRectGetMaxX(label.frame) - ODLeftMargin - 15 - 7.5, 43.5)];
    serveTimeLabel.textAlignment = NSTextAlignmentRight;
    serveTimeLabel.text = self.swapType;
    serveTimeLabel.textColor = [UIColor blackColor];
    serveTimeLabel.font = [UIFont systemFontOfSize:13.5];
    [self.serveTimeView addSubview:serveTimeLabel];
    
    UIImageView *arrowImageVie = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - ODLeftMargin - 15, 14.5, 15, 15)];
    arrowImageVie.contentMode = UIViewContentModeCenter;
    arrowImageVie.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    [self.serveTimeView addSubview:arrowImageVie];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(serveTimeLabel.frame), KScreenWidth - ODLeftMargin, 0.5)];
    lineView.backgroundColor = [UIColor lineColor];
    [self.serveTimeView addSubview:lineView];
}

- (void)createAddressView {

    self.addressView = [[UIView alloc] initWithFrame:CGRectMake(0, self.addressY, KScreenWidth, 44)];
    self.addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addressView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ODLeftMargin, 13, 15, 18)];
    imageView.image = [UIImage imageNamed:@"icon_service address"];
    [self.addressView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 7.5, 0, 80, 43.5)];
    label.text = @"联系地址";
    label.textColor = [UIColor colorGloomyColor];
    label.font =[UIFont systemFontOfSize:13.5];
    [self.addressView addSubview:label];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, KScreenWidth - CGRectGetMaxX(label.frame) - ODLeftMargin - 15 - 7.5, 43.5)];
    addressLabel.textAlignment = NSTextAlignmentRight;
    addressLabel.text = self.swapType;
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font = [UIFont systemFontOfSize:13.5];
    [self.addressView addSubview:addressLabel];
    
    UIImageView *arrowImageVie = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - ODLeftMargin - 15, 14.5, 15, 15)];
    arrowImageVie.contentMode = UIViewContentModeCenter;
    arrowImageVie.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    [self.addressView addSubview:arrowImageVie];
    
}

- (void)createSkillInformationView {
    self.submitOrderView = [[ODSubmitOrderView alloc] init];
    self.submitOrderView = [ODSubmitOrderView submitOrderView];
    [self.submitOrderView setModel:self.model];
    
    float submitOrderViewY;
    if (self.swap_type == 3) {
        submitOrderViewY = CGRectGetMaxY(self.serveTimeView.frame) + 12.5;
    }
    else {
        submitOrderViewY = CGRectGetMaxY(self.addressView.frame) + 12.5;
    }
    self.submitOrderView.od_x = 0;
    self.submitOrderView.od_y = submitOrderViewY;
    self.submitOrderView.sizeToFit;
    [self.view addSubview:self.submitOrderView];
}

- (void)createServiceTimeView {
    self.serviceTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 245, KScreenWidth, 245)];
    self.serviceTimeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.serviceTimeView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 10, 60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"服务时间";
    titleLabel.textColor = [UIColor blackColor];
    [self.serviceTimeView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 10, 200, 20)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"(该时间将影响订单自动确认时间)";
    contentLabel.textColor = [UIColor lightGrayColor];
    [self.serviceTimeView addSubview:contentLabel];
    
    float dateButtonWidth = (KScreenWidth - ODLeftMargin * 2 - 10 * 2) / 3;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(contentLabel.frame) + 5, KScreenWidth - ODLeftMargin * 2, 50)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(dateButtonWidth * 7 + 10 * 6, 50);
    [self.serviceTimeView addSubview:scrollView];
    
    
}


- (void)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 49, KScreenWidth, 49)];
    footView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:footView];
    
    UILabel *orderMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth * 3 / 5, 49)];
    orderMoneyLabel.textColor = [UIColor colorRedColor];
    orderMoneyLabel.font = [UIFont systemFontOfSize:15];
    
    NSString *str = [NSString stringWithFormat:@"订单金额：%.2f元", self.model.price];
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:str];
    [moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.5] range:NSMakeRange(0, 5)];
    orderMoneyLabel.attributedText = moneyStr;
    [footView addSubview:orderMoneyLabel];
    
    UIButton *submitOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderMoneyLabel.frame), 0, KScreenWidth * 2 / 5, 49)];
    [submitOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitOrderButton.backgroundColor = [UIColor colorRedColor];
    [submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitOrderButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [submitOrderButton addTarget:self action:@selector(submitOrderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitOrderButton];
}

#pragma mark - Action

- (void)submitOrderButtonAction:(UIButton *)sender {
    
}

@end

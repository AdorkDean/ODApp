//
//  ODMyOrderDetailController.m
//  ODApp
//
//  Created by Bracelet on 16/1/11.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyOrderDetailController.h"
#import "ODUserInformation.h"
@interface ODMyOrderDetailController ()

@end

@implementation ODMyOrderDetailController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.devicesArray = [[NSMutableArray alloc] init];
    [self navigationInit];
    [self getOrderDetailRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)navigationInit {
    self.navigationItem.title = @"预约详情";
    if (self.isOther == NO && ![self.status_str isEqualToString:@"已取消"])
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelOrderButtonClick:) color:nil highColor:nil title:@"取消预约"];
    }
}

#pragma mark - 加载数据请求
- (void)getOrderDetailRequest {
    
    NSDictionary *parameter = @{@"order_id":[NSString stringWithFormat:@"%@", self.order_id]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreInfoOrder parameters:parameter modelClass:[ODMyOrderDetailModel class] success:^(id model)
    {
        weakSelf.model = [model result];        
        [weakSelf createOrderView];
    }
    failure:^(NSError *error) {
        
    }];
}

#pragma mark - Create UIScrollView
- (void)createOrderView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    
    // label 高度
    float labelHeight = 30;
    // view 距离左边的距离
    float viewLeftMargin = 4;
    // view 圆角大小
    float viewCornerRadius = 5;
    
#pragma mark - 预约时间
    UIView *timeView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    timeView.layer.cornerRadius = viewCornerRadius;
    timeView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    timeView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:timeView];
    
    UILabel *timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin,  viewLeftMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@ - %@",self.model.start_date_str,self.model.end_date_str] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:timeLabel];
    
#pragma mark - 体验中心名称
    UIView *experienceCenterView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(timeView.frame) + viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    experienceCenterView.layer.cornerRadius = viewCornerRadius;
    experienceCenterView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    experienceCenterView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:experienceCenterView];
    
    UILabel *experienceCenterLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(timeLabel.frame) + viewLeftMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@",self.model.store_name] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:experienceCenterLabel];
    
#pragma mark - 中心设备
    float labelUpMargin = 14;
    float labelDownMargin = 5;
    UILabel *deviceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(experienceCenterLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, 11.5) text:@"需要使用的中心设备" font:11.5 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:deviceLabel];
    
    NSString *name = [[NSMutableString alloc] init];

    if (self.devicesArray.count == 0) {
        name = @"无";
    }
    else if (self.devicesArray.count == 1) {
        name = self.devicesArray[0];
    }
    else if (self.devicesArray.count == 2) {
        name = [NSString stringWithFormat:@"%@,%@",self.devicesArray[0],self.devicesArray[1]];
    }
    else if (self.devicesArray.count == 3) {
        name = [NSString stringWithFormat:@"%@,%@,%@",self.devicesArray[0],self.devicesArray[1],self.devicesArray[2]];
    }
    else {
        name = [NSString stringWithFormat:@"%@,%@,%@,%@",self.devicesArray[0],self.devicesArray[1],self.devicesArray[2],self.devicesArray[3]];
    }
    
    UIView *deviceDetailView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(deviceLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    deviceDetailView.layer.cornerRadius = viewCornerRadius;
    deviceDetailView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    deviceDetailView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:deviceDetailView];
    
    UILabel *deviceDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(deviceLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@",name] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:deviceDetailLabel];
    
#pragma mark - 活动目的
    UILabel *purposeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(deviceDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, 11.5) text:@"活动目的" font:11.5 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:purposeLabel];
    
    UIView *purposeDetailView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(purposeLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    purposeDetailView.layer.cornerRadius = viewCornerRadius;
    purposeDetailView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    purposeDetailView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:purposeDetailView];
    
    UILabel *purposeDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(purposeLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@",self.model.purpose] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:purposeDetailLabel];
    
#pragma mark - 活动内容
    UILabel *contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(purposeDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, 11.5) text:@"活动内容" font:11.5 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:contentLabel];
    
    UIView *contentDetailView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(contentLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - ODLeftMargin * 2 miniHeight:labelHeight fontSize:12.5]) tag:0 color:@"#ffffff"];
    contentDetailView.layer.cornerRadius = viewCornerRadius;
    contentDetailView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    contentDetailView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:contentDetailView];
    
    UILabel *contentDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(contentLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2,[ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - ODLeftMargin * 2 miniHeight:labelHeight fontSize:12.5] ) text:[NSString stringWithFormat:@"%@",self.model.content] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:contentDetailLabel];
    
#pragma mark - 参加人数
    UILabel *peopleNumberLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(contentDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, 11.5) text:@"参加人数" font:11.5 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:peopleNumberLabel];
    
    UIView *peopleNumberDetailView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(peopleNumberLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    peopleNumberDetailView.layer.cornerRadius = viewCornerRadius;
    peopleNumberDetailView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    peopleNumberDetailView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:peopleNumberDetailView];
    
    UILabel *peopleNumberDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(peopleNumberLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.model.people_num]] font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:peopleNumberDetailLabel];
    
#pragma mark - 场地电话
    UIView *phoneView = [ODClassMethod creatViewWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight) tag:0 color:@"#ffffff"];
    phoneView.layer.cornerRadius = viewCornerRadius;
    phoneView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    phoneView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:phoneView];

    UILabel *phoneLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(ODLeftMargin,  CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, kScreenSize.width - viewLeftMargin * 2, labelHeight) text:@"场地预约电话:" font:12.5 alignment:@"left" color:@"#484848" alpha:1];
    [self.scrollView addSubview:phoneLabel];
    
    UIButton *phoneButton = [ODClassMethod creatButtonWithFrame:CGRectMake(5 + kScreenSize.width * 1/3, CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, 100, labelHeight) target:self sel:@selector(phoneButtonClick:) tag:0 image:nil title:self.model.store_tel font:12.5];
    [self.scrollView addSubview:phoneButton];
    
#pragma mark - 审核状态
    self.checkLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(phoneLabel.frame) + viewLeftMargin, kScreenSize.width - viewLeftMargin * 2, labelHeight) text:[NSString stringWithFormat:@"%@",self.model.status_str ]font:12.5 alignment:@"center" color:@"#000000" alpha:1];
    self.checkLabel.layer.masksToBounds = YES;
    self.checkLabel.layer.cornerRadius = viewCornerRadius;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.checkLabel.frame) + 3);
    [self.scrollView addSubview:self.checkLabel];
    [self.view addSubview:self.scrollView];
}

#pragma mark - 取消预约 点击事件
- (void)cancelOrderButtonClick:(UIButton *)button {
    if ([self.checkLabel.text isEqualToString:@"已取消"] || [self.checkLabel.text isEqualToString:@"后台取消"]) {
        [ODProgressHUD showInfoWithStatus:@"订单已经取消"];
    }
    else if ([self.checkLabel.text isEqualToString:@"前台已确认"]) {
        [ODProgressHUD showInfoWithStatus:@"订单已生成,请联系客服"];
    }
    else if ([self.checkLabel.text isEqualToString:@"到场已确认"] || [self.checkLabel.text isEqualToString:@"未到场"]) {
        [ODProgressHUD showInfoWithStatus:@"已到活动时间，无需进行取消"];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要取消预约吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *parameter = @{@"open_id":self.open_id,@"order_id":self.order_id};
            
            __weakSelf
            [ODHttpTool getWithURL:ODUrlStoreCancelOrder parameters:parameter modelClass:[NSObject class] success:^(id model) {
                
                [ODProgressHUD showInfoWithStatus:@"取消订单成功"];
                weakSelf.navigationItem.rightBarButtonItem = nil;
                weakSelf.checkLabel.text = @"已取消";
                weakSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
                weakSelf.status_str = weakSelf.checkLabel.text;
                
                NSDictionary *loveDict =[[NSDictionary alloc] initWithObjectsAndKeys:weakSelf.status_str,@"status_str", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationCancelOrder object:nil userInfo:loveDict];
                
            }
            failure:^(NSError *error) {
                               
            }];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 拨打电话
- (void)phoneButtonClick:(UIButton *)button {
    [self.view callToNum:self.model.store_tel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

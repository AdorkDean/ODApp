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

// label 高度
static CGFloat const labelHeight = 30;
// view 距离左边的距离
static CGFloat const viewLeftMargin = 4;
// view 圆角大小
static CGFloat const viewCornerRadius = 5;
// 边框宽度
static CGFloat const viewBorderWidth = 0.5;
// 字体大小
static CGFloat const ContentFontSize = 12.5;
static CGFloat const titleFontSize = 11.5;
// 距离上边控件的距离
static CGFloat const labelUpMargin = 14;
// 距离下边控件的距离
static CGFloat const labelDownMargin = 5;

@interface ODMyOrderDetailController ()

@property(nonatomic, strong) ODMyOrderDetailModel *model;

@property(nonatomic, strong) UIScrollView *scrollView;

// 审核状态
@property(nonatomic, strong) UILabel *checkLabel;

// 中心设备
@property(nonatomic, strong) NSMutableArray *devicesArray;


@end

@implementation ODMyOrderDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.devicesArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"预约详情";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];
    if (self.isOther == NO && ![self.status_str isEqualToString:@"已取消"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelOrderButtonClick:) color:nil highColor:nil title:@"取消预约"];
    }
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

#pragma mark - Load Data Request
- (void)getOrderDetailRequest {
    NSDictionary *parameter = @{@"order_id" : [NSString stringWithFormat:@"%@", self.order_id],
                                @"call_array" : @"1"
                                };
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreInfoOrder parameters:parameter modelClass:[ODMyOrderDetailModel class] success:^(id model) {
        weakSelf.model = [model result];
        for (ODMyOrderDetailDevicesModel *devices in [[model result] devices]) {
            [weakSelf.devicesArray addObject:devices.name];
        }
        [weakSelf createScrollView];
    }
    failure:^(NSError *error) {
        
    }];
}

#pragma mark - Create UIScrollView
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor backgroundColor];
    
#pragma mark - 预约时间
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    timeView.backgroundColor = [UIColor whiteColor];
    timeView.layer.cornerRadius = viewCornerRadius;
    timeView.layer.borderColor = [UIColor lineColor].CGColor;
    timeView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:timeView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin,  viewLeftMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight)];
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@",self.model.start_date_str,self.model.end_date_str];
    timeLabel.textColor = [UIColor colorGloomyColor];
    timeLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:timeLabel];
    
#pragma mark - 体验中心名称
    UIView *experienceCenterView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(timeView.frame) + viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    experienceCenterView.backgroundColor = [UIColor whiteColor];
    experienceCenterView.layer.cornerRadius = viewCornerRadius;
    experienceCenterView.layer.borderColor = [UIColor lineColor].CGColor;
    experienceCenterView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:experienceCenterView];
    
    UILabel *experienceCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(timeLabel.frame) + viewLeftMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight)];
    experienceCenterLabel.text = [NSString stringWithFormat:@"%@",self.model.store_name];
    experienceCenterLabel.textColor = [UIColor colorGloomyColor];
    experienceCenterLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:experienceCenterLabel];
    
#pragma mark - 中心设备
    UILabel *deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(experienceCenterLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, 11.5)];
    deviceLabel.text = @"需要使用的中心设备";
    deviceLabel.font = [UIFont systemFontOfSize:titleFontSize];
    deviceLabel.textColor = [UIColor colorGraynessColor];

    [self.scrollView addSubview:deviceLabel];
    
    NSMutableString *devicesName = [[NSMutableString alloc] init];
    if (self.devicesArray.count == 0) {
        [devicesName appendString:@"无"];
    }
    else {
        for (int i = 0; i < self.devicesArray.count; i++) {
            [devicesName appendString:[NSString stringWithFormat:@"%@ , ", self.devicesArray[i]]];
        }
        [devicesName deleteCharactersInRange:NSMakeRange(devicesName.length - 2, 2)];
    }
    
    UIView *deviceDetailView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(deviceLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    deviceDetailView.backgroundColor = [UIColor whiteColor];
    deviceDetailView.layer.cornerRadius = viewCornerRadius;
    deviceDetailView.layer.borderColor = [UIColor lineColor].CGColor;
    deviceDetailView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:deviceDetailView];
    
    UILabel *deviceDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(deviceLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight)];
    deviceDetailLabel.text = [NSString stringWithFormat:@"%@",devicesName];
    deviceDetailLabel.textColor = [UIColor colorGloomyColor];
    deviceDetailLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:deviceDetailLabel];
    
#pragma mark - 活动目的
    UILabel *purposeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(deviceDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, titleFontSize)];
    purposeLabel.text = @"活动目的";
    purposeLabel.textColor = [UIColor colorGraynessColor];
    purposeLabel.font = [UIFont systemFontOfSize:titleFontSize];
    [self.scrollView addSubview:purposeLabel];
    
    UIView *purposeDetailView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(purposeLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    purposeDetailView.backgroundColor = [UIColor whiteColor];
    purposeDetailView.layer.cornerRadius = viewCornerRadius;
    purposeDetailView.layer.borderColor = [UIColor lineColor].CGColor;
    purposeDetailView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:purposeDetailView];
    
    UILabel *purposeDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(purposeLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight)];
    purposeDetailLabel.text = [NSString stringWithFormat:@"%@",self.model.purpose];
    purposeDetailLabel.textColor = [UIColor colorGloomyColor];
    purposeDetailLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    
    [self.scrollView addSubview:purposeDetailLabel];
    
#pragma mark - 活动内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(purposeDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, titleFontSize)];
    contentLabel.text = @"活动内容";
    contentLabel.textColor = [UIColor colorGraynessColor];
    contentLabel.font = [UIFont systemFontOfSize:titleFontSize];
    [self.scrollView addSubview:contentLabel];
    
    UIView *contentDetailView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(contentLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - ODLeftMargin * 2 miniHeight:labelHeight fontSize:ContentFontSize])];
    contentDetailView.backgroundColor = [UIColor whiteColor];
    contentDetailView.layer.cornerRadius = viewCornerRadius;
    contentDetailView.layer.borderColor = [UIColor lineColor].CGColor;
    contentDetailView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:contentDetailView];
    
    UILabel *contentDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(contentLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2,[ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - ODLeftMargin * 2 miniHeight:labelHeight fontSize:ContentFontSize])];
    contentDetailLabel.numberOfLines = 0;
    contentDetailLabel.text = [NSString stringWithFormat:@"%@",self.model.content];
    contentDetailLabel.textColor = [UIColor colorGloomyColor];
    contentDetailLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:contentDetailLabel];
    
#pragma mark - 参加人数
    UILabel *peopleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(contentDetailLabel.frame) + labelUpMargin, kScreenSize.width - ODLeftMargin * 2, titleFontSize)];
    peopleNumberLabel.text = @"参加人数";
    peopleNumberLabel.textColor = [UIColor colorGraynessColor];
    peopleNumberLabel.font = [UIFont systemFontOfSize:titleFontSize];
    [self.scrollView addSubview:peopleNumberLabel];
    
    UIView *peopleNumberDetailView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(peopleNumberLabel.frame) + labelDownMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    peopleNumberDetailView.backgroundColor = [UIColor whiteColor];
    peopleNumberDetailView.layer.cornerRadius = viewCornerRadius;
    peopleNumberDetailView.layer.borderColor = [UIColor colorWithRGBString:@"#e6e6e6" alpha:1].CGColor;
    peopleNumberDetailView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:peopleNumberDetailView];
    
    UILabel *peopleNumberDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(peopleNumberLabel.frame) + labelDownMargin, kScreenSize.width - ODLeftMargin * 2, labelHeight)];
    peopleNumberDetailLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",self.model.people_num]];
    peopleNumberDetailLabel.textColor = [UIColor colorGloomyColor];
    peopleNumberDetailLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:peopleNumberDetailLabel];
    
#pragma mark - 场地电话
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, KScreenWidth - viewLeftMargin * 2, labelHeight)];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.cornerRadius = viewCornerRadius;
    phoneView.layer.borderColor = [UIColor lineColor].CGColor;
    phoneView.layer.borderWidth = viewBorderWidth;
    [self.scrollView addSubview:phoneView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin,  CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, kScreenSize.width - viewLeftMargin * 2, labelHeight)];
    phoneLabel.text = @"场地预约电话:";
    phoneLabel.textColor = [UIColor colorGloomyColor];
    phoneLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [self.scrollView addSubview:phoneLabel];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(ODLeftMargin + ContentFontSize * 7, CGRectGetMaxY(peopleNumberDetailLabel.frame) + viewLeftMargin, 100, labelHeight)];
    
    [phoneButton setTitle:[NSString stringWithFormat:@"%@",self.model.store_tel] forState:UIControlStateNormal];
    [phoneButton setTitleColor:[UIColor colorWithRGBString:@"#004dda" alpha:1] forState:UIControlStateNormal];
    phoneButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    [phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:phoneButton];
    
#pragma mark - 审核状态
    self.checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewLeftMargin, CGRectGetMaxY(phoneLabel.frame) + viewLeftMargin, kScreenSize.width - viewLeftMargin * 2, labelHeight)];
    self.checkLabel.text = [NSString stringWithFormat:@"%@",self.model.status_str];
    self.checkLabel.textColor = [UIColor blackColor];
    self.checkLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    self.checkLabel.textAlignment = NSTextAlignmentCenter;
    self.checkLabel.layer.masksToBounds = YES;
    self.checkLabel.layer.cornerRadius = viewCornerRadius;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [UIColor lineColor].CGColor;
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.checkLabel.frame) + 3);
    [self.scrollView addSubview:self.checkLabel];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Action

#pragma mark - 取消预约
- (void)cancelOrderButtonClick:(UIButton *)button {
    if ([self.checkLabel.text isEqualToString:@"后台取消"]) {
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

#pragma mark - 返回刷新
- (void)backAction:(UIBarButtonItem *)sender {
    NSDictionary *statusDict =[[NSDictionary alloc] initWithObjectsAndKeys:self.status_str,@"status_str", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationCancelOrder object:nil userInfo:statusDict];
    [self.navigationController popViewControllerAnimated:YES];
}


@end

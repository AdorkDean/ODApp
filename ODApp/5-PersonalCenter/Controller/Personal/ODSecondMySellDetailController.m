//
//  ODSecondMySellDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODSecondMySellDetailController.h"
#import "ODSecondOrderDetailView.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"
#import "ODCancelOrderView.h"
#import "ODDrawbackController.h"

@interface ODSecondMySellDetailController () <UITextViewDelegate>


@property(nonatomic, strong) ODSecondOrderDetailView *orderDetailView;
@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) ODCancelOrderView *cancelOrderView;


@property(nonatomic, strong) UIButton *deliveryButton;
@property(nonatomic, strong) UIButton *DealDeliveryButton;
@property(nonatomic, strong) UIButton *reasonButton;

@property(nonatomic, strong) UIScrollView *scroller;


@property(nonatomic, copy) NSString *phoneNumber;

@end

@implementation ODSecondMySellDetailController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";


    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(backAction:) color:nil highColor:nil title:@"返回"];


}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
- (void)createScroller {
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.scroller.backgroundColor = [UIColor whiteColor];
    self.scroller.userInteractionEnabled = YES;
    
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];
    
    if ([status isEqualToString:@"-1"]) {
        
        if (iPhone4_4S) {
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 350);
            
        } else if (iPhone5_5s) {
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 250);
            
            
        } else {
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 150);
            
            
        }
        
    } else {
        
        
        if (iPhone4_4S) {
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 290);
            
        } else if (iPhone5_5s) {
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 190);
            
        } else {
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 70);
            
            
        }
        
        
    }
    
    
    [self.view addSubview:self.scroller];
    
    
    if ([status isEqualToString:@"2"]) {
        
        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.deliveryButton setTitle:@"确认发货" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];
        
        
    } else if ([status isEqualToString:@"3"]) {
        
        
        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.deliveryButton setTitle:@"确认服务" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];
        
        
    }
    
    
    else if ([status isEqualToString:@"-2"]) {
        
        self.DealDeliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.DealDeliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.DealDeliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.DealDeliveryButton setTitle:@"处理退款" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.DealDeliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.DealDeliveryButton addTarget:self action:@selector(DealDeliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.DealDeliveryButton];
        
        
    } else if ([status isEqualToString:@"-3"] || [status isEqualToString:@"-4"] || [status isEqualToString:@"-5"]) {
        
        self.reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.reasonButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        self.reasonButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [self.reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.reasonButton];
        
    }
    
    [self createOrderView];
}

- (void)createOrderView {
    self.orderDetailView = [ODSecondOrderDetailView getView];
    self.orderDetailView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    
    ODOrderDetailModel *model = self.dataArray[0];
    
    NSMutableDictionary *dic = model.user;
    [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", dic[@"avatar"]]] forState:UIControlStateNormal];
    self.orderDetailView.nickLabel.text = dic[@"nick"];
    
    
    NSMutableArray *arr = model.imgs_small;
    NSMutableDictionary *picDic = arr[0];
    
    NSString *status = [NSString stringWithFormat:@"%@", model.order_status];
    
    
    if ([status isEqualToString:@"-1"]) {
        
        
        
        CGRect rect = [model.address boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 93, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                  context:nil];
        
        
        //订单取消原因
        UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(18, self.orderDetailView.spaceLabel.frame.origin.y + rect.size.height, 100, 20)];
        reason.backgroundColor = [UIColor whiteColor];
        reason.font = [UIFont systemFontOfSize:14];
        reason.text = @"订单取消原因";
        reason.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reason];
        
        UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(18, reason.frame.origin.y + 30, kScreenSize.width - 18, 1)];
        secondLine.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:secondLine];
        
        
        float reasonHeight;
        reasonHeight = [ODHelp textHeightFromTextString:model.reason width:KScreenWidth - 36 miniHeight:35 fontSize:14];
        
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, secondLine.frame.origin.y + 5, kScreenSize.width - 36, reasonHeight)];
        reasonLabel.backgroundColor = [UIColor whiteColor];
        reasonLabel.font = [UIFont systemFontOfSize:14];
        reasonLabel.numberOfLines = 0;
        reasonLabel.text = model.reason;
        reasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reasonLabel];
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(reasonLabel.frame), kScreenSize.width, 6)];
        line.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
        [self.orderDetailView addSubview:line];
        self.orderDetailView.spaceToTop.constant = reasonHeight + 62;
        
    }
    
    
    [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@", picDic[@"img_url"]]] forState:UIControlStateNormal];
    self.orderDetailView.contentLabel.text = model.title;
    self.orderDetailView.countLabel.text = [NSString stringWithFormat:@"%@", model.num];
    self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@", model.order_price, model.unit];
    self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元", model.total_price];
    self.orderDetailView.typeLabel.text = self.orderType;
    self.orderDetailView.addressNameLabel.text = model.name;
    self.orderDetailView.addressPhoneLabel.text = model.tel;
    [self.orderDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.orderDetailView.swapTypeLabel.text = @"上门服务";
    
    
    self.orderDetailView.serviceAddressLabel.text = model.address;
    self.orderDetailView.serviceTimeLabel.text = model.service_time;
    
    self.orderDetailView.orderTimeLabel.text = model.order_created_at;
    self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@", model.order_id];
    
    
    if ([status isEqualToString:@"1"]) {
        self.orderDetailView.typeLabel.text = @"待支付";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"2"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"3"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"4"]) {
        
        
        NSString *swap_Type = [NSString stringWithFormat:@"%@", model.swap_type];
        
        
        if ([swap_Type isEqualToString:@"2"]) {
            
            self.orderDetailView.typeLabel.text = @"已发货";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
            
        } else {
            
            self.orderDetailView.typeLabel.text = @"已服务";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
        }
        
    } else if ([status isEqualToString:@"5"]) {
        self.orderDetailView.typeLabel.text = @"已评价";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-1"]) {
        self.orderDetailView.typeLabel.text = @"已取消";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    } else if ([status isEqualToString:@"-2"]) {
        self.orderDetailView.typeLabel.text = @"买家已申请退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-3"]) {
        self.orderDetailView.typeLabel.text = @"退款已受理";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-4"]) {
        self.orderDetailView.typeLabel.text = @"已退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    } else if ([status isEqualToString:@"-5"]) {
        self.orderDetailView.typeLabel.text = @"拒绝退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }
    
    [self.scroller addSubview:self.orderDetailView];
    
}

#pragma mark - 获取数据
- (void)getData {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.orderId;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrderInfo parameters:params modelClass:[ODOrderDetailModel class] success:^(id model)
     {
         [weakSelf.dataArray removeAllObjects];
         [weakSelf.dataArray addObject:[model result]];
         
         ODOrderDetailModel *statusModel = self.dataArray[0];
         NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
         
         if (![weakSelf.orderStatus isEqualToString:orderStatue]) {
             
             NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
             NSNotification *notification = [NSNotification notificationWithName:ODNotificationSellOrderSecondRefresh object:nil userInfo:dic];
             
             [[NSNotificationCenter defaultCenter] postNotification:notification];
         }
         [weakSelf createScroller];
     } failure:^(NSError *error) {
     }];
}

#pragma mark - 事件方法
- (void)backAction:(UIBarButtonItem *)sender {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRefrash:) name:ODNotificationSellOrderThirdRefresh object:nil];

    [self.navigationController popViewControllerAnimated:YES];


}

- (void)backRefrash:(NSNotification *)text {

    ODOrderDetailModel *statusModel = self.dataArray[0];
    NSString *orderStatue = [NSString stringWithFormat:@"%@", statusModel.order_status];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:orderStatue, @"orderStatus", nil];
    NSNotification *notification = [NSNotification notificationWithName:ODNotificationSellOrderSecondRefresh object:nil userInfo:dic];

    [[NSNotificationCenter defaultCenter] postNotification:notification];


}

- (void)receiveAction:(UIButton *)sender {

    ODDrawbackController *vc = [[ODDrawbackController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";


    [self.navigationController pushViewController:vc animated:YES];


}

- (void)reasonAction:(UIButton *)sender {

    ODDrawbackController *vc = [[ODDrawbackController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@", model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    if ([model.reject_reason isEqualToString:@""]) {

        vc.isRefuseReason = NO;

    } else {

        vc.isRefuseReason = YES;
        vc.refuseReason = model.reject_reason;
    }

    [self.navigationController pushViewController:vc animated:YES];


}

- (void)DealDeliveryAction:(UIButton *)sender {

    ODDrawbackController *vc = [[ODDrawbackController alloc] init];

    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.total_price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isRefuseAndReceive = YES;
    vc.drawbackTitle = @"退款处理";


    [self.navigationController pushViewController:vc animated:YES];


}

- (void)deliveryAction:(UIButton *)sender {
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = self.orderId;
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapConfirmDelivery parameters:params modelClass:[NSObject class] success:^(id model)
     {
        [weakSelf.deliveryButton removeFromSuperview];
         
         ODOrderDetailModel *statusModel = weakSelf.dataArray[0];
         weakSelf.orderStatus = [NSString stringWithFormat:@"%@", statusModel.order_status];

         if (weakSelf.getRefresh) {

             weakSelf.getRefresh(@"1");
         }
         
         [weakSelf getData];
         [ODProgressHUD showInfoWithStatus:@"操作成功"];
     } failure:^(NSError *error) {
     }];
}

// 打电话
- (void)phoneAction:(UIButton *)sender
{
    [self.view callToNum:self.orderDetailView.addressPhoneLabel.text];
}

@end

//
//  ODSecondMySellDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSecondMySellDetailController.h"
#import "ODSecondOrderDetailView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"
#import "ODCancelOrderView.h"
#import "ODDrawbackBuyerOneController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODSecondMySellDetailController ()<UITextViewDelegate>


@property (nonatomic , strong) ODSecondOrderDetailView *orderDetailView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic, strong) AFHTTPRequestOperationManager *deliveryManager;
@property (nonatomic ,strong) ODCancelOrderView *cancelOrderView;


@property (nonatomic , strong) UIButton *deliveryButton;
@property (nonatomic , strong) UIButton *DealDeliveryButton;
@property (nonatomic , strong) UIButton *reasonButton;

@property (nonatomic ,strong) UIScrollView *scroller;


@property (nonatomic , copy) NSString *phoneNumber;

@end

@implementation ODSecondMySellDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}


- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"order_id":self.orderId , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kOrderDetailUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                
                [self.dataArray removeAllObjects];
                NSMutableDictionary *dic = responseObject[@"result"];
                ODOrderDetailModel *model = [[ODOrderDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
                
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
            [weakSelf createScroller];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
    
}


- (void)createScroller
{
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.scroller.backgroundColor = [UIColor whiteColor];
    self.scroller.userInteractionEnabled = YES;
    
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    if ([status isEqualToString:@"-1"]) {
        
        if (iPhone4_4S) {
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 300);
            
        }else if (iPhone5_5s){
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 100);
            
            
        }else  {
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 50);
            
            
        }
        
    }else{
        
        
        if (iPhone4_4S) {
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 220);
            
        }else  if (iPhone5_5s){
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 150);
            
        }else  {
            
            
            self.scroller.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height + 50);
            
            
        }
        
        
        
    }
    
    
    
    
    
    [self.view addSubview:self.scroller];
    
    
    if ([status isEqualToString:@"2"]) {
        
        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [ self.deliveryButton setTitle:@"确认发货" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [ self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];
        
        
        
    }else if([status isEqualToString:@"3"]) {
        
        
        
        self.deliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.deliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [ self.deliveryButton setTitle:@"确认服务" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [ self.deliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ self.deliveryButton addTarget:self action:@selector(deliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.deliveryButton];
        
        
        
    }
    
    
    
    else if ([status isEqualToString:@"-2"]) {
        
        self.DealDeliveryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.DealDeliveryButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.DealDeliveryButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.DealDeliveryButton setTitle:@"处理退款" forState:UIControlStateNormal];
        self.deliveryButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [self.DealDeliveryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.DealDeliveryButton addTarget:self action:@selector(DealDeliveryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.DealDeliveryButton];
        
        
        
    }else if ([status isEqualToString:@"-3"] || [status isEqualToString:@"-4"]||[status isEqualToString:@"-5"] ) {
        
        self.reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        self.reasonButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        self.reasonButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [self.reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.reasonButton];
        
        
        
    }
    
    [self createOrderView];
    
    
    
}


- (void)receiveAction:(UIButton *)sender
{
    
    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@" , model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
    
}




- (void)reasonAction:(UIButton *)sender
{
    
    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isService = YES;
    vc.servicePhone = [NSString stringWithFormat:@"%@" , model.tel400];
    vc.serviceTime = model.tel_msg;
    vc.customerService = @"服务";
    vc.drawbackTitle = @"退款信息";
    if ([model.reject_reason isEqualToString:@""]) {
        
        vc.isRefuseReason = NO;
        
    }else{
        
        vc.isRefuseReason = YES;
        vc.refuseReason = model.reject_reason;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


- (void)DealDeliveryAction:(UIButton *)sender
{
    
    ODDrawbackBuyerOneController *vc = [[ODDrawbackBuyerOneController alloc] init];
    
    ODOrderDetailModel *model = self.dataArray[0];
    vc.darwbackMoney = model.price;
    vc.order_id = self.orderId;
    vc.drawbackReason = model.reason;
    vc.isRefuseAndReceive = YES;
    vc.drawbackTitle = @"退款处理";
    
        
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (void)deliveryAction:(UIButton *)sender
{
    
    
    self.deliveryManager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    
    NSDictionary *parameters = @{@"order_id":self.orderId , @"open_id":openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    __weak typeof (self)weakSelf = self;
    [self.deliveryManager GET:kDeliveryUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            
            
            [self.deliveryButton removeFromSuperview];
            
            
            
            if (self.getRefresh) {
                
                
                
                weakSelf.getRefresh(@"1");
            }
            
            
            
            [self getData];
                    
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]) {
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
}


- (void)createOrderView
{
    self.orderDetailView = [ODSecondOrderDetailView getView];
    self.orderDetailView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    
    ODOrderDetailModel *model = self.dataArray[0];
    
    NSMutableDictionary *dic = model.order_user;
    [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , dic[@"avatar"]]] forState:UIControlStateNormal];
    self.orderDetailView.nickLabel.text = dic[@"nick"];

    
    
  
    NSMutableArray *arr = model.imgs_small;
    NSMutableDictionary *picDic = arr[0];
    
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    
    if ([status isEqualToString:@"-1"]) {
        self.orderDetailView.spaceToTop.constant = 150;
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.orderDetailView.serviceAddressLabel.frame.origin.y + 30, kScreenSize.width, 6)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        [self.orderDetailView addSubview:line];
        
        UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(18, line.frame.origin.y + 16, 100, 20)];
        reason.backgroundColor = [UIColor whiteColor];
        reason.font = [UIFont systemFontOfSize:14];
        reason.text = @"订单取消原因";
        reason.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reason];
        
        UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(18, reason.frame.origin.y + 30, kScreenSize.width - 18, 1)];
        secondLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
        [self.orderDetailView addSubview:secondLine];
        
        
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, secondLine.frame.origin.y + 11, kScreenSize.width - 36, 50)];
        reasonLabel.backgroundColor = [UIColor whiteColor];
        reasonLabel.font = [UIFont systemFontOfSize:14];
        reasonLabel.numberOfLines = 0;
        reasonLabel.text = model.reason;
        reasonLabel.textAlignment = NSTextAlignmentLeft;
        [self.orderDetailView addSubview:reasonLabel];
        
        
    }
    
    
    
     [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , picDic[@"img_url"]]] forState:UIControlStateNormal];
      self.orderDetailView.contentLabel.text = model.title;
        self.orderDetailView.countLabel.text = [NSString stringWithFormat:@"%@" , model.num];
    self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" ,model.price , model.unit];
    self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元" , model.total_price];
    self.orderDetailView.typeLabel.text = self.orderType;
    self.orderDetailView.addressNameLabel.text = model.name;
    self.orderDetailView.addressPhoneLabel.text = model.tel;
      [self.orderDetailView.phoneButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
  

    self.orderDetailView.swapTypeLabel.text = @"上门服务";
    
    self.orderDetailView.serviceAddressLabel.text = model.address;
    self.orderDetailView.serviceTimeLabel.text = model.service_time;
    
    self.orderDetailView.orderTimeLabel.text = model.order_created_at;
    self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@" , model.order_id];
    
    
    
    
    
    
    if ([status isEqualToString:@"1"]) {
        self.orderDetailView.typeLabel.text = @"待支付";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"2"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"3"]) {
        self.orderDetailView.typeLabel.text = @"已付款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"4"]) {
        
        
     NSString *swap_Type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        
        if ([swap_Type isEqualToString:@"2"]) {
            
            self.orderDetailView.typeLabel.text = @"已发货";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
            
        }else{
            
            self.orderDetailView.typeLabel.text = @"已服务";
            self.orderDetailView.typeLabel.textColor = [UIColor redColor];
        }
        
    }else if ([status isEqualToString:@"5"]) {
        self.orderDetailView.typeLabel.text = @"已评价";
         self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-1"]) {
        self.orderDetailView.typeLabel.text = @"已取消";
        self.orderDetailView.typeLabel.textColor = [UIColor lightGrayColor];
    }else if ([status isEqualToString:@"-2"]) {
        self.orderDetailView.typeLabel.text = @"买家已申请退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-3"]) {
        self.orderDetailView.typeLabel.text = @"退款已受理";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-4"]) {
        self.orderDetailView.typeLabel.text = @"已退款";
         self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }else if ([status isEqualToString:@"-5"]) {
        self.orderDetailView.typeLabel.text = @"拒绝退款";
        self.orderDetailView.typeLabel.textColor = [UIColor redColor];
    }
    
    
    [self.scroller addSubview:self.orderDetailView];

}

// 打电话
- (void)phoneAction:(UIButton *)sender
{
    
    ODOrderDetailModel *model = self.dataArray[0];
    
    NSMutableDictionary *dic = model.order_user;
    
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",dic[@"mobile"]];
    
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

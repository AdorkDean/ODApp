//
//  ODOrderDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODOrderDetailController.h"
#import "ODOrderDetailView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOrderDetailModel.h"
#import "UIButton+WebCache.h"
#import "ODPayController.h"


@interface ODOrderDetailController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ODOrderDetailView *orderDetailView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) AFHTTPRequestOperationManager *delateManager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , strong) NSMutableArray *dataArray;


@end

@implementation ODOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.userInteractionEnabled = YES;

      self.dataArray = [[NSMutableArray alloc] init];
      self.open_id = [ODUserInformation sharedODUserInformation].openID;
      self.navigationItem.title = @"订单详情";
      [self getData];
      
    
}


- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"order_id":self.order_id , @"open_id":self.open_id};
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
            

            [weakSelf creatView];

        

            [weakSelf.tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
    
}


- (void)creatView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height + 100) style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.orderDetailView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    
    ODOrderDetailModel *model = self.dataArray[0];
    NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
    
    if ([status isEqualToString:@"3"]) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_Cancel order"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        refundButton.backgroundColor = [UIColor redColor];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];
        
        
        
    }else if ([status isEqualToString:@"1"]) {
        
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_Cancel order"] forState:UIControlStateNormal];
        
        [cancelButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelButton];
        
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
        payButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        [payButton setBackgroundImage:[UIImage imageNamed:@"button_Pay immediately"] forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payButton];
        
        
        
        
    }else if ([status isEqualToString:@"-2"]) {
        
        
        
        UIButton *dealRefundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        dealRefundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        dealRefundButton.backgroundColor = [UIColor redColor];
        [dealRefundButton setTitle:@"处理退款" forState:UIControlStateNormal];
        dealRefundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [dealRefundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dealRefundButton addTarget:self action:@selector(dealRefundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dealRefundButton];
        
        
        
    }else if ([status isEqualToString:@"5"]) {
        
        
        
        UIButton *evaluationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        evaluationButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        evaluationButton.backgroundColor = [UIColor redColor];
        [evaluationButton setTitle:@"评价" forState:UIControlStateNormal];
        evaluationButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [evaluationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [evaluationButton addTarget:self action:@selector(evaluationAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:evaluationButton];
        
        
        
    }else if ([status isEqualToString:@"4"]) {
        
        
        
        
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeSystem];
        refundButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        refundButton.backgroundColor = [UIColor lightGrayColor];
        [refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [refundButton addTarget:self action:@selector(refundAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundButton];
        
        
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
        confirmButton.backgroundColor = [UIColor redColor];
        [confirmButton setTitle:@"确认完成" forState:UIControlStateNormal];
        confirmButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmButton];
        
        
        
        
        
    }else if ([status isEqualToString:@"-5"]) {
        
        
        
        UIButton *reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        reasonButton.backgroundColor = [UIColor redColor];
        [reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        reasonButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reasonButton];
        
        
        
    }else if ([status isEqualToString:@"-3"]) {
        
        
        
        UIButton *reasonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        reasonButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50);
        reasonButton.backgroundColor = [UIColor redColor];
        [reasonButton setTitle:@"查看原因" forState:UIControlStateNormal];
        reasonButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [reasonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reasonButton addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reasonButton];
        
        
        
    }

    
      
    
}


// 查看原因
-(void)reasonAction:(UIButton *)sender
{
    
    
    
}
// 确认完成
-(void)confirmAction:(UIButton *)sender
{
    
}


// 评价
- (void)evaluationAction:(UIButton *)sender
{
    
}


// 处理退款
- (void)dealRefundAction:(UIButton *)sender
{
    
}

// 取消订单
- (void)cancelOrder:(UIButton *)sender
{
    
}

// 申请退款
- (void)refundAction:(UIButton *)sender
{
    
    
    
    
}

- (void)payAction:(UIButton *)sender
{
    ODPayController *vc = [[ODPayController alloc] init];
    ODOrderDetailModel *model = self.dataArray[0];
    vc.orderId = [NSString stringWithFormat:@"%@" ,model.order_id];
    vc.OrderTitle = model.title;
    vc.price = [NSString stringWithFormat:@"%@" , model.price];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//- (void)delateOrder:(UIButton *)sender
//{
//    self.delateManager = [AFHTTPRequestOperationManager manager];
//    
//    
//      
//    NSDictionary *parameters = @{@"order_id":self.order_id , @"open_id":self.open_id};
//    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
//    
//    __weak typeof (self)weakSelf = self;
//    [self.delateManager GET:kDelateOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if (responseObject) {
//            
//            
//            if ([responseObject[@"status"]isEqualToString:@"success"]) {
//                
//                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"取消订单成功"];
//                
//                
//                
//                if (self.getRefresh) {
//                    
//                    
//                    
//                    weakSelf.getRefresh(@"1");
//                }
//
//
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                
//                
//            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
//                
//                
//                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
//                
//                
//            }
//            
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
//    }];
//    
//
//}





- (ODOrderDetailView *)orderDetailView
{
    if (_orderDetailView == nil) {
        self.orderDetailView = [ODOrderDetailView getView];

        
        ODOrderDetailModel *model = self.dataArray[0];
        NSMutableDictionary *userDic = model.user;
        NSMutableArray *arr = model.imgs_small;
        NSMutableDictionary *picDic = arr[0];
        
        
        
        [self.orderDetailView.userButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , userDic[@"avatar"]]] forState:UIControlStateNormal];
        [self.orderDetailView.contentButtonView sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[NSString stringWithFormat:@"%@" , picDic[@"img_url"]]] forState:UIControlStateNormal];
        self.orderDetailView.nickLabel.text = userDic[@"nick"];
        self.orderDetailView.contentLabel.text = model.title;
        self.orderDetailView.priceLabel.text = [NSString stringWithFormat:@"%@元/%@" ,model.price , model.unit];
        self.orderDetailView.allPriceLabel.text = [NSString stringWithFormat:@"%@元" , model.price];
        self.orderDetailView.typeLabel.text = self.orderType;
        self.orderDetailView.addressNameLabel.text = model.name;
        self.orderDetailView.addressPhoneLabel.text = model.tel;
        
        NSString *swap_type = [NSString stringWithFormat:@"%@" , model.swap_type];
        
        if ([swap_type isEqualToString:@"2"]) {
            
             self.orderDetailView.serviceTimeLabel.text = model.address;
            self.orderDetailView.serviceTypeLabel.text = @"服务地址:";
             self.orderDetailView.swapTypeLabel.text = @"快递服务";
            
        }else{
            self.orderDetailView.serviceTimeLabel.text = model.service_time;
               self.orderDetailView.serviceTypeLabel.text = @"服务时间:";
             self.orderDetailView.swapTypeLabel.text = @"线上服务";

        }
        
        self.orderDetailView.orderTimeLabel.text = model.order_created_at;
        self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@" , model.order_id];
        


        NSString *status = [NSString stringWithFormat:@"%@" , model.order_status];
        
        
        if ([status isEqualToString:@"1"]) {
            self.orderDetailView.typeLabel.text = @"已下单未付款";
        }else if ([status isEqualToString:@"2"]) {
            self.orderDetailView.typeLabel.text = @"已付款未发货";
        }else if ([status isEqualToString:@"3"]) {
            self.orderDetailView.typeLabel.text = @"已付款";
        }else if ([status isEqualToString:@"4"]) {
           self.orderDetailView.typeLabel.text = @"已发货";
        }else if ([status isEqualToString:@"5"]) {
            self.orderDetailView.typeLabel.text = @"已完成";
        }else if ([status isEqualToString:@"-1"]) {
            self.orderDetailView.typeLabel.text = @"已取消";
        }else if ([status isEqualToString:@"-2"]) {
            self.orderDetailView.typeLabel.text = @"退款申请";
        }else if ([status isEqualToString:@"-3"]) {
            self.orderDetailView.typeLabel.text = @"退款已确认";
        }else if ([status isEqualToString:@"-4"]) {
           self.orderDetailView.typeLabel.text = @"已退款";
        }else if ([status isEqualToString:@"-5"]) {
            self.orderDetailView.typeLabel.text = @"拒绝退款";
        }

        
        

    }
    
    return _orderDetailView;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end

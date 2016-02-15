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
    

      self.dataArray = [[NSMutableArray alloc] init];

      self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.navigationItem.title = @"订单详情";
      [self getData];
     [self creatView];

    
    
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

  
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 64 - 50) style:UITableViewStylePlain];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.orderDetailView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"button_Cancel order"] forState:UIControlStateNormal];

    [cancelButton addTarget:self action:@selector(delateOrder:) forControlEvents:UIControlEventTouchUpInside];


    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    payButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 50 - 64, kScreenSize.width / 2, 50);
    [payButton setBackgroundImage:[UIImage imageNamed:@"button_Pay immediately"] forState:UIControlStateNormal];
    [self.view addSubview:payButton];
    [self.view addSubview:cancelButton];
    

}


- (void)delateOrder:(UIButton *)sender
{
    self.delateManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"order_id":self.order_id , @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.delateManager GET:kDelateOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"取消订单成功"];
                
                
                
                if (self.getRefresh) {
                    
                    
                    
                    weakSelf.getRefresh(@"1");
                }


                [self.navigationController popViewControllerAnimated:YES];
                
                
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
                
                
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    

}





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
        self.orderDetailView.serviceTimeLabel.text = model.service_time;
        self.orderDetailView.orderTimeLabel.text = model.order_created_at;
        self.orderDetailView.orderIdLabel.text = [NSString stringWithFormat:@"%@" , model.order_id];
        



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

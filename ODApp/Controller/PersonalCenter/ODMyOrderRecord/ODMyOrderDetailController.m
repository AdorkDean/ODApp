//
//  ODMyOrderDetailController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/11.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyOrderDetailController.h"
#import "ODUserInformation.h"
@interface ODMyOrderDetailController ()

@end

@implementation ODMyOrderDetailController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    self.devicesArray = [[NSMutableArray alloc] init];
    [self navigationInit];
    [self getOrderDetailRequest];
}

- (void)navigationInit
{
    self.navigationItem.title = @"预约详情";
    if (self.isOther == NO)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelOrderButtonClick:) color:nil highColor:nil title:@"取消预约"];
     }
}

- (void)cancelOrderButtonClick:(UIButton *)button
{

    if ([self.checkLabel.text isEqualToString:@"已取消"] || [self.checkLabel.text isEqualToString:@"后台取消"]) {
        
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"订单已经取消"];
    }else if ([self.checkLabel.text isEqualToString:@"前台已确认"]) {
    
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"订单已生成,请联系客服"];
    }else if ([self.checkLabel.text isEqualToString:@"到场已确认"] || [self.checkLabel.text isEqualToString:@"未到场"]) {
    
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"已到活动时间，无需进行取消"];
    }
    
    else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要取消预约吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.managers = [AFHTTPRequestOperationManager manager];
            
            NSDictionary *parameter = @{@"open_id":self.open_id,@"order_id":self.order_id};
            NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
            
            __weak typeof (self)weakSelf = self;
            [self.managers GET:kCancelMyOrderUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"取消订单成功"];
                weakSelf.checkLabel.text = @"已取消";
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
            }];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)getOrderDetailRequest{

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    NSDictionary *parameter = @{@"order_id":self.order_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyOrderDetailUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *result = dict[@"result"];
            weakSelf.model = [[ODMyOrderDetailModel alloc]init];
            [weakSelf.model setValuesForKeysWithDictionary:result];
            [weakSelf.dataArray addObject:weakSelf.model];
            
            NSDictionary *devices = result[@"devices"];
            for (NSDictionary *itemDict in devices) {
                NSString *name = itemDict[@"name"];
                [weakSelf.devicesArray addObject:name];
            }

        }
        [weakSelf createOrderView];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)createOrderView{

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    UILabel *timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5,  10, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"  %@ - %@",self.model.start_date_str,self.model.end_date_str] font:14 alignment:@"left" color:@"#000000" alpha:11];
    timeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    timeLabel.layer.masksToBounds = YES;
    timeLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:timeLabel];
    
    UILabel *experienceCenterLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(timeLabel.frame) + 5, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"  %@",self.model.store_name] font:14 alignment:@"left" color:@"#000000" alpha:1];
    experienceCenterLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    experienceCenterLabel.layer.masksToBounds = YES;
    experienceCenterLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:experienceCenterLabel];
    
    UILabel *deviceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(experienceCenterLabel.frame) + 5, kScreenSize.width - 10, 35) text:@"      需要使用的中心设备" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:deviceLabel];
    
    NSString *name = [[NSMutableString alloc] init];

    if (self.devicesArray.count == 0) {
        name = @"无";
    }
    else if (self.devicesArray.count == 1){
        name = self.devicesArray[0];
    }
    else if (self.devicesArray.count == 2){
        name = [NSString stringWithFormat:@"%@,%@",self.devicesArray[0],self.devicesArray[1]];
    }
    else if (self.devicesArray.count == 3){
        name = [NSString stringWithFormat:@"%@,%@,%@",self.devicesArray[0],self.devicesArray[1],self.devicesArray[2]];
    }else{
        name = [NSString stringWithFormat:@"%@,%@,%@,%@",self.devicesArray[0],self.devicesArray[1],self.devicesArray[2],self.devicesArray[3]];
    }
    
    UILabel *deviceDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(deviceLabel.frame) + 5, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"  %@",name] font:14 alignment:@"left" color:@"#000000" alpha:1];
    deviceDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    deviceDetailLabel.layer.masksToBounds = YES;
    deviceDetailLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:deviceDetailLabel];
    
    UILabel *purposeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(deviceDetailLabel.frame) + 5, kScreenSize.width - 10, 35) text:@"      活动目的" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:purposeLabel];
    
    UILabel *purposeDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(purposeLabel.frame) + 5, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"  %@",self.model.purpose] font:14 alignment:@"left" color:@"#000000" alpha:1];
    purposeDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    purposeDetailLabel.layer.masksToBounds = YES;
    purposeDetailLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:purposeDetailLabel];
    
    UILabel *contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(purposeDetailLabel.frame) + 5, kScreenSize.width - 10, 35) text:@"      活动内容" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:contentLabel];
        
    UILabel *contentDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(contentLabel.frame) + 5, kScreenSize.width - 10,[ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - 10 miniHeight:35 fontSize:14] ) text:[NSString stringWithFormat:@"  %@",self.model.content] font:14 alignment:@"left" color:@"#000000" alpha:1];
    
    contentDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    contentDetailLabel.layer.masksToBounds = YES;
    contentDetailLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:contentDetailLabel];
    
    UILabel *peopleNumberLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(contentDetailLabel.frame) + 5, kScreenSize.width - 10, 35) text:@"      参加人数" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.scrollView addSubview:peopleNumberLabel];
    
    UILabel *peopleNumberDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(peopleNumberLabel.frame) + 5, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"  %@",self.model.people_num]] font:14 alignment:@"left" color:@"#000000" alpha:1];
    peopleNumberDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    peopleNumberDetailLabel.layer.masksToBounds = YES;
    peopleNumberDetailLabel.layer.cornerRadius = 5;
    [self.scrollView addSubview:peopleNumberDetailLabel];
    
    UILabel *phoneLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5,  CGRectGetMaxY(peopleNumberDetailLabel.frame) + 5, kScreenSize.width - 10, 35) text:@"  场地预约电话:" font:14 alignment:@"left" color:@"#000000" alpha:1];
    phoneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    phoneLabel.layer.masksToBounds = YES;
    phoneLabel.layer.cornerRadius = 5;
    phoneLabel.layer.borderWidth = 1;
    phoneLabel.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    [self.scrollView addSubview:phoneLabel];
    
    UIButton *phoneButton = [ODClassMethod creatButtonWithFrame:CGRectMake(5 + kScreenSize.width * 2/5, CGRectGetMaxY(peopleNumberDetailLabel.frame) + 5, 100, 35) target:self sel:@selector(phoneButtonClick:) tag:0 image:nil title:self.model.store_tel font:14];
    [self.scrollView addSubview:phoneButton];
    
    self.checkLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, CGRectGetMaxY(phoneLabel.frame) + 5, kScreenSize.width - 10, 35) text:[NSString stringWithFormat:@"%@",self.model.status_str ]font:14 alignment:@"center" color:@"#000000" alpha:1];
    self.checkLabel.layer.masksToBounds = YES;
    self.checkLabel.layer.cornerRadius = 5;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1].CGColor;
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.checkLabel.frame) + 3);
    
//    self.scrollView.layer.masksToBounds = YES;
//    self.scrollView.layer.cornerRadius = 5;
    [self.scrollView addSubview:self.checkLabel];
    [self.view addSubview:self.scrollView];
}

- (void)phoneButtonClick:(UIButton *)button{

    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",self.model.store_tel];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNumber]]];
    [self.view addSubview:callWebView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

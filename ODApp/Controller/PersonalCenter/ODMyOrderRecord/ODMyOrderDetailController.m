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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"e6e6e6" alpha:1];;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.devicesArray = [[NSMutableArray alloc] init];
    
    [self navigationInit];
    [self getOrderDetailRequest];
}

- (void)navigationInit
{
        
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"#f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160) / 2, 28, 160, 20) text:@"预约详情" font:17 alignment:@"center" color:@"#000000" alpha:1];
    [self.headView addSubview:label];
    
    
    UIButton *cancelOrderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 32, 95, 20) target:self sel:@selector(cancelOrderButtonClick:) tag:0 image:nil title:@"取消预约" font:16];
    [cancelOrderButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:cancelOrderButton];

    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16, 44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    self.cancelOrderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 16, 95, 44) target:self sel:@selector(cancelOrderButtonClick:) tag:0 image:nil title:@"取消预约" font:16];
    [self.cancelOrderButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    if (self.isOther == NO) {
        [self.headView addSubview:self.cancelOrderButton];
    }
    
    

}

- (void)backButtonClick:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelOrderButtonClick:(UIButton *)button
{

    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter = @{@"open_id":self.open_id,@"order_id":self.order_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    [self.managers GET:kCancelMyOrderUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.checkLabel.text = @"已取消";   
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
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
            self.model = [[ODMyOrderDetailModel alloc]init];
            [self.model setValuesForKeysWithDictionary:result];
            [self.dataArray addObject:self.model];
            
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

    float spaceY = kScreenSize.height * 28/400;
    float labelHeight = kScreenSize.height * 25 / 400;
    
    UILabel *timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@ - %@",self.model.start_date_str,self.model.end_date_str] font:14 alignment:@"left" color:@"#000000" alpha:11];
    timeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    timeLabel.layer.cornerRadius = 5;
    [self.view addSubview:timeLabel];
    
    UILabel *experienceCenterLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 1, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@",self.model.store_name] font:14 alignment:@"left" color:@"#000000" alpha:1];
    experienceCenterLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    experienceCenterLabel.layer.cornerRadius = 5;
    [self.view addSubview:experienceCenterLabel];
    
    UILabel *deviceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 2, kScreenSize.width - 10, labelHeight) text:@"      需要使用的中心设备" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.view addSubview:deviceLabel];
    
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
    
    UILabel *deviceDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 3, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@",name] font:14 alignment:@"left" color:@"#000000" alpha:1];
    deviceDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    deviceDetailLabel.layer.cornerRadius = 5;
    [self.view addSubview:deviceDetailLabel];
    
    UILabel *purposeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 4, kScreenSize.width - 10, labelHeight) text:@"      活动目的" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.view addSubview:purposeLabel];
    
    UILabel *purposeDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 5, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@",self.model.purpose] font:14 alignment:@"left" color:@"#000000" alpha:1];
    purposeDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    purposeDetailLabel.layer.cornerRadius = 5;
    [self.view addSubview:purposeDetailLabel];
    
    UILabel *contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 6, kScreenSize.width - 10, labelHeight) text:@"      活动内容" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.view addSubview:contentLabel];
    
    UILabel *contentDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 7, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@",self.model.content] font:14 alignment:@"left" color:@"#000000" alpha:1];
    contentDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    contentDetailLabel.layer.cornerRadius = 5;
    [self.view addSubview:contentDetailLabel];
    
    UILabel *peopleNumberLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 8, kScreenSize.width - 10, labelHeight) text:@"      参加人数" font:14 alignment:@"left" color:@"#8e8e8e" alpha:1];
    [self.view addSubview:peopleNumberLabel];
    
    UILabel *peopleNumberDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 9, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"  %@",self.model.people_num]] font:14 alignment:@"left" color:@"#000000" alpha:1];
    peopleNumberDetailLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    peopleNumberDetailLabel.layer.cornerRadius = 5;
    [self.view addSubview:peopleNumberDetailLabel];
    
    UILabel *phoneLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 10, kScreenSize.width - 10, labelHeight) text:@"  场地预约电话:" font:14 alignment:@"left" color:@"#000000" alpha:1];
    phoneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    phoneLabel.layer.cornerRadius = 5;
    phoneLabel.layer.borderWidth = 1;
    phoneLabel.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    [self.view addSubview:phoneLabel];
    
    UIButton *phoneButton = [ODClassMethod creatButtonWithFrame:CGRectMake(5 + kScreenSize.width * 2/5, 64 + 10 + spaceY * 10, 100, labelHeight) target:self sel:@selector(phoneButtonClick:) tag:0 image:nil title:self.model.store_tel font:14];
    [self.view addSubview:phoneButton];
    
    self.checkLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(5, 64 + 10 + spaceY * 11, kScreenSize.width - 10, labelHeight) text:[NSString stringWithFormat:@"  %@",self.model.status_str ]font:14 alignment:@"center" color:@"#000000" alpha:1];
    self.checkLabel.layer.cornerRadius = 5;
    self.checkLabel.layer.borderWidth = 1;
    self.checkLabel.layer.borderColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1].CGColor;
    [self.view addSubview:self.checkLabel];
}

- (void)phoneButtonClick:(UIButton *)button{

    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",self.model.store_tel];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNumber]]];
    [self.view addSubview:callWebView];
}

- (void)viewWillAppear:(BOOL)animated{

    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

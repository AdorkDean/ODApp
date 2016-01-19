//
//  ODCenterYuYueController.m
//  ODApp
//
//  Created by zhz on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterYuYueController.h"
#import "ODTabBarController.h"
#import "CenterYuYueView.h"
#import "ODChoseCenterController.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "ODUserInformation.h"

@interface ODCenterYuYueController ()<UITableViewDataSource , UITableViewDelegate , UITextViewDelegate>


@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) CenterYuYueView *yuYueView;


@property (nonatomic , assign) BOOL isComputer;
@property (nonatomic , assign) BOOL isTouYing;
@property (nonatomic , assign) BOOL isYinXiang;
@property (nonatomic , assign) BOOL isMai;

@property (nonatomic  , strong) UIDatePicker *picker;

@property (nonatomic  , strong) UIButton *cancelButton;
@property (nonatomic  , strong) UIButton *queDingButton;
@property (nonatomic  , assign) BOOL isBeginTime;

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;

@property (nonatomic , copy) NSString *beginTime;
@property (nonatomic , copy) NSString *endTime;
@property (nonatomic , copy) NSString *orderID;

@property (nonatomic , copy) NSString *openId;


@end

@implementation ODCenterYuYueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
   
    self.isComputer = YES;
    self.isTouYing = YES;
    self.isYinXiang = YES;
    self.isMai = YES;
    
    [self navigationInit];
    [self createTableView];
    
    
    self.openId = [ODUserInformation getData].openID;
    
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
   
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

-(void)viewWillDisappear:(BOOL)animated
{
   
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}


#pragma mark - 初始化
-(void)navigationInit
{
     self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
   
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 中心活动label
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"场地预约" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
    // 返回button

    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:confirmButton];
    

    
}


- (void)createTableView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
     self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
      self.tableView.tableHeaderView = self.yuYueView;
    [self.view addSubview:self.tableView];
    
    
}

//创建警告框
-(void)createUIAlertControllerWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 懒加载
- (CenterYuYueView *)yuYueView
{
    if (_yuYueView == nil) {
        self.yuYueView = [CenterYuYueView getView];
       
        
        if (iPhone4_4S) {
               self.yuYueView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 100);
        }else if (iPhone5_5s)
        {
             self.yuYueView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 50);
        }else if (iPhone6_6s) {
            
            self.yuYueView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 70);
        }else {
            self.yuYueView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        }
            
        
     
        
         self.yuYueView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
        
        
        self.yuYueView.computerButton.layer.masksToBounds = YES;
        self.yuYueView.computerButton.layer.cornerRadius = 2;
        self.yuYueView.computerButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.computerButton.layer.borderWidth = 1;
        [self.yuYueView.computerButton addTarget:self action:@selector(computerAction:) forControlEvents:UIControlEventTouchUpInside];
    
        
        

        self.yuYueView.touYingButton.layer.masksToBounds = YES;
        self.yuYueView.touYingButton.layer.cornerRadius = 2;
        self.yuYueView.touYingButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.touYingButton.layer.borderWidth = 1;
        [self.yuYueView.touYingButton addTarget:self action:@selector(touYingAction:) forControlEvents:UIControlEventTouchUpInside];


        self.yuYueView.yinXiangButton.layer.masksToBounds = YES;
        self.yuYueView.yinXiangButton.layer.cornerRadius = 2;
        self.yuYueView.yinXiangButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.yinXiangButton.layer.borderWidth = 1;
        [self.yuYueView.yinXiangButton addTarget:self action:@selector(yinXiangAction:) forControlEvents:UIControlEventTouchUpInside];

        self.yuYueView.maiButton.layer.masksToBounds = YES;
        self.yuYueView.maiButton.layer.cornerRadius = 2;
        self.yuYueView.maiButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.maiButton.layer.borderWidth = 1;
        [self.yuYueView.maiButton addTarget:self action:@selector(maiAction:) forControlEvents:UIControlEventTouchUpInside];

        
        self.yuYueView.sheBeiLabel.layer.masksToBounds = YES;
        self.yuYueView.sheBeiLabel.layer.cornerRadius = 5;
        self.yuYueView.sheBeiLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.sheBeiLabel.layer.borderWidth = 1;

        
        self.yuYueView.pursoseTextView.layer.masksToBounds = YES;
        self.yuYueView.pursoseTextView.layer.cornerRadius = 5;
        self.yuYueView.pursoseTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.pursoseTextView.layer.borderWidth = 1;


        self.yuYueView.contentTextView.layer.masksToBounds = YES;
        self.yuYueView.contentTextView.layer.cornerRadius = 5;
        self.yuYueView.contentTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.contentTextView.layer.borderWidth = 1;

        
        self.yuYueView.peopleNumberTextField.layer.masksToBounds = YES;
        self.yuYueView.peopleNumberTextField.layer.cornerRadius = 5;
        self.yuYueView.peopleNumberTextField.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.peopleNumberTextField.layer.borderWidth = 1;
     
        
        self.yuYueView.phoneLabel.layer.masksToBounds = YES;
        self.yuYueView.phoneLabel.layer.cornerRadius = 5;
        self.yuYueView.phoneLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.phoneLabel.layer.borderWidth = 1;



        self.yuYueView.yuYueButton.layer.masksToBounds = YES;
        self.yuYueView.yuYueButton.layer.cornerRadius = 5;
        self.yuYueView.yuYueButton.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.yuYueButton.layer.borderWidth = 1;
        self.yuYueView.yuYueButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
       
    [self.yuYueView.yuYueButton setTitleColor:[UIColor colorWithHexString:@"#49494b" alpha:1]
 forState:UIControlStateNormal];
        [self.yuYueView.yuYueButton addTarget:self action:@selector(yuYueAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        self.yuYueView.beginText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.endText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.sheBeiText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.purposeText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.contentText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.peopleNumberText.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.yuYueView.btimeText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.eTimeText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.computerText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.touyingText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.yinxiangText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.yuYueText.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.yuYueView.centerText.tintColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        
        
        self.yuYueView.centerText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 5);
        self.yuYueView.centerText.layer.masksToBounds = YES;
        self.yuYueView.centerText.layer.cornerRadius = 5;
        self.yuYueView.centerText.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.centerText.layer.borderWidth = 1;
        self.yuYueView.centerText.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        UIImageView *lImage = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 30, 5, 15, 15) imageName:@"场地预约icon2@3x" tag:0];
        
        [ self.yuYueView.centerText addSubview:lImage];

        
        [self.yuYueView.centerText addTarget:self action:@selector(choseCenter:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.yuYueView.centerText  setTitle:self.centerName forState:UIControlStateNormal];
        
        
        
        [self.yuYueView.phoneText setTitle:self.phoneNumber forState:UIControlStateNormal];
        
        [self.yuYueView.phoneText setTitleColor:[UIColor colorWithHexString:@"#004ed9" alpha:1]
                                         forState:UIControlStateNormal];
      
        [self.yuYueView.phoneText addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.yuYueView.pursoseTextView.textColor = [UIColor lightGrayColor];//设置提示内容颜色
        self.yuYueView.pursoseTextView.text = NSLocalizedString(@"输入活动目的", nil);//提示语
        self.yuYueView.pursoseTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
        self.yuYueView.pursoseTextView.delegate=self;
        self.yuYueView.pursoseTextView.tag = 111;
        self.yuYueView.pursoseTextView.scrollEnabled = NO;
        
        self.yuYueView.contentTextView.textColor = [UIColor lightGrayColor];//设置提示内容颜色
        self.yuYueView.contentTextView.text = NSLocalizedString(@"输入活动内容", nil);//提示语
        self.yuYueView.contentTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
        self.yuYueView.contentTextView.delegate=self;
        self.yuYueView.contentTextView.tag = 222;
        self.yuYueView.contentTextView.scrollEnabled = NO;
        
        
        
        if (iPhone6_6s) {
            
            
            self.yuYueView.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
            self.yuYueView.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
            
            
              UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width, 6, 15, 15) imageName:@"downjiantou" tag:0];
              [ self.yuYueView.btimeText addSubview:image];
            
            
              UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width, 6, 15, 15) imageName:@"downjiantou" tag:0];
            [ self.yuYueView.eTimeText addSubview:images];

            
            
            
        } else if (iPhone4_4S || iPhone5_5s)
        {
            
            self.yuYueView.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
            self.yuYueView.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 8);
            
            
            UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width - 25, 6, 15, 15) imageName:@"downjiantou" tag:0];
            [ self.yuYueView.btimeText addSubview:image];
            
            
            
            UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width - 25, 6, 15, 15) imageName:@"downjiantou" tag:0];
            [ self.yuYueView.eTimeText addSubview:images];

            
        }
        else
        {
            
            self.yuYueView.btimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 9);
            self.yuYueView.eTimeText.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, (kScreenSize.width - 120) / 9);
            
            
            UIImageView *image = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width + 20, 6, 15, 15) imageName:@"downjiantou" tag:0];
            [ self.yuYueView.btimeText addSubview:image];
            
            
            
            UIImageView *images = [ODClassMethod creatImageViewWithFrame:CGRectMake(self.yuYueView.btimeText.frame.size.width + 20, 6, 15, 15) imageName:@"downjiantou" tag:0];
            [ self.yuYueView.eTimeText addSubview:images];

            
            
        }
        
      
        
        
        self.yuYueView.btimeText.layer.masksToBounds = YES;
        self.yuYueView.btimeText.layer.cornerRadius = 5;
        self.yuYueView.btimeText.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.yuYueView.btimeText.layer.borderWidth = 1;
     
        
        
        [self.yuYueView.btimeText addTarget:self action:@selector(choseBeginTime:) forControlEvents:UIControlEventTouchUpInside];
        self.yuYueView.btimeText.tag = 111;
        
        [self.yuYueView.eTimeText addTarget:self action:@selector(choseBeginTime:) forControlEvents:UIControlEventTouchUpInside];
        self.yuYueView.eTimeText.tag = 222;
        
        
        
    }
    return _yuYueView;
}


- (void)yuYueAction:(UIButton *)sender
{
    
    
    [self getOrderId];
    
    
    
}


#pragma mark - 请求数据
- (void)getOrderId
{
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    
   self.beginTime = self.yuYueView.btimeText.titleLabel.text ;
    self.beginTime = [self.beginTime stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    self.beginTime = [self.beginTime stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    self.beginTime = [self.beginTime stringByReplacingOccurrencesOfString:@"日" withString:@""];
    self.beginTime = [self.beginTime stringByAppendingString:@":00"];
    
    
   self.endTime = self.yuYueView.eTimeText.titleLabel.text ;
    self.endTime = [self.endTime stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    self.endTime = [self.endTime stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    self.endTime = [self.endTime stringByReplacingOccurrencesOfString:@"日" withString:@""];
    self.endTime = [self.endTime  stringByAppendingString:@":00"];
    
  
    
    NSDictionary *parameter = @{@"start_datetime":self.beginTime , @" end_datetime":self.endTime , @"store_id":self.storeId , @"open_id":self.openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/create/order";
    
    
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            NSMutableDictionary *dic = responseObject[@"result"];
            
            self.orderID = [NSString stringWithFormat:@"%@" , dic[@"order_id"]];
            
            
            [self saveData];
            
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            
            [self createUIAlertControllerWithTitle:responseObject[@"message"]];
            
            
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];

    
    
}

- (void)saveData
{
    self.managers = [AFHTTPRequestOperationManager manager];
    
    NSString *computerY = @"";
    NSString *touYingY = @"";
    NSString *yinXingY = @"";
    NSString *maiY = @"";
    if (!self.isComputer) {
        computerY = @"1";
    }
    if (!self.isTouYing) {
        touYingY = @"2";
    }
    if (!self.isYinXiang) {
        yinXingY = @"3";
    }
    if (!self.isMai) {
        maiY = @"4";
    }
    
    NSString *equipment = [NSString stringWithFormat:@"%@,%@,%@,%@" , computerY , touYingY , yinXingY , maiY];
    
    
    
    NSDictionary *parameter = @{@"start_datetime":self.beginTime , @" end_datetime":self.endTime , @"store_id":self.storeId , @"order_id":self.orderID ,@"purpose":self.yuYueView.pursoseTextView.text ,@"content":self.yuYueView.contentTextView.text ,@"people_num":self.yuYueView.peopleNumberTextField.text ,@"remark":@"无" ,@"devices":equipment ,@"open_id":self.openId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/confirm/order";
    
    
    [self.managers GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
       
            [self createUIAlertControllerWithTitle:@"预约成功"];

            
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]){
            
            
            
            [self createUIAlertControllerWithTitle:responseObject[@"message"]];
            
            
            
        }
        
             
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];

}

#pragma mark - 点击事件

-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)choseBeginTime:(UIButton *)sender
{
    self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 150, kScreenSize.width, 150)];
    self.picker.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
 
    self.picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    self.picker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    
    [self.picker setMinimumDate:[NSDate date]];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
     self.cancelButton.frame = CGRectMake(0, kScreenSize.height - 180, kScreenSize.width / 2, 30);
    [ self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
     self.cancelButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [ self.cancelButton addTarget:self action:@selector(quXiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
   self.queDingButton = [UIButton buttonWithType:UIButtonTypeSystem];
     self.queDingButton.frame = CGRectMake(kScreenSize.width / 2, kScreenSize.height - 180, kScreenSize.width / 2, 30);
    [self.queDingButton setTitle:@"确定" forState:UIControlStateNormal];
    self.queDingButton.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.queDingButton addTarget:self action:@selector(queDingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: self.queDingButton];
    [self.view addSubview: self.cancelButton];
    [self.view addSubview:self.picker];
    
    
    if (sender.tag == 111) {
        self.isBeginTime = YES;
        self.yuYueView.btimeText.userInteractionEnabled = NO;
        self.yuYueView.eTimeText.userInteractionEnabled = NO;
    }else if (sender.tag == 222)
    {
        self.isBeginTime = NO;
        self.yuYueView.btimeText.userInteractionEnabled = NO;
        self.yuYueView.eTimeText.userInteractionEnabled = NO;
        self.yuYueView.btimeText.userInteractionEnabled = NO;
    }
    

}


- (void)quXiaoAction:(UIButton *)sender
{
    [self.picker removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.queDingButton removeFromSuperview];
    
    
    if ( !self.yuYueView.eTimeText.userInteractionEnabled) {
        self.yuYueView.btimeText.userInteractionEnabled = YES;
        self.yuYueView.eTimeText.userInteractionEnabled = YES;
    }else {
        
        self.yuYueView.btimeText.userInteractionEnabled = YES;
        self.yuYueView.eTimeText.userInteractionEnabled = YES;

    }
    
    
    
}


- (void)queDingAction:(UIButton *)sender
{
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [self.picker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    
    if (self.isBeginTime) {
        [self.yuYueView.btimeText setTitle:destDateString forState:UIControlStateNormal];
        
        if (iPhone4_4S || iPhone5_5s) {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:10];
          
            
        }else if (iPhone6_6s) {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:13];
          
        }else {
            self.yuYueView.btimeText.titleLabel.font = [UIFont systemFontOfSize:15];
        
            
        }

        
        

    }else {
         [self.yuYueView.eTimeText setTitle:destDateString forState:UIControlStateNormal];
        
        
        if (iPhone4_4S || iPhone5_5s) {
                     self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:10];
            
        }else if (iPhone6_6s) {
           
            self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:13];
        }else {
          
            self.yuYueView.eTimeText.titleLabel.font = [UIFont systemFontOfSize:15];
            
        }

        
    }
    
    
    if (!self.yuYueView.eTimeText.userInteractionEnabled) {
        
        self.yuYueView.btimeText.userInteractionEnabled = YES;
        self.yuYueView.eTimeText.userInteractionEnabled = YES;
        
    }else {
        
        self.yuYueView.btimeText.userInteractionEnabled = YES;
        self.yuYueView.eTimeText.userInteractionEnabled = YES;
        
    }

    
    [self.picker removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.queDingButton removeFromSuperview];
}



- (void)choseCenter:(UIButton *)sender
{
    ODChoseCenterController *vc = [[ODChoseCenterController alloc] init];
    
    
    vc.storeCenterNameBlock = ^(NSString *name , NSString *storeId , NSInteger storeNumber){
        
        [self.yuYueView.centerText setTitle:name forState:UIControlStateNormal];
        self.storeId = storeId;
    };
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)phoneAction:(UITapGestureRecognizer *)sender
{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.yuYueView.phoneText.titleLabel.text];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
    
    
}



- (void)computerAction:(UIButton *)sender
{
    
    if (self.isComputer) {
        [self.yuYueView.computerButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.computerButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

    }
    self.isComputer = !self.isComputer;
    
    
}

- (void)touYingAction:(UIButton *)sender
{
    
    if (self.isTouYing) {
        [self.yuYueView.touYingButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.touYingButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    self.isTouYing = !self.isTouYing;
    
    
}

- (void)yinXiangAction:(UIButton *)sender
{
    
    if (self.isYinXiang) {
        [self.yuYueView.yinXiangButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.yinXiangButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    self.isYinXiang = !self.isYinXiang;
    
    
}

- (void)maiAction:(UIButton *)sender
{
    
    if (self.isMai) {
        [self.yuYueView.maiButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else{
        [self.yuYueView.maiButton setImage:[UIImage imageNamed:@"."] forState:UIControlStateNormal];
        
    }
    self.isMai = !self.isMai;
    
    
}


#pragma mark - textViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
    {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""] && textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
    {
        textView.text=@"";//置空
        textView.textColor=[UIColor blackColor];
    }
    
    if ([text isEqualToString:@"\n"])//回车事件
    {
        if ([textView.text isEqualToString:@""])//如果直接回车，显示提示内容
        {
            textView.textColor=[UIColor lightGrayColor];
            if (textView.tag == 111) {
                textView.text=NSLocalizedString(@"输入活动目的", nil);
                
            }else{
                textView.text=NSLocalizedString(@"输入活动内容", nil);
            }
            
        }
        [textView resignFirstResponder];//隐藏键盘
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor = [UIColor lightGrayColor];
        if (textView.tag == 111) {
            textView.text=NSLocalizedString(@"输入活动目的", nil);
            
        }else{
            textView.text=NSLocalizedString(@"输入活动内容", nil);
        }
    }
    
    
    
    
    
}

#pragma mark - textfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

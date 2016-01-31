//
//  ODAddAddressController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODAddAddressController.h"
#import "ODAddAddressView.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODAddAddressController ()


@property (nonatomic , strong) UILabel *centerNameLabe;
@property (nonatomic , strong) ODAddAddressView *addAddressView;
@property (nonatomic , assign) BOOL isdefault;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , copy) NSString *is_default;
@end

@implementation ODAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isdefault = YES;
    self.is_default = @"0";
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    
    
  
    
    [self navigationInit];
    [self createView];
    
    
    
}

#pragma mark - 初始化

-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = @"新增地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(fanhui:) color:nil highColor:nil title:@"返回"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(saveAction:) color:nil highColor:nil title:@"保存"];


    
    
}

- (void)createView
{
    
    self.addAddressView = [ODAddAddressView getView];
    self.addAddressView.frame = CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64);
    self.addAddressView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.view addSubview:self.addAddressView];
    
    
    
    [self.addAddressView.defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)saveAction:(UIButton *)sender
{
    [self saveAddress];
}

- (void)saveAddress{
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"tel":self.addAddressView.phoneTextField.text , @"address":self.addAddressView.addressTextField.text,@"name":self.addAddressView.nameTextField.text , @"is_default":self.is_default, @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kSaveAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"保存成功"];
           
           }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
        
        
        
        
        
        
    }];

    
    
    
}



- (void)defaultAction:(UIButton *)sender
{
    
    if (self.isdefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
       self.is_default = @"1";
    }else{
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        self.is_default = @"0";
    }
    self.isdefault = !self.isdefault;

    
}

- (void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

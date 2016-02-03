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
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *editeManager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *deleteManager;
@property (nonatomic , copy) NSString *open_id;
@property (nonatomic , copy) NSString *is_default;
@end

@implementation ODAddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.is_default = @"0";
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    
  
    [self navigationInit];
    [self createView];
}

#pragma mark - 初始化

-(void)navigationInit
{
    self.navigationItem.title = self.typeTitle;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(saveAction:) color:nil highColor:nil title:@"保存"];
}

- (void)createView
{
    
    self.addAddressView = [ODAddAddressView getView];
    self.addAddressView.frame = CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight);
    self.addAddressView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.view addSubview:self.addAddressView];
    
    
    
    [self.addAddressView.defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.isDefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.is_default = @"1";

    }else {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        self.is_default = @"0";

    }
  
    
    
    if (!self.isAdd) {
        self.addAddressView.nameTextField.text = self.addressModel.name;
        self.addAddressView.addressTextField.text = self.addressModel.address;
        self.addAddressView.phoneTextField.text = self.addressModel.tel;
    };
    
    
}

- (void)saveAction:(UIButton *)sender
{
    
    
   
    
    if (self.isAdd) {
        
        
        if([self.addAddressView.nameTextField.text isEqualToString:@"请输入姓名"] ||[self.addAddressView.nameTextField.text isEqualToString:@""] )
        {
            
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入姓名"];
            
        }else if ([self.addAddressView.phoneTextField.text isEqualToString:@"请输入手机号"] || self.addAddressView.phoneTextField.text.length < 8 || self.addAddressView.phoneTextField.text.length > 11)
        {
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入正确手机号"];
            
        }else if ([self.addAddressView.addressTextField.text isEqualToString:@"请输入联系地址"] || [self.addAddressView.addressTextField.text isEqualToString:@""])
        {
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入联系地址"];
            
            
        }else{
              [self saveAddress];
        }

        
        
    }else{
        
        if([self.addAddressView.nameTextField.text isEqualToString:@"请输入姓名"] ||[self.addAddressView.nameTextField.text isEqualToString:@""] )
        {
            
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入姓名"];
            
        }else if ([self.addAddressView.phoneTextField.text isEqualToString:@"请输入手机号"] || self.addAddressView.phoneTextField.text.length < 8 || self.addAddressView.phoneTextField.text.length > 11)
        {
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入正确手机号"];
            
        }else if ([self.addAddressView.addressTextField.text isEqualToString:@"请输入联系地址"] || [self.addAddressView.addressTextField.text isEqualToString:@""])
        {
            [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入联系地址"];
            
            
        }else{
            [self editeAddress];
        }
        
    }
}

- (void)editeAddress{
    
    
    self.editeManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_address_id":self.addressId, @"tel":self.addAddressView.phoneTextField.text , @"address":self.addAddressView.addressTextField.text,@"name":self.addAddressView.nameTextField.text , @"is_default":self.is_default, @"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.editeManager GET:kSaveAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
         
            [weakSelf deleteAddress];
            
            
        }else if ([responseObject[@"status"] isEqualToString:@"error"]) {
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    
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
           
           
        }else if ([responseObject[@"status"] isEqualToString:@"error"]) {
            
      [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
        
        
        
    }];

    
    
    
}

- (void)deleteAddress
{
    self.deleteManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_address_id":self.addressId ,@"open_id":self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
      __weak typeof (self)weakSelf = self;
    [self.deleteManager GET:kDeleteAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
         
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"修改成功"];
           
        }
        
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


- (void)defaultAction:(UIButton *)sender
{
    
    if (!self.isDefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
       self.is_default = @"1";
    }else{
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        self.is_default = @"0";
    }
    self.isDefault = !self.isDefault;

    
}
@end
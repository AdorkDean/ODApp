//
//  ODAddAddressController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODAddAddressController.h"
#import "ODAddAddressView.h"

@interface ODAddAddressController () <UITextViewDelegate>


@property(nonatomic, strong) UILabel *centerNameLabe;
@property(nonatomic, strong) ODAddAddressView *addAddressView;

@property(nonatomic, copy) NSString *open_id;
@property(nonatomic, copy) NSString *is_default;
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

- (void)navigationInit {
    self.navigationItem.title = self.typeTitle;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(saveAction:) color:nil highColor:nil title:@"保存"];
}

- (void)createView {

    self.addAddressView = [ODAddAddressView getView];
    self.addAddressView.frame = CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight);
    self.addAddressView.backgroundColor = [UIColor lineColor];
    [self.view addSubview:self.addAddressView];


    [self.addAddressView.defaultButton addTarget:self action:@selector(defaultAction:) forControlEvents:UIControlEventTouchUpInside];


    if (self.isDefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.is_default = @"1";

    } else {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        self.is_default = @"0";

    }

    self.addAddressView.addressTextView.delegate = self;

    if (!self.isAdd) {
        self.addAddressView.nameTextField.text = self.addressModel.name;
        self.addAddressView.addressTextView.text = self.addressModel.address;
        self.addAddressView.phoneTextField.text = self.addressModel.tel;
    } else {
        self.addAddressView.addressTextView.text = @"请输入联系地址";
        self.addAddressView.addressTextView.textColor = [UIColor colorGreyColor];
        self.addAddressView.phoneTextField.text = [ODUserInformation sharedODUserInformation].mobile;

    };


}


#pragma mark - textViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.addAddressView.addressTextView) {
        if ([textView.text isEqualToString:@"请输入联系地址"]) {
            self.addAddressView.addressTextView.text = @"";
            self.addAddressView.addressTextView.textColor = [UIColor blackColor];
        }
        else {;
        }

    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {


    if (textView == self.addAddressView.addressTextView) {
        if ([textView.text isEqualToString:@""]) {
            textView.textColor = [UIColor colorGreyColor];
            textView.text = @"请输入联系地址";

        }
    }


}


- (void)saveAction:(UIButton *)sender {

    [self.addAddressView.nameTextField resignFirstResponder];
    [self.addAddressView.addressTextView resignFirstResponder];
    [self.addAddressView.phoneTextField resignFirstResponder];


    if (self.isAdd) {


        if ([self.addAddressView.nameTextField.text isEqualToString:@"请输入姓名"] || [self.addAddressView.nameTextField.text isEqualToString:@""]) {

            [ODProgressHUD showInfoWithStatus:@"请输入姓名"];

        } else if ([self.addAddressView.phoneTextField.text isEqualToString:@"请输入手机号"] || [self.addAddressView.phoneTextField.text isEqualToString:@""]) {

            [ODProgressHUD showInfoWithStatus:@"请输入手机号"];

        } else if ([self.addAddressView.addressTextView.text isEqualToString:@"请输入联系地址"] || [self.addAddressView.addressTextView.text isEqualToString:@""]) {

            [ODProgressHUD showInfoWithStatus:@"请输入联系地址"];


        } else {
            [self saveAddress];
        }


    } else {

        if ([self.addAddressView.nameTextField.text isEqualToString:@"请输入姓名"] || [self.addAddressView.nameTextField.text isEqualToString:@""]) {

            [ODProgressHUD showInfoWithStatus:@"请输入姓名"];


        } else if ([self.addAddressView.phoneTextField.text isEqualToString:@"请输入手机号"] || [self.addAddressView.phoneTextField.text isEqualToString:@""]) {
            [ODProgressHUD showInfoWithStatus:@"请输入正确手机号"];

        } else if ([self.addAddressView.addressTextView.text isEqualToString:@"请输入联系地址"] || [self.addAddressView.addressTextView.text isEqualToString:@""]) {
            [ODProgressHUD showInfoWithStatus:@"请输入联系地址"];


        } else {
            [self editeAddress];
        }

    }
}

- (void)editeAddress {
    NSDictionary *parameters = @{
                                 @"user_address_id" : self.addressId,
                                 @"tel" : self.addAddressView.phoneTextField.text,
                                 @"address" : self.addAddressView.addressTextView.text,
                                 @"name" : self.addAddressView.nameTextField.text,
                                 @"is_default" : self.is_default,
                                 @"open_id" : self.open_id
                                 };
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressAdd parameters:parameters modelClass:[NSObject class] success:^(id model) {
        [weakSelf deleteAddress];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)saveAddress {
    NSDictionary *parameters = @{
                                 @"tel" : self.addAddressView.phoneTextField.text,
                                 @"address" : self.addAddressView.addressTextView.text,
                                 @"name" : self.addAddressView.nameTextField.text,
                                 @"is_default" : self.is_default,
                                 @"open_id" : self.open_id
                                 };

    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressAdd parameters:parameters modelClass:[NSObject class] success:^(id model) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [ODProgressHUD showInfoWithStatus:@"保存成功"];
        
    } failure:^(NSError *error) {
        
        
    }];
    

}

- (void)deleteAddress {
    NSDictionary *parameters = @{@"user_address_id" : self.addressId, @"open_id" : self.open_id};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserAddressDel parameters:parameters modelClass:[NSObject class] success:^(id model) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [ODProgressHUD showInfoWithStatus:@"修改成功"];
        
    } failure:^(NSError *error) {
        
        
    }];

}


- (void)defaultAction:(UIButton *)sender {

    if (!self.isDefault) {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_Selected"] forState:UIControlStateNormal];
        self.is_default = @"1";
    } else {
        [self.addAddressView.defaultButton setImage:[UIImage imageNamed:@"icon_Default address_default"] forState:UIControlStateNormal];
        self.is_default = @"0";
    }
    self.isDefault = !self.isDefault;


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end

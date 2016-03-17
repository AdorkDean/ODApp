//
//  ODUserNickNameController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODUserNickNameController.h"
#import "Masonry.h"
#import "ODUserModel.h"


@interface ODUserNickNameController ()

@property (nonatomic , strong) UITextField *textField;

@end


@implementation ODUserNickNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self textFieldInit];
}


#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationItem.title = @"修改昵称";
    // 注册button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(save:) color:nil highColor:nil title:@"保存"];
}


- (void)textFieldInit
{
    UIView *wrap = [[UIView alloc] init];
    [self.view addSubview:wrap];
    [wrap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    wrap.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[UITextField alloc] init];
    [wrap addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wrap).with.offset(0);
        make.bottom.equalTo(wrap).with.offset(0);
        make.left.equalTo(wrap).with.offset(10);
        make.right.equalTo(wrap).with.offset(10);
    }];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"请输入昵称";
    self.textField.text = self.nickName;
    self.textField.textColor = [UIColor blackColor];
    self.textField.font = [UIFont systemFontOfSize:14];
}


#pragma mark - 点击事件
- (void)save:(UIButton *)sender
{
    [self.textField resignFirstResponder];
    if ([self.textField.text isEqualToString:@""]) {
        [ODProgressHUD showToast:self.view msg:@"请输入昵称"];
        return;
    }
    __weakSelf
    NSDictionary *parameters = @{@"nick":self.textField.text};
    
    [ODHttpTool getWithURL:ODUrlUserChange parameters:parameters modelClass:[ODUserModel class] success:^(id model) {
        [ODProgressHUD showToast:self.view msg:@"修改成功"];
        ODUserModel *user = [model result];
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
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

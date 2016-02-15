//
//  ODUserNickNameController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserNickNameController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODUserNickNameController ()<UITextFieldDelegate>

@property (nonatomic , strong) UITextField *textField;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;
@end

@implementation ODUserNickNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
    [self creatTextField];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationItem.title = @"修改昵称";
    // 注册button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(registered:) color:nil highColor:nil title:@"保存"];
}


- (void)creatTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 30)];
    self.textField.placeholder = @"请输入昵称";
    [self.textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 5;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.text = self.nickName;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
}

#pragma mark - 点击事件
- (void)registered:(UIButton *)sender
{

    NSString *openID = [ODUserInformation sharedODUserInformation].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"nick":self.textField.text , @"open_id":openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
  
    __weakSelf
    [self.manager GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(weakSelf.textField.text);
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }

        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
    }
    
    return YES;
}

@end

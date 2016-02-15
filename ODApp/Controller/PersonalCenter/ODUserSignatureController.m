//
//  ODUserSignatureController.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserSignatureController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"

@interface ODUserSignatureController ()<UITextFieldDelegate>

@property (nonatomic , strong) UITextField *textField;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation ODUserSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTextField];
    [self navigationInit];
}

- (void)navigationInit
{
    self.navigationItem.title = @"修改签名";
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
    self.textField.text = self.signature;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - 点击事件
-(void)fanhui:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)registered:(UIButton *)sender
{
     NSString *openID = [ODUserInformation sharedODUserInformation].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_sign":self.textField.text , @"open_id":openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    __weakSelf
    
  
    [self.manager GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(self.textField.text);
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



@end

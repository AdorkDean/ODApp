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

@property (nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITextField *textField;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;


@end

@implementation ODUserSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self navigationInit];
    [self creatTextField];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 登陆label
    UILabel *centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"修改签名" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:centerNameLabe];
    
    
    // 注册button
    
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 60, 16,50, 44) target:self sel:@selector(registered:) tag:0 image:nil title:@"保存" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    
    // 返回button
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    [self.headView addSubview:backButton];
    
    
    [self.headView addSubview:confirmButton];
    
    
    
    
}


- (void)creatTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(4, 68, kScreenSize.width - 8, 30)];
    
    
    [self.textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 5;
    self.textField.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.textField.layer.borderWidth = 1;
    self.textField.delegate = self;

    
    
    if ([self.signature isEqualToString:@"未设置签名"]) {
          self.textField.placeholder = @"请设置签名";
    }else
    {
          self.textField.text = self.signature;
    }
  
    
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


#pragma mark - 点击事件
-(void)fanhui:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)registered:(UIButton *)sender
{
    NSString *openID = [ODUserInformation getData].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_sign":self.textField.text , @"open_id":openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/user/change";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.getTextBlock) {
                if (self.getTextBlock) {
                    self.getTextBlock(self.textField.text);
                }
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
            
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alter show];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}



@end

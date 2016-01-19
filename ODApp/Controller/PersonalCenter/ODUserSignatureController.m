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

@interface ODUserSignatureController ()<UITextViewDelegate>

@property (nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITextView *textView;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;


@end

@implementation ODUserSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
     [self navigationInit];
     [self creatTextView];
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
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 60, 28,50, 20) target:self sel:@selector(registered:) tag:0 image:nil title:@"保存" font:17];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    
    // 返回button
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-10, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    
    [self.headView addSubview:confirmButton];
    
    
    
    
}

- (void)creatTextView
{
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(4, 68, kScreenSize.width - 8, 100)];
    
    
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.textColor = [UIColor lightGrayColor];//设置提示内容颜色
    self.textView.scrollEnabled = NO;

    
    
    if ([self.signature isEqualToString:@""]) {
        self.textView.text = NSLocalizedString(@"请输入个人签名", nil);//提示语
        self.textView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
        self.textView.delegate=self;

    }else{
        self.textView.text = self.signature;
    }
  
    
  
    
    [self.view addSubview:self.textView];
    
    
    
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
          
            textView.text=NSLocalizedString(@"请输入个人签名", nil);
                
                
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
       
        textView.text=NSLocalizedString(@"请输入个人签名", nil);
            
        
    
    }
    
       
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
     NSString *openID = [ODUserInformation getData].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"user_sign":self.textView.text , @"open_id":openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/change";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.getTextBlock) {
                if (self.getTextBlock) {
                    self.getTextBlock(self.textView.text);
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


@end

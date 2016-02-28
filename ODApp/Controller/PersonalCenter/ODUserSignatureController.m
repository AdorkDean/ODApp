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

@property (nonatomic , strong) UITextView *textView;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation ODUserSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTextView];
    [self navigationInit];
}

- (void)navigationInit
{
    self.navigationItem.title = @"修改签名";
    // 注册button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(registered:) color:nil highColor:nil title:@"保存"];
}
- (void)creatTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 30)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.textView.layer.borderWidth = 1;
    
    if ([self.signature isEqualToString:@"未设置签名"] || [self.signature isEqualToString:@"请输入签名"]) {
        self.textView.text = @"请输入签名";
        self.textView.textColor = [UIColor lightGrayColor];

    }else {
        self.textView.text = self.signature;
    }
    
    self.textView.font = [UIFont systemFontOfSize:14];
    
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
}


#pragma mark - UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入签名"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}




- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString *replyTitleText = @"";
    if (textView.text.length > 20){
        textView.text = [textView.text substringToIndex:20];
    }else{
        replyTitleText = textView.text;
    }
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"请输入签名"] || [self.textView.text isEqualToString:@""]) {
          self.textView.text = @"请输入签名";
          self.textView.textColor = [UIColor lightGrayColor];
    }
    
  
    
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
    
    NSDictionary *parameters = @{@"user_sign":self.textView.text , @"open_id":openID};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    __weakSelf
    
  
    [self.manager GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.getTextBlock) {
                if (weakSelf.getTextBlock) {
                    weakSelf.getTextBlock(self.textView.text);
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];

            }
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                      
            [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
            
        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}



@end

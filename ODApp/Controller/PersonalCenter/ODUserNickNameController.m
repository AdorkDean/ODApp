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

@interface ODUserNickNameController ()<UITextViewDelegate>

@property (nonatomic , strong) UITextView *textView;
@property(nonatomic,strong) AFHTTPRequestOperationManager *manager;
@end

@implementation ODUserNickNameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationInit];
     [self creatTextView];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationItem.title = @"修改昵称";
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
    
    if ([self.nickName isEqualToString:@"未设置昵称"] || [self.nickName isEqualToString:@"请输入昵称"]) {
        self.textView.text = @"请输入昵称";
        self.textView.textColor = [UIColor lightGrayColor];
        
    }else {
        self.textView.text = self.nickName;
    }
    
    self.textView.font = [UIFont systemFontOfSize:14];
    
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入昵称"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}




- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString *replyTitleText = @"";
    if (textView.text.length > 10){
        textView.text = [textView.text substringToIndex:10];
    }else{
        replyTitleText = textView.text;
    }
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"请输入昵称"] || [self.textView.text isEqualToString:@""]) {
        self.textView.text = @"请输入昵称";
        self.textView.textColor = [UIColor lightGrayColor];
    }
    
    
    
}


#pragma mark - 点击事件
- (void)registered:(UIButton *)sender
{

    
    if([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:@"请输入昵称"])
    {
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入昵称"];

    }else {
        NSString *openID = [ODUserInformation sharedODUserInformation].openID;
        
        self.manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameters = @{@"nick":self.textView.text , @"open_id":openID};
        NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
        
        
        __weakSelf
        [self.manager GET:kChangeUserInformationUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                if (weakSelf.getTextBlock) {
                    if (weakSelf.getTextBlock) {
                        weakSelf.getTextBlock(weakSelf.textView.text);
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
    
    
    
}


@end

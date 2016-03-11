//
//  ODUserSignatureController.m
//  ODApp
//
//  Created by zhz on 16/1/5.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserSignatureController.h"
#import "Masonry.h"
#import "ODUserModel.h"

@interface ODUserSignatureController ()<UITextViewDelegate>

@property (nonatomic , strong) UITextView *textView;

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
    self.textView = [[UITextView alloc] init];
    [self.view addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@80);
    }];
    self.textView.backgroundColor = [UIColor whiteColor];
    
    if ([self.signature isEqualToString:@"未设置签名"] || [self.signature isEqualToString:@"请输入签名"]) {
        self.textView.text = @"请输入签名";
        self.textView.textColor = [UIColor lightGrayColor];
    } else {
        self.textView.text = self.signature;
    }
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
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


- (void)registered:(UIButton *)sender
{
    
    ODUserModel *user = [[ODUserInformation sharedODUserInformation] getUserCache];
    NSDictionary *parameters = @{@"user_sign":self.textView.text , @"open_id":user.open_id};
    [ODHttpTool getWithURL:ODUrlUserChange parameters:parameters modelClass:[ODUserModel class] success:^(id model)
    {
        [ODProgressHUD showToast:self.view msg:@"修改成功"];
        ODUserModel *user = [model result];
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        
    }];
}



@end

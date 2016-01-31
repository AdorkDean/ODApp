//
//  ODCommunityDetailReplyViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityDetailReplyViewController.h"

@interface ODCommunityDetailReplyViewController ()


@end

@implementation ODCommunityDetailReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.navigationItem.title = @"回复";
    [self createRequest];
    [self createTextView];    
    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    
    //返回按钮
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 16,35, 44) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:confirmButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmButtonClick:(UIButton *)button
{
    if (self.textView.text.length>0) {
        [self joiningTogetherParmeters];
    }else{
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入回复内容"];
    }
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
}


#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{@"bbs_id":self.bbs_id,@"content":self.textView.text,@"parent_id":self.parent_id,@"open_id":[ODUserInformation sharedODUserInformation].openID};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushDataWithUrl:kCommunityBbsReplyUrl parameter:signParameter];
}

#pragma mark - 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    

    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"success"]) {

            if (weakSelf.myBlock) {
                weakSelf.myBlock([NSString stringWithFormat:@"refresh"]);
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationMyTaskRefresh object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"回复成功"];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

#pragma mark - 创建textView
-(void)createTextView
{
    self.textView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 68, kScreenSize.width-8, 140) delegate:self tag:0 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.view addSubview:self.textView];
    
    self.label = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 68, kScreenSize.width-20, 30) text:@"请输入回复TA的内容" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.userInteractionEnabled = NO;
    [self.view addSubview:self.label];
}

#pragma mark - UITextViewDelegate

NSString *titleText1 = @"";
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.textView)
    {
        if (textView.text.length > 500)
        {
            textView.text = titleText1;
        }
        else
        {
            titleText1 = textView.text;
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 500) {
            return NO;
        }
    }

    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
   self.label.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length) {
        self.label.text = @"";
    }else{
        self.label.text = @"请输入回复TA的内容";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

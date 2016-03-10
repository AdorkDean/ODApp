//
//  ODGiveOpinionController.m
//  ODApp
//
//  Created by zhz on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODGiveOpinionController.h"

@interface ODGiveOpinionController ()<UITextViewDelegate>

@property (nonatomic , strong) UITextView *textView;

@end

@implementation ODGiveOpinionController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [super viewDidLoad];
    [self navigationInit];
    [self creatTextView];

    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化方法
-(void)navigationInit
{
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(registered:) color:nil highColor:nil title:@"确认"];
}
- (void)creatTextView
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 150)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#d0d0d0" alpha:1].CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.textView.text = @"请输入您的反馈内容";
    self.textView.textColor = [UIColor lightGrayColor];
        
    
    self.textView.font = [UIFont systemFontOfSize:14];
    
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
}

#pragma mark - UITextView 代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的反馈内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString *replyTitleText = @"";
    if (textView.text.length > 500){
        textView.text = [textView.text substringToIndex:500];
    }else{
        replyTitleText = textView.text;
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"请输入您的反馈内容"] || [self.textView.text isEqualToString:@""]) {
        self.textView.text = @"请输入您的反馈内容";
        self.textView.textColor = [UIColor lightGrayColor];
    }
    
    
    
}


#pragma mark - 事件方法
- (void)registered:(UIButton *)sender
{
    
    [self.textView resignFirstResponder];
    
    if([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:@"请输入您的反馈内容"])
    {
        [ODProgressHUD showInfoWithStatus:@"请输入您的反馈内容"];
        
    }else {
        
        // 拼接参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"content"] = self.textView.text;
        params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
        __weakSelf
        // 发送请求
        [ODHttpTool getWithURL:ODUrlOtherFeedback parameters:params modelClass:[NSObject class] success:^(id model)
         {
             [ODProgressHUD showInfoWithStatus:@"感谢您的反馈"];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         } failure:^(NSError *error) {
             
         }];
    }
}

@end

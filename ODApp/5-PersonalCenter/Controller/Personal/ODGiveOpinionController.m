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
@property (nonatomic , strong) UILabel *placeholdelLabel;

@end

@implementation ODGiveOpinionController

#pragma mark - 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(registered:) color:nil highColor:nil title:@"确认"];
    
    [self creatTextView];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 150)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor colorGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.placeholdelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenSize.width - 20, 20)];
    self.placeholdelLabel.text = @"请输入您的反馈内容";
    self.placeholdelLabel.textColor = [UIColor colorGreyColor];
    self.placeholdelLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.placeholdelLabel];
    
}

#pragma mark - UITextView 代理方法
- (void)textViewDidChange:(UITextView *)textView {
    NSString *replyTitleText = @"";
    if (textView.text.length > 500){
        textView.text = [textView.text substringToIndex:500];
    }else{
        replyTitleText = textView.text;
    }
    
    if (textView.text.length == 0) {
        self.placeholdelLabel.text =  @"请输入您的反馈内容";
    }else{
       self.placeholdelLabel.text = @"";
    }
}

#pragma mark - 事件方法

- (void)registered:(UIButton *)sender {
    [self.textView resignFirstResponder];
    
    if([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:@"请输入您的反馈内容"]) {
        [ODProgressHUD showInfoWithStatus:@"请输入您的反馈内容"];
    }
    else {
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

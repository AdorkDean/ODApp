//
//  ODCommunityDetailReplyViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityDetailReplyViewController.h"

@interface ODCommunityDetailReplyViewController ()

@end

@implementation ODCommunityDetailReplyViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor blackColor] highColor:nil title:@"确认"];
    [self createTextView];
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

#pragma mark - 提交数据
-(void)pushData
{
     NSDictionary *parameter = @{@"bbs_id" : self.bbs_id, @"content" : self.textView.text, @"parent_id" : self.parent_id, @"open_id" : [ODUserInformation sharedODUserInformation].openID};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlBbsReply parameters:parameter modelClass:[NSObject class] success:^(id model) {
        if (weakSelf.myBlock) {
            weakSelf.myBlock(@"refresh");
        }
        [ODProgressHUD showInfoWithStatus:@"回复成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationReplySuccess object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationMyTaskRefresh object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 创建textView
- (void)createTextView {
    self.textView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4 + ODTopY, kScreenSize.width - 8, 140) delegate:self tag:0 font:13 color:@"#ffffff" alpha:1 maskToBounds:YES];
    self.textView.textColor = [UIColor blackColor];
    [self.view addSubview:self.textView];

    self.label = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4 + ODTopY, kScreenSize.width - 20, 30) text:@"请输入回复TA的内容" font:13 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.label.textColor = [UIColor colorGrayColor];
    self.label.userInteractionEnabled = NO;
    [self.view addSubview:self.label];
}

#pragma mark - UITextViewDelegate
NSString *replyTitleText = @"";
NSUInteger maxLength = 250;

- (void)textViewDidChange:(UITextView *)textView {
    if (maxLength < 250) {
        maxLength = 250;
    }
    if (textView.text.length > maxLength) {
        NSString *tmp = [textView.text substringToIndex:maxLength];
        NSData *utf8Data = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        if (utf8Data != nil) {
            textView.text = tmp;
            maxLength = tmp.length;
        } else {
            maxLength = textView.text.length;
        }
    } else {
        replyTitleText = textView.text;
    }

    if (textView.text.length == 0) {
        self.label.text = @"请输入回复TA的内容";
    } else {
        self.label.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length) {
        self.label.text = @"";
    } else {
        self.label.text = @"请输入回复TA的内容";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma mark - action
- (void)confirmButtonClick {
    if (self.textView.text.length > 0) {
        [self pushData];
    } else {
        [ODProgressHUD showInfoWithStatus:@"请输入回复内容"];
    }
}

@end

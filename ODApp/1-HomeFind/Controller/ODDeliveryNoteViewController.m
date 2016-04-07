//
//  ODDeliveryNoteViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDeliveryNoteViewController.h"

@interface ODDeliveryNoteViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *label;

@end

@implementation ODDeliveryNoteViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTextView];
    self.navigationItem.title = @"配送备注";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItemClick) color:nil highColor:nil title:@"确定"];
    
}

#pragma mark - 创建视图
-(void)createTextView{
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(4, 4, kScreenSize.width-8, 140)];
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.view addSubview:self.textView];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenSize.width-20, 20)];
    if (self.noteContent.length != 0) {
        self.textView.text = self.noteContent;
    } else {
        self.label.text = @"请输入备注内容";
    }

    self.label.font = [UIFont systemFontOfSize:13];
    self.label.textColor = [UIColor colorGrayColor];
    self.label.userInteractionEnabled = NO;
    [self.view addSubview:self.label];
}


#pragma mark - UITextViewDelegate
NSString *deliveryNoteText = @"";
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 300) {
        textView.text = [textView.text substringToIndex:300];
    } else {
        deliveryNoteText = textView.text;
    }

    if (self.textView.text.length == 0) {
        self.label.text = @"请输入备注内容";
    } else {
        self.label.text = @"";
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length) {
        self.label.text = @"";
    } else {
        self.label.text = @"请输入备注内容";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}


#pragma mark - UIAction
-(void)rightItemClick{
    if (self.myBlock) {
        self.myBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

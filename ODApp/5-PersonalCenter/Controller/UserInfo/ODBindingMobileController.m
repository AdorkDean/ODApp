//
//  ODBindingMobileController.m
//  ODApp
//
//  Created by zhz on 16/1/6.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBindingMobileController.h"
#import "ODBindingMobileView.h"

@interface ODBindingMobileController ()

/** mobileView */
@property(nonatomic, weak) ODBindingMobileView *bindMobileView;
//定时器
@property(nonatomic, strong) NSTimer *timer;
//当前秒数
@property(nonatomic, assign) NSInteger currentTime;

@property(nonatomic, copy) NSString *openId;

@end

@implementation ODBindingMobileController

#pragma mark - 懒加载
/**
 *  懒加载定时器
 */
- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化MobileView
    [self setupMobileView];
}

#pragma mark - 初始化方法
/**
 *  初始化MobileView
 */
- (void)setupMobileView
{
    // 初始化
    self.navigationItem.title = @"绑定手机";
    self.currentTime = getVerificationCodeTime;
    self.openId = [ODUserInformation sharedODUserInformation].openID;
    
    // 创建MobileView
    ODBindingMobileView *bindMobileView = [ODBindingMobileView getView];
    bindMobileView.frame = CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight);
    
    [bindMobileView.getCodelButton addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bindMobileView.bindingButton addTarget:self action:@selector(bindingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindMobileView];
}
/**
 *  创建警告框
 */
- (void)createUIAlertControllerWithTitle:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 请求数据
- (void)getCodes
{
    __weakSelf
    NSDictionary *parameters = @{
                                 @"mobile" : self.bindMobileView.phoneTextField.text,
                                 @"type" : @"4",
                                 @"open_id" : self.openId
                                 };
    [ODHttpTool getWithURL:ODUrlUserCodeSend parameters:parameters modelClass:[NSObject class] success:^(id model) {
        // 开启定时器
        [weakSelf timer];
    } failure:^(NSError *error) {
    }];
}

- (void)bingdingPhone
{
    __weakSelf
    NSDictionary *parameters = @{
                                 @"mobile" : self.bindMobileView.phoneTextField.text,
                                 @"verify_code" : self.bindMobileView.verificationTextField.text,
                                 @"open_id" : self.openId
                                 };
    [ODHttpTool getWithURL:ODUrlUserBindMoble parameters:parameters modelClass:[NSObject class] success:^(id model)
     {
         if (weakSelf.getTextBlock) {
             weakSelf.getTextBlock(self.bindMobileView.phoneTextField.text);
         }
         [weakSelf.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error) {
     }];
}

#pragma mark - 事件方法
- (void)timerClick {
    self.currentTime--;
    if (self.currentTime == 0) {
        [self.bindMobileView.getCodelButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.bindMobileView.getCodelButton.userInteractionEnabled = YES;
        // 停止定时器
        [self.timer invalidate];
        self.timer = nil;
        
        self.currentTime = getVerificationCodeTime;
    } else {
        [self.bindMobileView.getCodelButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", self.currentTime] forState:UIControlStateNormal];
        self.bindMobileView.getCodelButton.userInteractionEnabled = NO;
    }
}

- (void)getCodeAction:(UIButton *)sender {
    [self getCodes];
}

- (void)bindingAction:(UIButton *)sender {
    [self bingdingPhone];
}

@end

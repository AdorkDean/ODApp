//
//  ODBazaarReleaseTaskViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarReleaseTaskViewController.h"

@interface ODBazaarReleaseTaskViewController ()

@end

@implementation ODBazaarReleaseTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ODColorConversion colorWithHexString:@"#d9d9d9" alpha:1];
    [self navigationInit];
    [self createScrollView];
    [self createTitleTextView];
    [self createTimeLabel];
    [self createTaskDetailTextView];
    [self createTaskRewardLabel];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"新任务" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //取消按钮
    UIButton *cancelButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28,35, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:17];
    [cancelButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:cancelButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 28,35, 20) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:17];
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:confirmButton];

}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmButtonClick:(UIButton *)button
{
    
}

#pragma mark - 创建scrollView
-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, kScreenSize.width, kScreenSize.height - 64)];
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
}

#pragma mark - 创建titleTextView
-(void)createTitleTextView
{
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 140) delegate:self tag:10 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4, kScreenSize.width - 20, 30) text:@"请输入任务标题" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.titleLabel];
    
}

#pragma mark - 创建时间Label
-(void)createTimeLabel
{
    CGFloat width = (kScreenSize.width - 16)/12;
    NSArray *array = @[@"开始时间",@"结束时间"];
    for (NSInteger i = 0; i < array.count; i++) {
        UILabel * label = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 148+(30.5+4)*i, 4*width, 30.5) text:array[i] font:16 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
        label.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:label];
    }
    
    //开始日期
    self.startDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(8+4*width, 148, 5*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.startDateLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.startDateLabel];
    
    //结束日期
    self.endDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(8+4*width, 182.5, 5*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.endDateLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.endDateLabel];
    
    //开始时间
    self.startTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12+9*width, 148, 3*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.startTimeLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.startTimeLabel];
    
    //结束时间
    self.endTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12+9*width, 182.5, 3*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.endTimeLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.endTimeLabel];
}

-(void)startDateButtonClick:(UIButton *)button
{
    
}

#pragma mark - 创建taskDetailTextView
-(void)createTaskDetailTextView
{
    self.taskDetailTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 217, kScreenSize.width - 8, 245) delegate:self tag:11 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.taskDetailTextView];
    self.taskDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 217, kScreenSize.width - 20, 30) text:@"请输入任务详情" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.taskDetailLabel.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.taskDetailLabel];
}

#pragma mark - 创建TaskRewardLabel
-(void)createTaskRewardLabel
{
    self.taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 465, kScreenSize.width - 8, 34) text:@"  选择任务奖励" font:16 alignment:@"left" color:@"#b0b0b0"  alpha:1 maskToBounds:YES];
    self.taskRewardLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.taskRewardLabel];
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(kScreenSize.width - 8 - 30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.taskRewardLabel addSubview:lineView];
    
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 8 - 25, 10, 20, 14) target:self sel:@selector(taskRewardButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.taskRewardLabel addSubview:button];
     self.scrollView.contentSize = CGSizeMake(kScreenSize.width, 500);
}

//任务奖励
-(void)taskRewardButtonClick:(UIButton *)button
{

}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 10) {
        self.titleLabel.text = @"";
    }else{
        self.taskDetailLabel.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 10) {
        if (textView.text.length == 0) {
            self.titleLabel.text = @"请输入任务标题";
        }
    }else{
        if (textView.text.length == 0) {
            self.taskDetailLabel.text = @"请输入任务详情";
        }
    }
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    ODTabBarController * tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

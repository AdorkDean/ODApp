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
    [self createTimeChooseButton];
    [self createTaskDetailTextView];
    [self createTaskRewardLabel];
    [self createRequest];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"新任务" font:16 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //取消按钮
    UIButton *cancelButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28,35, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [cancelButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:cancelButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 28,35, 20) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:16];
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
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, 500);
    [self.view addSubview:self.scrollView];
}

#pragma mark - 创建titleTextView
-(void)createTitleTextView
{
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 140) delegate:self tag:10 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    self.titleTextView.delegate = self;
    [self.scrollView addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4, kScreenSize.width - 20, 30) text:@"请输入任务标题" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.userInteractionEnabled = NO;
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
    
    //开始日期label
    self.startDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(8+4*width, 148, 5*width, 30.5) text:[[nss]] font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.startDateLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.startDateLabel];
    
    //结束日期label
    self.endDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(8+4*width, 182.5, 5*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.endDateLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.endDateLabel];
    
    //开始时间label
    self.startTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12+9*width, 148, 3*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.startTimeLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.startTimeLabel];
    
    //结束时间label
    self.endTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12+9*width, 182.5, 3*width, 30.5) text:nil font:16 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:YES];
    self.endTimeLabel.backgroundColor = [ODColorConversion colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.endTimeLabel];
}

#pragma mark - 创建时间选择button
-(void)createTimeChooseButton
{
    CGFloat width = (kScreenSize.width - 16)/12;
    //开始日期button
    UIView *startDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.startDateLabel addSubview:startDateLineView];
    UIButton *startDateButton = [ODClassMethod creatButtonWithFrame:CGRectMake(5*width - 25, 10, 20, 14) target:self sel:@selector(startDateButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.startDateLabel addSubview:startDateButton];
    
    //结束日期button
    UIView *endDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.endDateLabel addSubview:endDateLineView];
    UIButton *endDateButton = [ODClassMethod creatButtonWithFrame:CGRectMake(5*width - 25, 10, 20, 14) target:self sel:@selector(endDateButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.endDateLabel addSubview:endDateButton];
    
    //开始时间button
    UIView *startTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.startTimeLabel addSubview:startTimeLineView];
    UIButton *startTimeButton = [ODClassMethod creatButtonWithFrame:CGRectMake(3*width - 25, 10, 20, 14) target:self sel:@selector(startTimeButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.startTimeLabel addSubview:startTimeButton];
    
    //结束时间button
    UIView *endTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [self.endTimeLabel addSubview:endTimeLineView];
    UIButton *endTimeButton = [ODClassMethod creatButtonWithFrame:CGRectMake(3*width - 25, 10, 20, 14) target:self sel:@selector(endTimeButtonClick:) tag:0 image:@"时间下拉箭头" title:nil font:0];
    [self.endTimeLabel addSubview:endTimeButton];
}

//开始日期
-(void)startDateButtonClick:(UIButton *)button
{
    [self setUpDatePickerViewWihtButton:button];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

//结束日期
-(void)endDateButtonClick:(UIButton *)button
{
    [self setUpDatePickerViewWihtButton:button];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

//开始时间
-(void)startTimeButtonClick:(UIButton *)button
{
    [self setUpDatePickerViewWihtButton:button];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
}

//结束时间
-(void)endTimeButtonClick:(UIButton *)button
{
    [self setUpDatePickerViewWihtButton:button];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
}

#pragma mark - 初始化datePickerView
-(void)setUpDatePickerViewWihtButton:(UIButton *)button
{
    self.backPickerView = [ODClassMethod creatViewWithFrame:CGRectMake(4, kScreenSize.height-64-250, kScreenSize.width-8, 300) tag:0 color:@"f3f3f3"];
    [self.scrollView addSubview:self.backPickerView];
    
    //显示中文
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width-8, 200)];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    //只能选择大于当前时间的日期
    [self.datePicker setMinimumDate:[NSDate date]];
    [self.backPickerView addSubview:self.datePicker];
    
    UIButton *cancelPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 200, kScreenSize.width/2-4, 50) target:self sel:@selector(cancelPickerButtonClick:) tag:0 image:nil title:@"取消" font:16];
    [self.backPickerView addSubview:cancelPickerButton];
    UIButton *confirmPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width/2-4, 200, kScreenSize.width/2-4, 50) target:self sel:@selector(confirmPickerButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [self.backPickerView addSubview:confirmPickerButton];
}

//确认datePickerView
-(void)confirmPickerButtonClick:(UIButton *)button
{
    self.startDateLabel.text = [self timeFormat];
}

//取消datePickerView
-(void)cancelPickerButtonClick:(UIButton *)button
{
    [UIView animateWithDuration:0.5 animations:^{
        self.backPickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backPickerView removeFromSuperview];
    }];
}

//时间格式
- (NSString *)timeFormat
{
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

#pragma mark - 创建taskDetailTextView
-(void)createTaskDetailTextView
{
    self.taskDetailTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 217, kScreenSize.width - 8, 245) delegate:self tag:11 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.taskDetailTextView];
    self.taskDetailTextView.delegate = self;
    self.taskDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 217, kScreenSize.width - 20, 30) text:@"请输入任务详情" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.taskDetailLabel.backgroundColor = [UIColor clearColor];
    self.taskDetailLabel.userInteractionEnabled = NO;
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
}

//任务奖励
-(void)taskRewardButtonClick:(UIButton *)button
{
   
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushDataWithUrl:kBazaarReleaseTaskUrl parameter:signParameter];
}

#pragma mark - 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"error");
    }];
    
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

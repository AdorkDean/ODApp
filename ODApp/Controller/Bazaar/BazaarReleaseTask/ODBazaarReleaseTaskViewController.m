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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self navigationInit];
    [self createScrollView];
    [self createTitleTextView];
    [self createTimeLabel];
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
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"新任务" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
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
    NSString *startDate = self.startDateLabel.text;
    NSString *endDate = self.endDateLabel.text;
    NSComparisonResult dateResult =[startDate compare:endDate];
    
    NSString *startTime = self.startTimeLabel.text;
    NSString *endTime = self.endTimeLabel.text;
    NSComparisonResult timeResult = [startTime compare:endTime];
    
    
    if (self.titleTextView.text.length>0&&self.taskDetailTextView.text.length>0) {
        if (dateResult == NSOrderedDescending){
            [self createUIAlertControllerWithTitle:@"结束日期不得早于开始日期"];
        }
        else if ([self.endDateLabel.text compare:[self getCurrentDate:NO]]== NSOrderedAscending){
            [self createUIAlertControllerWithTitle:@"开始日期不能早于当前日期"];
        }
        else if (dateResult == NSOrderedSame){
        
            if (timeResult == NSOrderedDescending || timeResult == NSOrderedSame){
                [self createUIAlertControllerWithTitle:@"结束时间不得早于开始时间"];
            }
            else if ([self.startTimeLabel.text compare:[self getCurrentDate:NO]]!= NSOrderedDescending){
                [self createUIAlertControllerWithTitle:@"开始时间不能早于当前时间"];
            }
            else{
                [self joiningTogetherParmeters];
            }
        }
        
        else{
            [self joiningTogetherParmeters];
        }


    }else{
        if (self.titleTextView.text.length == 0) {
            [self createUIAlertControllerWithTitle:@"请输入任务标题"];
        }else if (self.taskDetailTextView.text.length == 0){
            [self createUIAlertControllerWithTitle:@"请输入任务内容"];
        }
    }
}

//获取当前时间
- (NSString *)getCurrentDate:(BOOL)isDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isDate) {
        [dateFormatter setDateFormat:@"  yyyy-MM-dd"];
    }else{
        [dateFormatter setDateFormat:@"  HH:mm"];
    }
    self.currentDateStr = [dateFormatter stringFromDate:currentDate];
    return self.currentDateStr;
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
        UILabel * label = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 148+(30.5+4)*i, 3.5*width, 30.5) text:array[i] font:15 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
        label.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.scrollView addSubview:label];
    }
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [timeFormatter stringFromDate:currentDate];
    
    //开始日期label
    UITapGestureRecognizer *startDateGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startDateGestureClick)];
    UIView *startDateView = [ODClassMethod creatViewWithFrame:CGRectMake(8+3.5*width, 148, 5*width, 30.5) tag:0 color:@"#ffffff"];
    [startDateView addGestureRecognizer:startDateGesture];
    startDateView.layer.masksToBounds = YES;
    startDateView.layer.cornerRadius = 5;
    startDateView.layer.borderWidth = 1;
    startDateView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.scrollView addSubview:startDateView];
    
    self.startDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 5*width-30, 30.5) text:[NSString stringWithFormat:@"%@",dateString] font:15 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [startDateView addSubview:self.startDateLabel];
    
    
    UIView *startDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [startDateView addSubview:startDateLineView];
    UIImageView *startDateImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(5*width - 25, 10, 20, 14) imageName:@"时间下拉箭头" tag:0];
    [startDateView addSubview:startDateImageView];
    
    //结束日期label
    UITapGestureRecognizer *endDateGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endDateGestureClick)];
    UIView *endDateView = [ODClassMethod creatViewWithFrame:CGRectMake(8+3.5*width, 182.5, 5*width, 30.5) tag:0 color:@"#ffffff"];
    [endDateView addGestureRecognizer:endDateGesture];
    endDateView.layer.masksToBounds = YES;
    endDateView.layer.cornerRadius = 5;
    endDateView.layer.borderWidth = 1;
    endDateView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.scrollView addSubview:endDateView];
    
    self.endDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 5*width-30, 30.5) text:[NSString stringWithFormat:@"%@",dateString] font:15 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [endDateView addSubview:self.endDateLabel];
    
    UIView *endDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [endDateView addSubview:endDateLineView];
    UIImageView *endDateImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(5*width - 25, 10, 20, 14) imageName:@"时间下拉箭头" tag:0];
    [endDateView addSubview:endDateImageView];
    
    //开始时间label
    UITapGestureRecognizer *startTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimeGestureClick)];
    UIView *startTimeView = [ODClassMethod creatViewWithFrame:CGRectMake(12+8.5*width, 148, 3.5*width, 30.5) tag:0 color:@"#ffffff"];
    [startTimeView addGestureRecognizer:startTimeGesture];
    startTimeView.layer.masksToBounds = YES;
    startTimeView.layer.cornerRadius = 5;
    startTimeView.layer.borderWidth = 1;
    startTimeView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.scrollView addSubview:startTimeView];
    self.startTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 3.5*width-30, 30.5) text:[NSString stringWithFormat:@"%@",timeString] font:15 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [startTimeView addSubview:self.startTimeLabel];
    
    UIView *startTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3.5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [startTimeView addSubview:startTimeLineView];
    UIImageView *startTimeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(3.5*width - 25, 10, 20, 14) imageName:@"时间下拉箭头" tag:0];
    [startTimeView addSubview:startTimeImageView];

    
    //结束时间label
    UITapGestureRecognizer *endTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endTimeGestureClick)];
    UIView *endTimeView = [ODClassMethod creatViewWithFrame:CGRectMake(12+8.5*width, 182.5, 3.5*width, 30.5) tag:0 color:@"#ffffff"];
    [endTimeView addGestureRecognizer:endTimeGesture];
    endTimeView.layer.masksToBounds = YES;
    endTimeView.layer.cornerRadius = 5;
    endTimeView.layer.borderWidth = 1;
    endTimeView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.scrollView addSubview:endTimeView];
    
    self.endTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 3.5*width-30, 30.5) text:[NSString stringWithFormat:@"%@",timeString] font:15 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [endTimeView addSubview:self.endTimeLabel];
    UIView *endTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3.5*width-30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [endTimeView addSubview:endTimeLineView];
    UIImageView *endTimeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(3.5*width - 25, 10, 20, 14) imageName:@"时间下拉箭头" tag:0];
    [endTimeView addSubview:endTimeImageView];
}

-(void)startDateGestureClick
{
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    [self.backPickerView removeFromSuperview];
    [self setUpDatePickerView];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.type = @"startDate";
}

-(void)endDateGestureClick
{
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    [self.backPickerView removeFromSuperview];
    [self setUpDatePickerView];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.type = @"endDate";
}

-(void)startTimeGestureClick
{
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    [self.backPickerView removeFromSuperview];
    [self setUpDatePickerView];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.type = @"startTime";
}

-(void)endTimeGestureClick
{
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    [self.backPickerView removeFromSuperview];
    [self setUpDatePickerView];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.type = @"endTime";
}

#pragma mark - 初始化datePickerView
-(void)setUpDatePickerView
{
    self.backPickerView = [ODClassMethod creatViewWithFrame:CGRectMake(4, kScreenSize.height-200, kScreenSize.width-8, 200) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.backPickerView];
    
    //显示中文
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width-8, 150)];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.datePicker.locale = locale;
    //只能选择大于当前时间的日期
//    [self.datePicker setMinimumDate:[NSDate date]];
    [self.backPickerView addSubview:self.datePicker];
    
    UIButton *cancelPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 150, kScreenSize.width/2-4, 50) target:self sel:@selector(cancelPickerButtonClick:) tag:0 image:nil title:@"取消" font:16];
    [self.backPickerView addSubview:cancelPickerButton];
    UIButton *confirmPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width/2-4, 150, kScreenSize.width/2-4, 50) target:self sel:@selector(confirmPickerButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [self.backPickerView addSubview:confirmPickerButton];
}

//确认datePickerView
-(void)confirmPickerButtonClick:(UIButton *)button
{
    if ([self.type isEqualToString:@"startDate"]) {
        self.startDateLabel.text = [NSString stringWithFormat:@"%@",[self timeFormatDate:YES]];
    }else if ([self.type isEqualToString:@"endDate"]){
        self.endDateLabel.text = [NSString stringWithFormat:@"%@",[self timeFormatDate:YES]];
    }else if ([self.type isEqualToString:@"startTime"]){
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@",[self timeFormatDate:NO]];
    }else if ([self.type isEqualToString:@"endTime"]){
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@",[self timeFormatDate:NO]];
    }
    self.type = nil;
    [self.backPickerView removeFromSuperview];
}

//取消datePickerView
-(void)cancelPickerButtonClick:(UIButton *)button
{
    [self.backPickerView removeFromSuperview];
}

//时间格式
- (NSString *)timeFormatDate:(BOOL)isDate
{
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

#pragma mark - 创建taskDetailTextView
-(void)createTaskDetailTextView
{
    self.taskDetailTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 217, kScreenSize.width - 8, 245) delegate:self tag:11 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.taskDetailTextView];
    self.taskDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 217, kScreenSize.width - 20, 30) text:@"请输入任务详情" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.taskDetailLabel.backgroundColor = [UIColor clearColor];
    self.taskDetailLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.taskDetailLabel];
}

#pragma mark - 创建TaskRewardLabel
-(void)createTaskRewardLabel
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taskRewardClick)];
    UIView *taskeRewardView = [ODClassMethod creatViewWithFrame:CGRectMake(4, 465, kScreenSize.width - 8, 34) tag:0 color:@"#ffffff"];
    [taskeRewardView addGestureRecognizer:gesture];
    taskeRewardView.layer.masksToBounds = YES;
    taskeRewardView.layer.cornerRadius = 5;
    taskeRewardView.layer.borderWidth = 1;
    taskeRewardView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.scrollView addSubview:taskeRewardView];
    self.taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, kScreenSize.width - 8, 34) text:@"  选择任务奖励" font:16 alignment:@"left" color:@"#b0b0b0"  alpha:1 maskToBounds:NO];
    self.taskRewardLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [taskeRewardView addSubview:self.taskRewardLabel];
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(kScreenSize.width - 8 - 30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [taskeRewardView addSubview:lineView];
    UIImageView *imageVidew = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 8 - 25, 10, 20, 14) imageName:@"时间下拉箭头" tag:0];
    [taskeRewardView addSubview:imageVidew];
}

//任务奖励
-(void)taskRewardClick
{
    ODBazaarReleaseRewardViewController *reward = [[ODBazaarReleaseRewardViewController alloc]init];
    [self.navigationController pushViewController:reward animated:YES];
    reward.taskRewardBlock = ^(NSString *name,NSString *reward_id){
        self.taskRewardLabel.text = [NSString stringWithFormat:@"  %@",name];
        self.reward_id = reward_id;
    };
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
}


#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter;
    if ([self.taskRewardLabel.text isEqualToString:@"  选择任务奖励"]) {
        parameter = @{@"title":self.titleTextView.text,@"tag_ids":@"",@"start_time":[self.startDateLabel.text stringByAppendingString:self.startTimeLabel.text],@"end_time":[self.endDateLabel.text stringByAppendingString:self.endTimeLabel.text],@"content":self.taskDetailTextView.text,@"open_id":[ODUserInformation getData].openID};

    }else{
        parameter = @{@"title":self.titleTextView.text,@"tag_ids":@"",@"start_time":[self.startDateLabel.text stringByAppendingString:self.startTimeLabel.text],@"end_time":[self.endDateLabel.text stringByAppendingString:self.endTimeLabel.text],@"end_time":[self.startDateLabel.text stringByAppendingString:self.startTimeLabel.text],@"end_time":[self.endDateLabel.text stringByAppendingString:self.endTimeLabel.text],@"content":self.taskDetailTextView.text,@"reward_id":self.reward_id,@"open_id":[ODUserInformation getData].openID};
    }
  
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    NSLog(@"%@",signParameter);
    [self pushDataWithUrl:kBazaarReleaseTaskUrl parameter:signParameter];
}

#pragma mark - 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.myBlock) {
                self.myBlock([NSString stringWithFormat:@"release"]);
            }
        
            self.isJob = YES;
        
            if (self.isBazaar == NO) {
                NSArray *imageArray = @[@"首页发现icon",@"中心活动icon",@"欧动集市icon",@"欧动社区icon",@"个人中心icon"];
                ODTabBarController *tabbar = (ODTabBarController *)self.navigationController.tabBarController;
                tabbar.selectedIndex = 2;
                
                NSInteger index = 2;
                for (NSInteger i = 0; i < 5; i++) {
                    UIButton *newButton= (UIButton *)[tabbar.imageView viewWithTag:1+i];
                    UIImageView *imageView = (UIImageView *)[newButton viewWithTag:6+i];
                    
                    if (i!=index) {
                        newButton.selected =NO;
                        //                    button.selected = YES;
                        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@默认态",imageArray[i]]];
                        
                    }else{
                        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@点击态",imageArray[i]]];
                    }
                }
            }
            else{
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"_____error");
    }];
    
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == self.titleTextView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
        }
    }
    
    if (textView == self.taskDetailTextView) {
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

#pragma mark - 创建提示信息
-(void)createUIAlertControllerWithTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    
    if (self.isJob) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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

//
//  ODBazaarReleaseTaskViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarReleaseTaskViewController.h"

@interface ODBazaarReleaseTaskViewController ()
@end

@implementation ODBazaarReleaseTaskViewController

#pragma mark - lazyload
-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64)];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScreenSize.width, 504);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width - 8, 150)];
        [self.backPickerView addSubview:_datePicker];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        [self.backPickerView addSubview:_datePicker];
        UIButton *cancelPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 150, kScreenSize.width / 2 - 4, 50) target:self sel:@selector(cancelPickerButtonClick:) tag:0 image:nil title:@"取消" font:16];
        [self.backPickerView addSubview:cancelPickerButton];
        UIButton *confirmPickerButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width / 2 - 4, 150, kScreenSize.width / 2 - 4, 50) target:self sel:@selector(confirmPickerButtonClick:) tag:0 image:nil title:@"确认" font:16];
        [self.backPickerView addSubview:confirmPickerButton];
    }
    return _datePicker;
}

-(UIView *)backPickerView{
    if (!_backPickerView) {
        _backPickerView = [[UIView alloc]initWithFrame:CGRectMake(4, kScreenSize.height - 200 - 64, kScreenSize.width - 8, 200)];
        _backPickerView.backgroundColor = [UIColor backgroundColor];
        [self.view addSubview:_backPickerView];
    }
    return _backPickerView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"新任务";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
    [self createTitleTextView];
    [self createTimeLabel];
    [self createTaskDetailTextView];
    [self createTaskRewardLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isJob) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建titleTextView
- (void)createTitleTextView {
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 140) delegate:self tag:0 font:14 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4, kScreenSize.width - 20, 30) text:@"请输入任务标题" font:14 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.textColor = [UIColor colorWithRGBString:@"d0d0d0" alpha:1];
    self.titleLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.titleLabel];
}

#pragma mark - 创建时间Label
- (void)createTimeLabel {
    CGFloat width = (kScreenSize.width - 16) / 12;
    NSArray *array = @[@"开始时间", @"结束时间"];
    for (NSInteger i = 0; i < array.count; i++) {
        UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake(4, 148 + (30.5 + 4) * i, 3.5 * width, 30.5) text:array[i] font:13 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
        label.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:label];
    }

    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSince1970];
    NSTimeInterval startTime = timeInterval + 1800;
    NSTimeInterval endTime = timeInterval + 86400;

    //开始
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [startDateFormatter stringFromDate:startDate];

    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    [startTimeFormatter setDateFormat:@"HH:mm"];
    NSString *startTimeString = [startTimeFormatter stringFromDate:startDate];

    //结束
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
    [endDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateString = [endDateFormatter stringFromDate:endDate];

    NSDateFormatter *endTimeFormatter = [[NSDateFormatter alloc] init];
    [endTimeFormatter setDateFormat:@"HH:mm"];
    NSString *endTimeString = [endTimeFormatter stringFromDate:endDate];

    //开始日期label
    UITapGestureRecognizer *startDateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateGestureClick)];
    UIView *startDateView = [ODClassMethod creatViewWithFrame:CGRectMake(8 + 3.5 * width, 148, 5 * width, 30.5) tag:0 color:@"#ffffff"];
    [startDateView addGestureRecognizer:startDateGesture];
    startDateView.layer.masksToBounds = YES;
    startDateView.layer.cornerRadius = 5;
    startDateView.layer.borderWidth = 1;
    startDateView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:startDateView];

    self.startDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 5 * width - 30, 30.5) text:[NSString stringWithFormat:@"%@", startDateString] font:13 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [startDateView addSubview:self.startDateLabel];

    UIView *startDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5 * width - 30, 9, 1, 12.5) tag:0 color:@"#b0b0b0"];
    [startDateView addSubview:startDateLineView];
    UIImageView *startDateImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(5 * width - 22, 11, 15, 8.4) imageName:@"时间下拉箭头" tag:0];
    [startDateView addSubview:startDateImageView];

    //结束日期label
    UITapGestureRecognizer *endDateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateGestureClick)];
    UIView *endDateView = [ODClassMethod creatViewWithFrame:CGRectMake(8 + 3.5 * width, 182.5, 5 * width, 30.5) tag:0 color:@"#ffffff"];
    [endDateView addGestureRecognizer:endDateGesture];
    endDateView.layer.masksToBounds = YES;
    endDateView.layer.cornerRadius = 5;
    endDateView.layer.borderWidth = 1;
    endDateView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:endDateView];

    self.endDateLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 5 * width - 30, 30.5) text:[NSString stringWithFormat:@"%@", endDateString] font:13 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [endDateView addSubview:self.endDateLabel];

    UIView *endDateLineView = [ODClassMethod creatViewWithFrame:CGRectMake(5 * width - 30, 9, 1, 12.5) tag:0 color:@"#b0b0b0"];
    [endDateView addSubview:endDateLineView];
    UIImageView *endDateImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(5 * width - 22,11, 15, 8.4) imageName:@"时间下拉箭头" tag:0];
    [endDateView addSubview:endDateImageView];

    //开始时间label
    UITapGestureRecognizer *startTimeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeGestureClick)];
    UIView *startTimeView = [ODClassMethod creatViewWithFrame:CGRectMake(12 + 8.5 * width, 148, 3.5 * width, 30.5) tag:0 color:@"#ffffff"];
    [startTimeView addGestureRecognizer:startTimeGesture];
    startTimeView.layer.masksToBounds = YES;
    startTimeView.layer.cornerRadius = 5;
    startTimeView.layer.borderWidth = 1;
    startTimeView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:startTimeView];
    self.startTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 3.5 * width - 30, 30.5) text:[NSString stringWithFormat:@"%@", startTimeString] font:13 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [startTimeView addSubview:self.startTimeLabel];

    UIView *startTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3.5 * width - 30, 9, 1, 12.5) tag:0 color:@"#b0b0b0"];
    [startTimeView addSubview:startTimeLineView];
    UIImageView *startTimeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(3.5 * width - 22, 11, 15, 8.4) imageName:@"时间下拉箭头" tag:0];
    [startTimeView addSubview:startTimeImageView];


    //结束时间label
    UITapGestureRecognizer *endTimeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeGestureClick)];
    UIView *endTimeView = [ODClassMethod creatViewWithFrame:CGRectMake(12 + 8.5 * width, 182.5, 3.5 * width, 30.5) tag:0 color:@"#ffffff"];
    [endTimeView addGestureRecognizer:endTimeGesture];
    endTimeView.layer.masksToBounds = YES;
    endTimeView.layer.cornerRadius = 5;
    endTimeView.layer.borderWidth = 1;
    endTimeView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:endTimeView];

    self.endTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, 3.5 * width - 30, 30.5) text:[NSString stringWithFormat:@"%@", endTimeString] font:13 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:NO];
    [endTimeView addSubview:self.endTimeLabel];
    UIView *endTimeLineView = [ODClassMethod creatViewWithFrame:CGRectMake(3.5 * width - 30, 9, 1, 12.5) tag:0 color:@"#b0b0b0"];
    [endTimeView addSubview:endTimeLineView];
    UIImageView *endTimeImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(3.5 * width - 22, 11, 15, 8.4) imageName:@"时间下拉箭头" tag:0];
    [endTimeView addSubview:endTimeImageView];
}

- (void)dateGestureClick {
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    self.backPickerView.hidden = NO;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.type = @"date";
}

- (void)timeGestureClick {
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    self.backPickerView.hidden = NO;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    self.type = @"time";
}

//时间格式
- (NSString *)timeFormatDate:(BOOL)isDate {
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (isDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

#pragma mark - 创建taskDetailTextView
- (void)createTaskDetailTextView {
    self.taskDetailTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 217, kScreenSize.width - 8, 245) delegate:self tag:0 font:14 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.taskDetailTextView];
    self.taskDetailLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 217, kScreenSize.width - 20, 30) text:@"请输入任务详情" font:14 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.taskDetailLabel.textColor = [UIColor colorGrayColor];
    self.taskDetailLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.taskDetailLabel];
}

#pragma mark - 创建TaskRewardLabel
- (void)createTaskRewardLabel {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskRewardClick)];
    UIView *taskeRewardView = [ODClassMethod creatViewWithFrame:CGRectMake(4, 465, kScreenSize.width - 8, 34) tag:0 color:@"#ffffff"];
    [taskeRewardView addGestureRecognizer:gesture];
    taskeRewardView.layer.masksToBounds = YES;
    taskeRewardView.layer.cornerRadius = 5;
    taskeRewardView.layer.borderWidth = 1;
    taskeRewardView.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:taskeRewardView];
    self.taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 0, taskeRewardView.frame.size.width-35, 34) text:@"  选择任务奖励" font:13 alignment:@"left" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
    self.taskRewardLabel.backgroundColor = [UIColor whiteColor];
    [taskeRewardView addSubview:self.taskRewardLabel];

    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(kScreenSize.width - 8 - 30, 10, 1, 14) tag:0 color:@"#b0b0b0"];
    [taskeRewardView addSubview:lineView];
    UIImageView *imageVidew = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width - 8 - 22, 12.8, 15, 8.4) imageName:@"时间下拉箭头" tag:0];
    [taskeRewardView addSubview:imageVidew];
}

#pragma mark - 提交数据
- (void)pushData{
    __weakSelf
     NSDictionary *parameter;
    if ([self.taskRewardLabel.text isEqualToString:@"  选择任务奖励"]) {
        parameter = @{@"title" : self.titleTextView.text, @"tag_ids" : @"", @"start_time" : [[self.startDateLabel.text stringByAppendingString:@" "] stringByAppendingString:self.startTimeLabel.text], @"end_time" : [[self.endDateLabel.text stringByAppendingString:@" "] stringByAppendingString:self.endTimeLabel.text], @"content" : self.taskDetailTextView.text};
    } else {
        parameter = @{@"title" : self.titleTextView.text, @"tag_ids" : @"", @"start_time" : [[self.startDateLabel.text stringByAppendingString:@" "] stringByAppendingString:self.startTimeLabel.text], @"end_time" : [[self.endDateLabel.text stringByAppendingString:@" "] stringByAppendingString:self.endTimeLabel.text], @"content" : self.taskDetailTextView.text, @"reward_name" : [self.taskRewardLabel.text substringFromIndex:2]};
    }
    [ODHttpTool getWithURL:ODUrlTaskTaskAdd parameters:parameter modelClass:[NSObject class] success:^(id model) {
        if (weakSelf.myBlock) {
            weakSelf.myBlock([NSString stringWithFormat:@"release"]);
        }
        weakSelf.isJob = YES;
        if (weakSelf.isBazaar == NO) {
            ODTabBarController *tabbar = (ODTabBarController *) self.navigationController.tabBarController;
            tabbar.selectedIndex = 2;
        }
        else {
            [ODProgressHUD showInfoWithStatus:@"任务发布成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationReleaseTask object:nil];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - UITextViewDelegate
NSString *taskTitleText = @"";
NSString *taskDetailText = @"";
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.titleTextView) {
        if (textView.text.length > 30) {
            textView.text = [textView.text substringToIndex:30];
        } else {
            taskTitleText = textView.text;
        }
        if (self.titleTextView.text.length == 0) {
            self.titleLabel.text = @"请输入任务标题";
        } else {
            self.titleLabel.text = @"";
        }
    }
    else if (textView == self.taskDetailTextView) {
        if (textView.text.length > 500) {
            textView.text = [textView.text substringToIndex:500];
        } else {
            taskDetailText = textView.text;
        }

        if (self.taskDetailTextView.text.length == 0) {
            self.taskDetailLabel.text = @"请输入任务详情";
        } else {
            self.taskDetailLabel.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.titleTextView) {
        if (textView.text.length == 0) {
            self.titleLabel.text = @"请输入任务标题";
        }
    } else {
        if (textView.text.length == 0) {
            self.taskDetailLabel.text = @"请输入任务详情";
        }
    }
}


#pragma mark - action
- (void)confirmButtonClick:(UIButton *)button {
    [self.titleTextView resignFirstResponder];
    [self.taskDetailTextView resignFirstResponder];
    [self.backPickerView removeFromSuperview];
    if (self.titleTextView.text.length > 0 && self.taskDetailTextView.text.length > 0) {
        [self pushData];
    } else {
        if (self.titleTextView.text.length == 0) {
            [ODProgressHUD showInfoWithStatus:@"请输入任务标题"];
        } else if (self.taskDetailTextView.text.length == 0) {
            [ODProgressHUD showInfoWithStatus:@"请输入任务内容"];
        }
    }
}

- (void)confirmPickerButtonClick:(UIButton *)button {
    if ([self.type isEqualToString:@"date"]) {
        self.startDateLabel.text = [NSString stringWithFormat:@"%@", [self timeFormatDate:YES]];
        self.endDateLabel.text = [NSString stringWithFormat:@"%@", [self timeFormatDate:YES]];
    } else if ([self.type isEqualToString:@"time"]) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeFormatDate:NO]];
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@", [self timeFormatDate:NO]];
    }
    self.type = nil;
    self.backPickerView.hidden = YES;
}

- (void)cancelPickerButtonClick:(UIButton *)button {
    self.backPickerView.hidden = YES;
}

- (void)taskRewardClick {
    ODBazaarReleaseRewardViewController *reward = [[ODBazaarReleaseRewardViewController alloc] init];
    [self.navigationController pushViewController:reward animated:YES];
    reward.taskRewardBlock = ^(NSString *name) {
        self.taskRewardLabel.text = [NSString stringWithFormat:@"  %@", name];
    };
}

@end

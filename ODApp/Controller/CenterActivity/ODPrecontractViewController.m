//
//  ODPrecontractViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/1.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODStoreDetailModel.h"
#import "ODStoreTimelineModel.h"
#import "ODStoreCreateOrderModel.h"
#import "ODStoreSubmitOrderModel.h"

#import "ODPrecontractViewController.h"
#import "ODChoseCenterController.h"

#import "ODPlacePrecontrHeaderView.h"
#import "ODPlacePreDeviceView.h"
#import "ODPlacePreFooterView.h"
#import "ODPickerHeaderView.h"

@interface ODPrecontractViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate,ODPlacePreDeviceViewDelegate>
{
    BOOL isSelectedStart;
    NSInteger startSelLeftRow;
    NSInteger startSelRightRow;
}
/** 底部滚动视图 */
@property (nonatomic,strong) UIScrollView *baseScrollView;

/** 头部视图 */
@property (nonatomic,strong) ODPlacePrecontrHeaderView *headView;

/** 设备视图 */
@property (nonatomic,strong) ODPlacePreDeviceView *deviceView;

/** 底部视图 */
@property (nonatomic,strong) ODPlacePreFooterView *footerView;

/** 时间选择底部 */
@property (nonatomic,strong) UIView *pickerBaseView;

/** 时间选择器 */
@property (nonatomic,strong) UIPickerView *pickerView;

/** 时间选择器头部 */
@property (nonatomic,strong) ODPickerHeaderView *pickerHeadView;

/** 选用的设备信息 */
@property (nonatomic,strong) NSMutableArray *devices;

/** 左边可以选择的开始日期 */
@property (nonatomic,strong) NSArray *startDates;

/** 右边可以选择的开始时间 */
@property (nonatomic,strong) NSArray *startTimes;

/** 左边可以选择的结束日期 */
@property (nonatomic,strong) NSArray *endDates;

/** 右边可以选择的结束时间 */
@property (nonatomic,strong) NSArray *endTimes;

/** 选择的日期 */
@property (nonatomic,copy) NSString *dateStr;

/** 选择的开始时间 */
@property (nonatomic,copy) NSString *startTimeStr;

/** 选择的结束时间 */
@property (nonatomic,copy) NSString *endTimeStr;

/** 开始时间 */
@property (nonatomic,copy) NSString *start_dateTime;

/** 结束时间 */
@property (nonatomic,copy) NSString *end_datetime;

@end

@implementation ODPrecontractViewController

#pragma mark - 懒加载

- (UIScrollView *)baseScrollView
{
    if (!_baseScrollView)
    {
        _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [self.view addSubview:_baseScrollView];
    }
    return _baseScrollView;
}

- (ODPlacePrecontrHeaderView *)headView
{
    if (!_headView)
    {
        _headView = [ODPlacePrecontrHeaderView od_viewFromXib];
        _headView.frame = CGRectMake(0, 0, KScreenWidth, _headView.viewHeight);
        [_headView.startTimeBtn addTarget:self action:@selector(headViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.endTimeBtn addTarget:self action:@selector(headViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.placeBtn addTarget:self action:@selector(headViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:_headView];
    }
    return _headView;
}

- (ODPlacePreDeviceView *)deviceView
{
    if (!_deviceView)
    {
        _deviceView = [ODPlacePreDeviceView od_viewFromXib];
        _deviceView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), KScreenWidth, _deviceView.viewHeight);
        [self.baseScrollView addSubview:_deviceView];
    }
    return _deviceView;
}

- (ODPlacePreFooterView *)footerView
{
    if (!_footerView)
    {
        _footerView = [ODPlacePreFooterView od_viewFromXib];
        _footerView.frame = CGRectMake(0, CGRectGetMaxY(self.deviceView.frame), KScreenWidth,_footerView.viewHeight);
        [_footerView.submitBtn addTarget:self action:@selector(requestCreateOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.baseScrollView addSubview:_footerView];
        [self.baseScrollView bringSubviewToFront:self.deviceView];
        self.baseScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_footerView.frame));
    }
    return _footerView;
}

- (UIView *)pickerBaseView
{
    if (!_pickerBaseView)
    {
        _pickerBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 30 + 230)];
        [self.view addSubview:_pickerBaseView];
    }
    return _pickerBaseView;
}

- (ODPickerHeaderView *)pickerHeadView
{
    if (!_pickerHeadView)
    {
        _pickerHeadView = [ODPickerHeaderView od_viewFromXib];
        [_pickerHeadView.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_pickerHeadView.cancelBtn addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
        _pickerHeadView.frame = CGRectMake(0, 0, KScreenWidth, 30);
        [self.pickerBaseView addSubview:_pickerHeadView];
    }
    return _pickerHeadView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor backgroundColor];
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.pickerHeadView.frame), KScreenWidth, self.pickerBaseView.od_height - self.pickerHeadView.od_height);
        [self.pickerBaseView addSubview:_pickerView];
    }
    return _pickerView;
}

- (NSMutableArray *)devices
{
    if (!_devices)
    {
        _devices = [NSMutableArray array];
    }
    return _devices;
}

- (NSString *)start_dateTime
{
    if (!_start_dateTime || _start_dateTime.length == 0)
    {
        _start_dateTime = @"";
    }
    return _start_dateTime;
}
#pragma mark - set方法

- (void)setStoreId:(NSString *)storeId
{
    if ([self.storeId isEqualToString:storeId]) return;
    _storeId = storeId;
    [self.headView reback];
    [self requestStoreDetail];
}

#pragma mark - 生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"场地预约";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(back) color:nil highColor:nil title:@"返回"];
    self.storeId = @"1";
    isSelectedStart = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditing];
}

#pragma mark - 数据请求方法

- (void)requestStoreDetail
{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreDetail parameters:@{@"store_id":self.storeId} modelClass:[ODStoreDetailModel class] success:^(id model)
    {
        ODStoreDetailModel *detailModel = [model result];
        [weakSelf.headView.placeBtn setTitle:detailModel.name forState:UIControlStateNormal];
        weakSelf.deviceView.devices = detailModel.device_list;
        [weakSelf.footerView.phoneBtn setTitle:detailModel.tel forState:UIControlStateNormal];
        [weakSelf requestStoreTimeline];
    }
                   failure:^(NSError *error)
    {
        
    }];
}

- (void)requestStoreTimeline
{
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreTime parameters:@{@"store_id":self.storeId,@"start_datetime":self.start_dateTime} modelClass:[ODStoreTimelineModel class] success:^(id model)
    {
        if (isSelectedStart)
        {
            weakSelf.startDates = [model result];
        }
        else
        {
            weakSelf.endDates = [model result];
        }
        [weakSelf.pickerView reloadAllComponents];
    }
                   failure:^(NSError *error)
    {
        
    }];
}

- (void)requestCreateOrder
{
    if (self.headView.startTimeBtn.currentTitle.length == 0)
    {
        [ODProgressHUD showInfoWithStatus:@"请选择开始时间"];
    }
    else if (self.end_datetime.length == 0)
    {
        [ODProgressHUD showInfoWithStatus:@"请选择结束时间"];
    }
    else if (self.footerView.pupurseTextView.text.length == 0)
    {
        [ODProgressHUD showInfoWithStatus:@"请输入活动目的"];
    }
    else if (self.footerView.contentTextView.text.length == 0)
    {
        [ODProgressHUD showInfoWithStatus:@"请输入活动内容"];
    }
    else if (self.footerView.numTextView.text.length == 0)
    {
        [ODProgressHUD showInfoWithStatus:@"请输入活动人数"];
    }
    else
    {
        __weakSelf
        NSDictionary *parameter = @{
                                    @"start_datetime":self.start_dateTime,
                                    @"end_datetime":self.end_datetime,
                                    @"store_id":self.storeId
                                    };
        [ODHttpTool getWithURL:ODUrlCreateOrder parameters:parameter modelClass:[ODStoreCreateOrderModel class] success:^(id model)
         {
             ODStoreCreateOrderModel *orderModel = [model result];
             [weakSelf requestSubmitWithOrderId:[@(orderModel.order_id)stringValue]];
         }
                       failure:^(NSError *error)
         {
             
         }];
    }
}
- (void)requestSubmitWithOrderId:(NSString *)orderId
{
    __weakSelf
    NSString *content = self.footerView.contentTextView.text.length ? @"" : self.footerView.contentTextView.text;
    NSDictionary *parameter = @{
                                @"start_datetime":self.start_dateTime,
                                @"end_datetime":self.end_datetime,
                                @"store_id":self.storeId,
                                @"order_id":orderId,
                                @"purpose":self.footerView.pupurseTextView.text,
                                @"content":content,
                                @"people_num":self.footerView.numTextView.text,
                                @"devices":self.devices.desc,
                                };
    [ODHttpTool getWithURL:ODUrlConfirmOrder parameters:parameter modelClass:[ODStoreSubmitOrderModel class] success:^(id model)
    {
        [ODProgressHUD showInfoWithStatus:@"感谢您的预约请等待审核"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
                   failure:^(NSError *error)
     {
        
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return isSelectedStart ? self.startDates.count : self.endDates.count;
        case 1:
            return isSelectedStart ? self.startTimes.count : self.endTimes.count;
        default:
            return 0;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            if (isSelectedStart)
            {
                self.startTimes = [self.startDates[row]cao];
                return [self.startDates[row]date_left_str];
            }
            else
            {
                self.endTimes = [self.endDates[row]cao];
                [pickerView reloadComponent:1];
                return [self.endDates[row]date_left_str];
            }
        case 1:
        {
            NSArray *subArray = isSelectedStart ? self.startTimes : self.endTimes;
            return [subArray[row]date_right_str];
        }
        default:
            return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [pickerView reloadComponent:1];
    }
    else
    {
        [pickerView selectedRowInComponent:0];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *purposeText = @"";
    NSString *contentText = @"";
    NSString *numText = @"";
    if (textView == self.footerView.pupurseTextView)
    {
        if (textView.text.length > 20)
        {
            textView.text = [textView.text substringToIndex:20];
        }
        else
        {
            purposeText = textView.text;
        }
    }
    else if (textView == self.footerView.contentTextView)
    {
        if (textView.text.length > 100)
        {
            textView.text = [textView.text substringToIndex:100];
        }
        else
        {
            contentText = textView.text;
        }
    }
    else if (textView == self.footerView.numTextView)
    {
        if (textView.text.length > 3)
        {
            textView.text = [textView.text substringFromIndex:3];
        }
        else
        {
            numText = textView.text;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ODPlacePreDeviceViewDelegate

- (void)placePreDeviceView:(ODPlacePreDeviceView *)view clickedActiveDeviceBtn:(ODActiveDeviceBtn *)ActiveDeviceBtn;
{
    if (ActiveDeviceBtn.selected)
    {
        [self.devices addObject:[@(ActiveDeviceBtn.deviceId)stringValue]];
    }
    else
    {
        [self.devices removeObject:[@(ActiveDeviceBtn.deviceId)stringValue]];
    }
}

#pragma mark - Actions

- (void)sureBtnClicked
{
    [self endEditing];
    NSInteger leftRow = [self.pickerView selectedRowInComponent:0];
    NSInteger rightRow = [self.pickerView selectedRowInComponent:1];
    NSString *time;
    if (isSelectedStart)
    {
        startSelLeftRow = leftRow;
        startSelRightRow = rightRow;
        [self.headView reback];
        self.startTimeStr = [self.startTimes[rightRow]date_right_str];
        ODStoreTimelineModel *dateModel = self.startDates[leftRow];
        self.dateStr = dateModel.date_left_str;
        time = [self.dateStr stringByAppendingString:self.startTimeStr];
        [self.headView.startTimeBtn setTitle:time forState:UIControlStateNormal];
    }
    else
    {
        self.endTimeStr = [self.endTimes[rightRow]date_right_str];
        time = [self.dateStr stringByAppendingString:self.endTimeStr];
        [self.headView.endTimeBtn setTitle:time forState:UIControlStateNormal];
        ODStoreTimelineModel *dateModel = self.startDates[startSelLeftRow];
        self.end_datetime = [[dateModel.date stringByAppendingString:@" "]stringByAppendingString:[self.endTimes[startSelRightRow]date_right_str]];
    }
}

- (void)headViewClicked:(ODPrecontrBtn *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            isSelectedStart = YES;
            self.start_dateTime = @"";
            [self showPicker];
        }
            break;
        case 1001:
        {
            if ([self.headView.startTimeBtn.currentTitle containsString:@"开始时间"])
            {
                [ODProgressHUD showInfoWithStatus:@"请先填写开始时间"];
                return;
            }
            isSelectedStart = NO;
            ODStoreTimelineModel *dateModel = self.startDates[startSelLeftRow];
            self.start_dateTime = [[dateModel.date stringByAppendingString:@" "]stringByAppendingString:[self.startTimes[startSelRightRow]date_right_str]];
            [self showPicker];
        }
            break;
        case 1002:
        {
            ODChoseCenterController *vc = [[ODChoseCenterController alloc] init];
            vc.storeCenterNameBlock = ^(NSString *name, NSString *storeId, NSInteger storeNumber)
            {
                self.storeId = storeId;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)showPicker
{
    __weakSelf
    [self requestStoreTimeline];
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.pickerBaseView.od_y = KScreenHeight - weakSelf.pickerHeadView.od_height - weakSelf.pickerView.od_height;
    }];
}

- (void)dismissPicker
{
    __weakSelf
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.pickerBaseView.od_y = KScreenHeight;
    }];
}

- (void)back
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"是否退出预约" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.delegate = self;
    [alter show];
}

- (void)endEditing
{
    [self.view endEditing:YES];
    [self dismissPicker];
}

@end

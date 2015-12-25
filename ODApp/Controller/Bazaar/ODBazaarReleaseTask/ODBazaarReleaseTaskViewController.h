//
//  ODBazaarReleaseTaskViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"

typedef enum {
    // 开始日期
    DateTypeOfStart = 0,
    // 结束日期
    DateTypeOfEnd,
}DateType;

@interface ODBazaarReleaseTaskViewController : ODBaseViewController<UITextViewDelegate>

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITextView *titleTextView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *taskDetailTextView;
@property(nonatomic,strong)UILabel *taskDetailLabel;
@property(nonatomic,strong)UILabel *startDateLabel;
@property(nonatomic,strong)UILabel *endDateLabel;
@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)UILabel *endTimeLabel;
@property(nonatomic,strong)UILabel *taskRewardLabel;

@property(nonatomic,strong)UIView *backPickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;

@end

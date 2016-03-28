//
//  ODBazaarRequestHelpViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//  求帮助界面

#import "ODBaseViewController.h"
#import "ODBazaarReleaseTaskViewController.h"
#import "ODBazaarLabelSearchViewController.h"
#import "ODBazaarDetailViewController.h"
#import "MJRefresh.h"
#import "ODPersonalCenterViewController.h"
#import "ODOthersInformationController.h"
#import "ODBazaaeExchangeSkillViewController.h"
#import "ODBazaarRequestHelpModel.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>

@interface ODBazaarRequestHelpViewController : ODBaseViewController

@property(nonatomic, copy) NSString *open_id;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIButton *screeningButton;
@property (nonatomic, copy) NSString *refresh;
@property (nonatomic, assign) NSInteger indexPath;

@end

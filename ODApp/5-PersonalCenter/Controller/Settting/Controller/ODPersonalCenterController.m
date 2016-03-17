//
//  ODPersonalCenterController.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPersonalCenterController.h"

#import "ODPersonalCenterHeaderView.h"

#import "ODUserInformation.h"

#import "ODInformationController.h"
#import "ODMyOrderRecordController.h"
#import "ODMyApplyActivityController.h"
#import "ODMyTopicController.h"
#import "ODMyTaskController.h"
#import "ODEvaluationController.h"
#import "ODBalanceController.h"
#import "ODGiveOpinionController.h"
#import "ODOperationController.h"
#import "ODPublicTool.h"

@interface ODPersonalCenterController ()

@property (nonatomic, weak) ODPersonalCenterHeaderView *headerView;

@end

@implementation ODPersonalCenterController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.headerView.user = [[ODUserInformation sharedODUserInformation] getUserCache];
    [self.tableView reloadData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化表格
    [self setupTableView];
    
    [self setupGroup];
}

#pragma mark - 初始化方法
/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人中心";
    self.tableView.rowHeight = 48;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6" alpha:1];
    
    // 调整tableView距离导航栏高度
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    // 创建头部视图
    ODPersonalCenterHeaderView *headerView = [ODPersonalCenterHeaderView headerView];
    headerView.od_height = 172;
    headerView.od_width = KScreenWidth;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    if (![ODUserInformation sharedODUserInformation].openID.length) return;
}

/**
 *  设置cell内容
 */
- (void)setupGroup
{
    // 获取缓存
    ODUserModel *user = [[ODUserInformation sharedODUserInformation] getUserCache];
    __weakSelf;
    
    ODArrowItem *item0 = [ODArrowItem itemWithName:@"我的中心预约"];
    item0.oprtionBlock = ^(NSIndexPath *index){
        ODMyOrderRecordController *vc = [[ODMyOrderRecordController alloc] init];
        vc.open_id = user.open_id;
        vc.isRefresh = YES;
        vc.centerTitle = @"我的预约纪录";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item1 = [ODArrowItem itemWithName:@"我报名的活动"];
    item1.oprtionBlock = ^(NSIndexPath *index){
        ODMyApplyActivityController *vc = [[ODMyApplyActivityController alloc] init];
        vc.isRefresh = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    ODArrowItem *item2 = [ODArrowItem itemWithName:@"我的话题"];
    item2.oprtionBlock = ^(NSIndexPath *index){
        ODMyTopicController *vc = [[ODMyTopicController alloc] init];
        vc.open_id = user.open_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item3 = [ODArrowItem itemWithName:@"我的任务"];
    item3.oprtionBlock = ^(NSIndexPath *index){
        ODMyTaskController *vc = [[ODMyTaskController alloc] init];
        vc.open_id = user.open_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item4 = [ODArrowItem itemWithName:@"我收到的评价"];
    item4.oprtionBlock = ^(NSIndexPath *index){
        ODEvaluationController *vc = [[ODEvaluationController alloc] init];
        vc.typeTitle = @"我收到的评价";
        NSString *openId = [ODUserInformation sharedODUserInformation].openID;
        vc.openId = openId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item5 = [ODArrowItem itemWithName:@"余额"];
    item5.oprtionBlock = ^(NSIndexPath *index){
        ODBalanceController *vc = [[ODBalanceController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item6 = [ODArrowItem itemWithName:@"设置"];
    item6.oprtionBlock = ^(NSIndexPath *index){
        ODOperationController *vc = [[ODOperationController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item7 = [ODArrowItem itemWithName:@"意见反馈"];
    item7.oprtionBlock = ^(NSIndexPath *index){
        ODGiveOpinionController *vc = [[ODGiveOpinionController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODSettingItem *item8 = [ODArrowItem itemWithName:@"分享我们的app"];
    item8.oprtionBlock = ^(NSIndexPath *index){
        [ODPublicTool shareAppWithTarget:weakSelf dictionary:(NSDictionary *)user.share controller:weakSelf];
    };
    
    ODGroupItem *group = [ODGroupItem groupWithItems:@[item0, item1, item2, item3,
                                                       item4, item5, item6, item7, item8]];
    
    [self.groups addObject:group];
}

@end

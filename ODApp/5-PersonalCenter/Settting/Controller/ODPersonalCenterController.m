//
//  ODPersonalCenterController.m
//  ODApp
//
//  Created by 王振航 on 16/3/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

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
#import "ODMyTakeOutViewController.h"
#import <Masonry.h>
#import "ODOtherConfigInfoＭodel.h"
#import "ODPublicWebViewController.h"
#import "ODUserBlacklistViewController.h"

@interface ODPersonalCenterController ()

@property (nonatomic, weak) ODPersonalCenterHeaderView *headerView;

@end

@implementation ODPersonalCenterController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self setupTableView];
    
//    ODUserModel *test = [[ODUserInformation sharedODUserInformation] getUserCache];
    
    if (![ODUserInformation sharedODUserInformation].openID.length) return;
    
    self.headerView.user = [[ODUserInformation sharedODUserInformation] getUserCache];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数据
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
    self.tableView.backgroundColor = [UIColor backgroundColor];
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, ODNavigationHeight, KScreenWidth, KScreenHeight - ODNavigationHeight);
    // 调整tableView距离导航栏高度
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 14, 0);
    
    // 创建头部视图
    ODOtherConfigInfoModel *config = [[ODUserInformation sharedODUserInformation] getConfigCache];
    ODPersonalCenterHeaderView *headerView = [ODPersonalCenterHeaderView headerView];
    
    if (config == nil || config.auditing == 1) {
        headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, 86);
        headerView.orderInfoView.hidden = YES;
        self.tableView.tableHeaderView = headerView;
        self.headerView = headerView;
    } else {
        headerView.orderInfoView.hidden = NO;
        self.tableView.tableHeaderView = headerView;
        self.headerView = headerView;
        headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, 172);
    }
    
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
    item2.destVc = [ODMyTopicController class];
    
    ODArrowItem *item3 = [ODArrowItem itemWithName:@"我的任务"];
    item3.destVc = [ODMyTaskController class];
    
    ODArrowItem *item4 = [ODArrowItem itemWithName:@"我收到的评价"];
    item4.oprtionBlock = ^(NSIndexPath *index){
        ODEvaluationController *vc = [[ODEvaluationController alloc] init];
        vc.typeTitle = @"我收到的评价";
        vc.openId = [NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].openID];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    ODArrowItem *item5 = [ODArrowItem itemWithName:@"余额"];
    item5.destVc = [ODBalanceController class];
    
    ODArrowItem *item6 = [ODArrowItem itemWithName:@"设置"];
    item6.destVc = [ODOperationController class];
    
    ODArrowItem *item7 = [ODArrowItem itemWithName:@"意见反馈"];
    item7.destVc = [ODGiveOpinionController class];
    
    ODArrowItem *item8 = [ODArrowItem itemWithName:@"分享我们的app"];
    // 设置cell背景颜色
    item8.colorType = ODSettingCellColorTypeYellow;
    item8.oprtionBlock = ^(NSIndexPath *index){
        [ODPublicTool shareAppWithTarget:weakSelf dictionary:(NSDictionary *)user.share controller:weakSelf];
    };
    
    // 找工作
    ODArrowItem *job = [ODArrowItem itemWithName:@"找工作"];
    job.oprtionBlock = ^(NSIndexPath *index){
        ODPublicWebViewController *vc = [[ODPublicWebViewController alloc] init];
        vc.navigationTitle = @"找工作";
        vc.isShowProgress = YES;
        NSString *store_id = @"2";
        vc.webUrl = [NSString stringWithFormat:@"%@?access_token=%@&store_id=%@&open_id=%@", ODWebUrlFindJob, [ODUserInformation sharedODUserInformation].openID, store_id, [ODUserInformation sharedODUserInformation].openID];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //用户黑名单
    ODArrowItem *blacklist = [ODArrowItem itemWithName:@"黑名单列表"];
    blacklist.oprtionBlock = ^(NSIndexPath *index){
        ODUserBlacklistViewController *vc = [[ODUserBlacklistViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    /**
     *  添加我的外卖
     */
    ODArrowItem *myTakeOut = [ODArrowItem itemWithName:@"我的外卖列表"];
    myTakeOut.destVc = [ODMyTakeOutViewController class];
    
    ODOtherConfigInfoModel *config = [[ODUserInformation sharedODUserInformation] getConfigCache];
    ODGroupItem *group = nil;
    if (config == nil || config.auditing == 1) {
        group = [ODGroupItem groupWithItems:@[job,item0, item1, item2, item6, item7,blacklist, item8]];
    } else {
        group = [ODGroupItem groupWithItems:@[myTakeOut, item0, item1, item2, item3, item4, item5, item6, item7,blacklist, item8]];
    }
    
    [self.groups addObject:group];
}

@end

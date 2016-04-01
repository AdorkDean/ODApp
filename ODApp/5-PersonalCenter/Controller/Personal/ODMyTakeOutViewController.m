//
//  ODMyTakeOutViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyTakeOutViewController.h"

#import "MJRefresh.h"
#import "ODMyTakeOutModel.h"
#import "ODTakeOutView.h"
#import "ODTakeAwayDetailController.h"
#import "ODExchangePayViewController.h"
#import "ODConfirmOrderViewController.h"

@interface ODMyTakeOutViewController () <UITableViewDataSource, UITableViewDelegate>

/** 表格 */
@property (nonatomic, strong) UITableView *tableView;

/** 页码 */
@property (nonatomic, assign) NSInteger pageCount;

/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

// 循环cell标识
static NSString * const ODTakeOutViewID = @"ODTakeOutViewID";

@implementation ODMyTakeOutViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.dataArray = [[NSMutableArray alloc] init];
    self.pageCount = 1;

    [self createRequestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY - 6, KScreenWidth, KControllerHeight - ODNavigationHeight + 6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODTakeOutView class]) bundle:nil] forCellReuseIdentifier:ODTakeOutViewID];
        [self.view addSubview:_tableView];
    
        __weakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
            weakSelf.pageCount = 1;
            [weakSelf createRequestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageCount++;
            [weakSelf createRequestData];
        }];
    }
    return _tableView;
}

#pragma mark - Get Request Data
- (void)createRequestData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"page"] = [NSString stringWithFormat:@"%ld", self.pageCount];
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutOrderList parameters:params modelClass:[ODMyTakeOutModel class] success:^(id model) {
        if (weakSelf.pageCount == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        NSArray *newDatas = [model result];
        [weakSelf.dataArray addObjectsFromArray:newDatas];
        
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:newDatas];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无订单"];
        }
        else {
            [weakSelf.noResultLabel hidden];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTakeOutView *cell = [tableView dequeueReusableCellWithIdentifier:ODTakeOutViewID];
    cell.model = self.dataArray[indexPath.row];
    [cell.enterButton addTarget:self action:@selector(payOrLookAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 150;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    // 点击方法
}

#pragma mark - Action
- (void)payOrLookAction:(UIButton *)sender {
    ODTakeOutView *cell = (ODTakeOutView *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ODMyTakeOutModel *model = self.dataArray[indexPath.row];
    
    ODTakeAwayDetailController *vc = [[ODTakeAwayDetailController alloc] init];
    vc.isOrderDetail = YES;
    vc.order_id = model.order_id;
    vc.takeAwayTitle = @"订单详情";
    [self.navigationController pushViewController:vc animated:YES];
}


@end

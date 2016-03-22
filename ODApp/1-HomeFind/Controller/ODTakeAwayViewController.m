//
//  ODTakeAwayViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//  定外卖

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODTakeAwayViewController.h"
#import <MJRefresh.h>

#import "ODTakeAwayModel.h"
#import "ODTakeAwayCell.h"
#import "ODTakeAwayHeaderView.h"

#import "NSString+ODExtension.h"

@interface ODTakeAwayViewController () <UITableViewDataSource, UITableViewDelegate>

/** 表格 */
@property (nonatomic, strong) UITableView *tableView;
/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic, assign) NSInteger page;

/** 模型数组 */
@property(nonatomic, strong) NSMutableArray *datas;

@end

@implementation ODTakeAwayViewController

#pragma mark - 懒加载
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

// 循环cell标识
static NSString * const exchangeCellId = @"takeAwayCell";

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化titleView
    [self setupTitleView];
    
    // 初始化表格
    [self setupTableView];
    
    // 初始化headerView
    [self setupHeaderView];
    
    // 初始化刷新控件
    [self setupRefresh];
}

#pragma mark - 初始化方法
/**
 *  初始化titleView
 */
- (void)setupTitleView
{
}

/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建表格
    CGRect frame = CGRectMake(0, 0, KScreenWidth, self.view.od_height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(163, 0, 0, 0);
    
    // 设置tableView的rowHeight
    tableView.rowHeight = 90;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODTakeAwayCell class]) bundle:nil] forCellReuseIdentifier:exchangeCellId];
}

/**
 *  初始化headerView
 */
- (void)setupHeaderView
{
    ODTakeAwayHeaderView *headerView = [ODTakeAwayHeaderView headerView];
    [headerView sizeToFit];
    [self.view addSubview:headerView];
}

/**
 *  设置刷新控件
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - UITableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.datas.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTakeAwayCell *cell = [tableView dequeueReusableCellWithIdentifier:exchangeCellId];
//    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 事件方法
- (void)loadNewUsers
{
    // 结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @"1";
    params[@"my"] = @"0";
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:@"" parameters:params modelClass:[ODTakeAwayModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        // 清空所有数据
        [weakSelf.datas removeAllObjects];
        
        NSArray *newDatas = [model result];
        [weakSelf.datas addObjectsFromArray:newDatas];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf checkFooterState:newDatas.count];
        
        // 重新设置 page = 1
        weakSelf.page = 1;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreUsers
{
    // 结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    // 取出页码
    NSInteger page = self.page + 1;
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%@", @(page)];
    params[@"my"] = @"0";
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:@"" parameters:params modelClass:[ODTakeAwayModel class] success:^(id model) {
        if (weakSelf.params != params) return;
        NSArray *array = [model result];
        [weakSelf.datas addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
        [weakSelf checkFooterState:array.count];
        
        // 请求成功后才赋值页码
        weakSelf.page = page;
    } failure:^(NSError *error) {
        if (weakSelf.params != params) return;
        weakSelf.page = weakSelf.page - 1;
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState:(NSUInteger)count
{
    if (count < 20) { // 全部数据已经加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        [self.tableView.mj_footer endRefreshing];
    }
}



@end

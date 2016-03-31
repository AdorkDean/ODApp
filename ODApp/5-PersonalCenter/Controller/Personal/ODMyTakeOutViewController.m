//
//  ODMyTakeOutViewController.m
//  ODApp
//
//  Created by 王振航 on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyTakeOutViewController.h"

#import <MJRefresh.h>
#import "ODTakeOutCell.h"
#import "ODMyTakeOutModel.h"

@interface ODMyTakeOutViewController () <UITableViewDataSource, UITableViewDelegate>

/** 表格 */
@property (nonatomic, weak) UITableView *tableView;

/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *datas;

@end

// 循环cell标识
static NSString * const myTakeOutCellId = @"ODMyTakeOutViewCell";

@implementation ODMyTakeOutViewController

#pragma mark - 懒加载
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    // 初始化刷新控件
    [self setupRefresh];
}

#pragma mark - 初始化方法
/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.navigationItem.title = @"我的外卖";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;

    self.page = 1;
    // rowHeight
    tableView.rowHeight = 90;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODTakeOutCell class]) bundle:nil] forCellReuseIdentifier:myTakeOutCellId];
}

/**
 *  设置刷新控件
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTakeOuts)];
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTakeOuts)];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark - UITableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODTakeOutCell *cell = [tableView dequeueReusableCellWithIdentifier:myTakeOutCellId];
    cell.datas = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    // 点击方法
}

#pragma mark - 事件方法
- (void)loadNewTakeOuts
{
    // 结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @"1";
    params[@"page"] = [NSString stringWithFormat:@"%ld", self.page];
    params[@"open_id"] = @"766148455eed214ed1f8";
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlTakeOutOrderList parameters:params modelClass:[ODMyTakeOutModel class] success:^(id model) {
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

- (void)loadMoreTakeOuts
{
    // 结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    // 取出页码
    NSInteger currentPage = self.page;
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:@"" parameters:params modelClass:[NSObject class] success:^(id model) {
        if (weakSelf.params != params) return;
        NSArray *moreTakeOuts = [model result];
        [weakSelf.datas addObjectsFromArray:moreTakeOuts];
        [weakSelf.tableView reloadData];
        [weakSelf checkFooterState:moreTakeOuts.count];
        // 请求成功后才赋值页码
        weakSelf.page = currentPage;
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

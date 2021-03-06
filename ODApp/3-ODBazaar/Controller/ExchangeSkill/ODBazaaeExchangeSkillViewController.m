//
//  ODBazaaeExchangeSkillViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaaeExchangeSkillViewController.h"
#import "ODBazaarExchangeSkillCell.h"
 
#import <MJRefresh.h>
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODBazaarExchangeSkillModel.h"

@interface ODBazaaeExchangeSkillViewController () <UITableViewDataSource, UITableViewDelegate>

/** 表格 */
@property (nonatomic, weak) UITableView *tableView;
/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 页码 */
@property (nonatomic, assign) NSInteger page;

@end

// 循环cell标识
static NSString * const exchangeCellId = @"ODBazaaeExchangeSkillViewCell";

@implementation ODBazaaeExchangeSkillViewController

#pragma mark - LazyLoad
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 接收通知
    [self addObserver];
    
    // 初始化TableView
    [self setupTableView];
    
    // 初始化刷新控件
    [self setupRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
/**
 *  接收通知
 */
- (void)addObserver
{
    __weakSelf;
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationReleaseSkill object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}
/**
 *  初始化表格
 */
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建表格
    CGRect frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - ODNavigationHeight - ODBazaaeExchangeNavHeight - ODTabBarHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor backgroundColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 300;
    // 取消分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarExchangeSkillCell class]) bundle:nil] forCellReuseIdentifier:exchangeCellId];
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

#pragma mark - IBActions
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
    [ODHttpTool getWithURL:ODUrlSwapList parameters:params modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (weakSelf.params != params) return;
        // 清空所有数据
        [weakSelf.dataArray removeAllObjects];
        
        NSArray *newUsers = [model result];
        [weakSelf.dataArray addObjectsFromArray:newUsers];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf checkFooterState:newUsers.count];
        
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
    [ODHttpTool getWithURL:ODUrlSwapList parameters:params modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (weakSelf.params != params) return;
        NSArray *array = [model result];
        [weakSelf.dataArray addObjectsFromArray:array];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:exchangeCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%ld", model.swap_id];
    detailControler.nick = model.user.nick;
    [self.navigationController pushViewController:detailControler animated:YES];
}

@end

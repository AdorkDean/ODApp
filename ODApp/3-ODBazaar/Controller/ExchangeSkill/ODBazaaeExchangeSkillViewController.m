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

#import "MJRefresh.h"
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODBazaarExchangeSkillModel.h"

// 循环cell标识
static NSString * const exchangeCellId = @"exchangeCell";

// 选中的cell
#define ODSelectedUsers self.dataArray[self.tableView.indexPathForSelectedRow.row]

@interface ODBazaaeExchangeSkillViewController () <UITableViewDataSource, UITableViewDelegate>

/** 表格 */
@property (nonatomic, strong) UITableView *tableView;

/** 参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation ODBazaaeExchangeSkillViewController

#pragma mark - 懒加载
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
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
 *  初始化表格
 */
- (void)setupTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - ODNavigationHeight - ODBazaaeExchangeNavHeight - ODTabBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
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
}

#pragma mark - UITableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 判断是否显示footer
    NSUInteger count = self.dataArray.count;
    self.tableView.mj_footer.hidden = (count == 0);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:exchangeCellId];
    cell.model = self.dataArray[indexPath.row];
    cell.dataArray = self.dataArray;
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 停止刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    // 点击后取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%d", model.swap_id];
    detailControler.nick = model.user.nick;
    [self.navigationController pushViewController:detailControler animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    return model.rowHeight;
}

#pragma mark - 事件方法
- (void)loadNewUsers
{
    // 结束上拉加载
    [self.tableView.mj_footer endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%@", @(self.page)];
    params[@"my"] = @"0";
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapList parameters:params modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (self.params != params) return;
        // 清空所有数据
        [weakSelf.dataArray removeAllObjects];
        
        NSArray *newDatas = [model result];
        [weakSelf.dataArray addObjectsFromArray:newDatas];
        
        // 重新设置page = 1
        self.page = 1;
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        if (self.params != params) return;
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreUsers
{
    // 取出页码
    NSInteger page = self.page + 1;
    
    // 结束下拉刷新
    [self.tableView.mj_header endRefreshing];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%@", @(self.page)];
    params[@"my"] = @"0";
    self.params = params;
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapList parameters:params modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (self.params != params) return;
        NSArray *array = [model result];
        [weakSelf.dataArray addObjectsFromArray:array];
        
        // 请求成功后才赋值页码
        weakSelf.page = page;
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        if (self.params != params) return;
        self.page = self.page - 1;
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

/**
 *  时刻监测footer的状态
 */
- (void)checkFooterState
{
    ODBazaarExchangeSkillModel *model = ODSelectedUsers;
    // 判断是否隐藏footer
//    BOOL result = (model.users.count == category.total);
//    self.userTableView.mj_footer.hidden = result;
//    if (!result) [self.userTableView.mj_footer endRefreshing];
}

@end

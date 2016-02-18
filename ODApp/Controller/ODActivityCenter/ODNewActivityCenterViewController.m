//
//  ODNewActivityCenterViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "mjrefresh.h"
#import "ODActivitylistModel.h"
#import "ODNewActivityCell.h"
#import "ODNewActivityCenterViewController.h"
#import "ODNewActivityDetailViewController.h"
#import "ODActivityDetailViewController.h"

@interface ODNewActivityCenterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  从服务器获取到的数据
 */
@property (nonatomic, strong) NSArray *resultLists;
@end

@implementation ODNewActivityCenterViewController

static NSString * const cellId = @"newActivityCell";

#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODTabBarHeight - ODNavigationHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODNewActivityCell class]) bundle:nil] forCellReuseIdentifier:cellId];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        tableView.rowHeight = 98;
        [self.view addSubview:tableView];
       _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"中心活动";
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:ODNotificationActivityApllySuccess object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)requestData
{
    __weakSelf
    NSDictionary *parameter = @{@"city_id":@"1"};
    [ODHttpTool getWithURL:KActivityListUrl parameters:parameter modelClass:[ODActivityListModel class] success:^(id json)
    {
        weakSelf.resultLists = [json result];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }
                   failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.resultLists[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewActivityDetailViewController *detailViewController = [[ODNewActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.acitityId = [self.resultLists[indexPath.row]activity_id];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end

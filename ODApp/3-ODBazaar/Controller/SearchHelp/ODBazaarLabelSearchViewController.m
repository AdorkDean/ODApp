//
//  ODBazaarLabelSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarLabelSearchViewController.h"
#import "ODBazaarHelpCell.h"
#import "MJRefresh.h"
#import "ODBazaarModel.h"
#import "ODBazaarDetailViewController.h"
#import "ODBazaarRequestHelpModel.h"

@interface ODBazaarLabelSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic) NSInteger count;
@property(nonatomic, strong) UILabel *noReusltLabel;

@end

static NSString * const cellId = @"ODBazaarHelpCell";

@implementation ODBazaarLabelSearchViewController

#pragma mark - lazyLoad
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 8, kScreenSize.width - 20, 30)];
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"标签关键字";
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, kScreenSize.width, kScreenSize.height - 64- 46) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 估算tableView高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 300;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
        // 取消分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarHelpCell class]) bundle:nil] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"集市";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
    [self searchBar];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length > 0) {
            weakSelf.count = 1;
            [weakSelf requestData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 请求数据
-(void)requestData{
    __weakSelf;
    [self.searchBar resignFirstResponder];
    NSDictionary *parameter = @{@"search" : self.searchBar.text, @"task_status" : @"9", @"page" : [NSString stringWithFormat:@"%ld", self.count]};
    
    [ODHttpTool getWithURL:ODUrlTaskList parameters:parameter modelClass:[ODBazaarRequestHelpModel class] success:^(ODBazaarRequestHelpModelResponse  *model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        [weakSelf.tableView reloadData];
        ODBazaarRequestHelpModel *helpModel = [model result];
        for (ODBazaarRequestHelpTasksModel *taskModel in helpModel.tasks) {
            [weakSelf.dataArray addObject:taskModel];
        }
      
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[[model result] tasks]];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"没有符合条件的任务"];
        }else {
            [weakSelf.noResultLabel hidden];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    self.count++;
    [self requestData];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
    ODBazaarRequestHelpTasksModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%ld", model.task_id];
    bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
    bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - action
- (void)confirmButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length > 0) {
        [self.tableView.mj_header beginRefreshing];
    } else {
        [ODProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
}


@end

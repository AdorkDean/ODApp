//
//  ODMyReplyTopicViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/3/25.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODMyReplyTopicViewController.h"
#import "ODCommunityCell.h"
#import "ODCommunityBbsModel.h"
#import "ODCommunityDetailViewController.h"
#import "ODOthersInformationController.h"
#import "MJRefresh.h"

@interface ODMyReplyTopicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic ,strong) NSMutableDictionary *userInfoDic;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic) NSInteger count;
@property(nonatomic, copy) NSString *refresh;

@end

@implementation ODMyReplyTopicViewController

#pragma mark - lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 4)];
        view.backgroundColor = [UIColor backgroundColor];
        _tableView.tableHeaderView = view;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor backgroundColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ODCommunityCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 300;;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableDictionary *)userInfoDic
{
    if (!_userInfoDic) {
        _userInfoDic = [[NSMutableDictionary alloc]init];
    }
    return _userInfoDic;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.count = 1;
    [self requestData];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 请求数据
-(void)requestData{
    __weakSelf
    NSDictionary *parameter = @{@"type":@"2",@"page":[NSString stringWithFormat:@"%ld",(long)self.count],@"call_array":@"1"};
    [ODHttpTool getWithURL:ODUrlBbsList parameters:parameter modelClass:[ODCommunityBbsModel class] success:^(id model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        ODCommunityBbsModel *bbsModel = [model result];
        for (ODCommunityBbsListModel *listModel in bbsModel.bbs_list) {
            [weakSelf.dataArray addObject:listModel];
        }
        NSDictionary *users = bbsModel.users;
        for (id userKey in users) {
            NSString *key = [NSString stringWithFormat:@"%@",userKey];
            ODCommunityBbsUsersModel *userModel = [ODCommunityBbsUsersModel mj_objectWithKeyValues:users[key]];
            [weakSelf.userInfoDic setObject:userModel forKey:userKey];
        }
        [weakSelf.tableView reloadData];
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[[model result] bbs_list]];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无话题"];
        }else {
            [weakSelf.noResultLabel hidden];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 加载更多
-(void)loadMoreData{
    self.count ++;
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
    ODCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model dict:self.userInfoDic index:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc] init];
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%d", model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

@end

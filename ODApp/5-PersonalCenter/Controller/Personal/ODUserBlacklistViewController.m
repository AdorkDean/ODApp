//
//  ODUserBlacklistViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/4/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODUserBlacklistViewController.h"
#import "ODUserBlackListCell.h"
#import "ODBlacklistModel.h"
#import <MJRefresh.h>

@interface ODUserBlacklistViewController ()<UITableViewDelegate,UITableViewDataSource, ODUserBlackListCellDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;

@end

static NSString *cellId = @"ODUserBlackListCell";

@implementation ODUserBlacklistViewController

#pragma mark - lazyload
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 86;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, -ODBazaaeExchangeCellMargin, 0);
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ODUserBlackListCell class] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 数据请求
- (void)requestData{
    __weakSelf
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [ODHttpTool getWithURL:ODUrlUserReject parameters:params modelClass:[ODBlacklistModel class] success:^(ODBlacklistModelResponse *model) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[model result]];
        
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:weakSelf.dataArray];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无黑名单记录"];
        }
        else {
            [weakSelf.noResultLabel hidden];
        }
    } failure:^(NSError *error) {
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ODUserBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.dataArray [indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - ODUserBlackListCellDelegate
- (void)userBlackListCellDidClickBlackListButton:(ODUserBlackListCell *)cell{
    [self.tableView.mj_header beginRefreshing];
}

@end

//
//  ODCollectionController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCollectionController.h"
#import "ODCollectionCell.h"
#import "MJRefresh.h"
#import "ODOthersInformationController.h"

#import "ODApplyListCell.h"
#import "ODLoveListModel.h"

NSString *const ODApplyList1CellID = @"ODApplyList1CellID";

@interface ODCollectionController () <UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ODCollectionController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    self.navigationItem.title = @"TA们收藏过";
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 68;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODApplyListCell class]) bundle:nil] forCellReuseIdentifier:ODApplyList1CellID];
        [self.view addSubview:_tableView];
        
        __weakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf DownRefresh];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf LoadMoreData];
        }];
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)getData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.page];

    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"swap_id"] = self.swap_id;
    params[@"page"] = countNumber;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapLoveList parameters:params modelClass:[ODLoveListModel class] success:^(id model)
    {
        NSArray *loveListDatas = [model result];
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        for (id loves in loveListDatas) {
            [weakSelf.dataArray addObject:loves];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        if (!loveListDatas.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
    }
    failure:^(NSError *error) {
       [weakSelf.tableView.mj_header endRefreshing];
       [weakSelf.tableView.mj_footer endRefreshing];
       [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODApplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:ODApplyList1CellID];
    ODLoveListModel *model = self.dataArray[indexPath.row];
    [cell setWithLikeModel:model];
    return cell;
}

#pragma mark - UITabelViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    ODLoveListModel *model = self.dataArray[indexPath.row];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    if ([openId isEqualToString:model.open_id]) {;
    }
    else {
        vc.open_id = model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 监听方法
- (void)DownRefresh {
    self.page = 1;
    [self getData];
}


- (void)LoadMoreData {
    self.page++;
    [self getData];
}


@end

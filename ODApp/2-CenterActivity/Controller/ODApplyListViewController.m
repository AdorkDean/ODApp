//
//  ODApplyListViewController.m
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODApplyListViewController.h"
#import "MJRefresh.h"
#import "ODOthersInformationController.h"
#import "ODApplyModel.h"
#import "ODApplyListCell.h"
NSString *const ODApplyListCellID = @"ODApplyListCellID";

@interface ODApplyListViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, copy) NSString *open_id;

@end

@implementation ODApplyListViewController

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

    self.open_id = [ODUserInformation sharedODUserInformation].openID;

    self.page = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];

    self.navigationItem.title = @"TA们申请过";
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 68;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODApplyListCell class]) bundle:nil] forCellReuseIdentifier:ODApplyListCellID];
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
    params[@"activity_id"] = self.activity_id;
    params[@"page"] = countNumber;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlStoreApplyUsers parameters:params modelClass:[ODApplyModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.dataArray removeAllObjects];
         }
         
         NSArray *applyDatas = [model result];
        [weakSelf.dataArray addObjectsFromArray:applyDatas];
         
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:applyDatas];
         
     } failure:^(NSError *error) {
         [weakSelf.tableView.mj_header endRefreshing];
         [weakSelf.tableView.mj_footer endRefreshing];
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODApplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:ODApplyListCellID];
    ODApplyModel *model = self.dataArray[indexPath.row];
    [cell setWithApplyModel:model];
    return cell;
}

#pragma mark - UITablaViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    ODLoveListModel *model = self.dataArray[indexPath.row];
    vc.open_id = model.open_id;
    if (![vc.open_id isEqualToString:[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].openID]]) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 事件方法
- (void)DownRefresh {
    self.page = 1;
    [self getData];
}
- (void)LoadMoreData {
    self.page++;
    [self getData];
}

@end

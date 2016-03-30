//
//  ODPersonalCenterCollectionController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODBazaarExchangeSkillModel.h"
#import "UIImageView+WebCache.h"
#import "ODHelp.h"
#import "ODCommunityShowPicViewController.h"
#import "MJRefresh.h"
#import "ODPersonalCenterCollectionController.h"
#import "ODBazaarExchangeSkillCollectionCell.h"

@interface ODPersonalCenterCollectionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

// 数据数组
@property(nonatomic, strong) NSMutableArray *dataArray;

// 数据页数
@property(nonatomic) NSInteger page;

@end

NSString *const cellID = @"ODBazaarExchangeSkillCell";

@implementation ODPersonalCenterCollectionController

#pragma mark - lazyLoad
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight + 6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 300;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODBazaarExchangeSkillCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的收藏";
    [self requestData];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
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

#pragma mark - 数据请求
-(void)requestData{
    NSDictionary *parameter = @{@"type" : @"4",
                                @"page" : [NSString stringWithFormat:@"%ld", (long)self.page]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserLoveList parameters:parameter modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        NSArray *array = model.result;
        [weakSelf.dataArray addObjectsFromArray:array];
        
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[model result]];
        if (weakSelf.dataArray.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无收藏"];
        }else {
            [weakSelf.noResultLabel hidden];
        }        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}

- (void)loadMoreData {
    self.page++;
    [self requestData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%ld", model.swap_id];
    detailControler.nick = model.user.nick;
    [self.navigationController pushViewController:detailControler animated:YES];
}


@end

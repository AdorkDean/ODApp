//
//  ODMyApplyActivityController.m
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODActivityListModel.h"
#import "ODNewActivityCell.h"
#import "ODPersonalCenterViewController.h"
#import "ODMyApplyActivityController.h"

@interface ODMyApplyActivityController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

/**
 *  从服务器获取到的数据
 */
@property(nonatomic, strong) NSMutableArray *resultLists;
@end

@implementation ODMyApplyActivityController

static NSString *const cellId = @"newActivityCell";

#pragma mark - lazyLoad

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODNewActivityCell class]) bundle:nil] forCellReuseIdentifier:cellId];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        tableView.rowHeight = 98;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)resultLists {
    if (!_resultLists) {
        _resultLists = [NSMutableArray array];
    }
    return _resultLists;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我报名的活动";

    self.pageCount = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isRefresh) {
        [self.tableView.mj_header beginRefreshing];
        self.isRefresh = NO;
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

#pragma mark - request

- (void)loadMoreData {
    self.pageCount++;
    [self requestData];
}

- (void)requestData {
    NSDictionary *parameter = @{@"type" : @"0", @"page" : [NSString stringWithFormat:@"%i", self.pageCount]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreApplyMy parameters:parameter modelClass:[ODActivityListModel class] success:^(id model)
    {
        
        for (ODActivityListModel *md in [model result])
        {
            if (![[weakSelf.resultLists valueForKeyPath:@"activity_id"]containsObject:@(md.activity_id)])
            {
                [weakSelf.resultLists addObject:md];
            }
        }
        
        [ODHttpTool od_endRefreshWith:weakSelf.tableView array:[model result]];
        
        
        if (weakSelf.resultLists.count == 0) {
            [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无活动"];
        }
        else {
            [weakSelf.noResultLabel hidden];
        }        
    }
                   failure:^(NSError *error)
    {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODNewActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.resultLists[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([ODUserInformation sharedODUserInformation].openID.length) {
        ODNewActivityDetailViewController *detailViewController = [[ODNewActivityDetailViewController alloc] initWithNibName:nil bundle:nil];
        ODActivityListModel *model = self.resultLists[indexPath.row];
        detailViewController.acitityId = [model activity_id];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            ODPersonalCenterViewController *perV = [[ODPersonalCenterViewController alloc] init];
            [self presentViewController:perV animated:YES completion:nil];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end

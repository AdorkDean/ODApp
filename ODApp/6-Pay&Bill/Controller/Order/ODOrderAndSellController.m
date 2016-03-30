//
//  ODMySellController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOrderAndSellController.h"
#import "MJRefresh.h"

#import "ODOrderAndSellDetailController.h"
#import "ODMySellModel.h"
#import "ODOrderAndSellView.h"

NSString *const ODOrderAndSellViewID = @"ODOrderAndSellViewID";
@interface ODOrderAndSellController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, assign) NSInteger indexRow;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ODOrderAndSellController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getRequestData];
    
    if (self.isSell) {
        self.navigationItem.title = @"已卖出";
    }
    else {
        self.navigationItem.title = @"已购买";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationOrderListRefresh object:nil];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isRefresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - Lazy Load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight + 6) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 120;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODOrderAndSellView class]) bundle:nil] forCellReuseIdentifier:ODOrderAndSellViewID];
        [self.view addSubview:_tableView];
        
        __weakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
            weakSelf.page = 1;
            [weakSelf getRequestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^ {
            weakSelf.page++;
            [weakSelf getRequestData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - Load Data Request

- (void)getRequestData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.page];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = countNumber;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求

    NSObject *orderAndSellModel;
    NSString *orderAndSellUrl;
    if (self.isSell) {
        ODMySellModel *model = [[ODMySellModel alloc] init];
        orderAndSellModel = model;
        orderAndSellUrl = ODUrlSwapSellerOrderList;
    }
    else {
        ODMyOrderModel *model = [[ODMyOrderModel alloc] init];
        orderAndSellModel = model;
        orderAndSellUrl = ODUrlSwapOrderList;
    }
    
    [ODHttpTool getWithURL:orderAndSellUrl parameters:params modelClass:[orderAndSellModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.dataArray removeAllObjects];
         }         
         NSArray *mySellDatas = [model result];
         [weakSelf.dataArray addObjectsFromArray:mySellDatas];
         
         [ODHttpTool od_endRefreshWith:weakSelf.tableView array:mySellDatas];
         
         if (weakSelf.dataArray.count == 0) {
             [weakSelf.noResultLabel showOnSuperView:weakSelf.tableView title:@"暂无订单"];
         }
         else {
             [weakSelf.noResultLabel hidden];
         }
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODOrderAndSellView *cell = [tableView dequeueReusableCellWithIdentifier:ODOrderAndSellViewID];
    if (self.isSell) {
        ODMySellModel *model = self.dataArray[indexPath.row];
        [cell dealWithSellModel:model];
    }
    else {
        ODMyOrderModel *model = self.dataArray[indexPath.row];
        [cell dealWithBuyModel:model];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.indexRow = indexPath.row;
    
    ODOrderAndSellDetailController *vc = [[ODOrderAndSellDetailController alloc] init];
    
    if (self.isSell) {
        ODMySellModel *model = self.dataArray[indexPath.row];
        vc.order_id = [NSString stringWithFormat:@"%@", model.order_id];
        vc.orderStatus = [NSString stringWithFormat:@"%@", model.order_status];
        vc.isSellDetail = YES;
    }else {
        ODMyOrderModel *model = self.dataArray[indexPath.row];
        vc.order_id = [NSString stringWithFormat:@"%@", model.order_id];
        vc.orderStatus = [NSString stringWithFormat:@"%@", model.order_status];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)reloadData:(NSNotification *)text {
    
    ODMySellModel *model = self.dataArray[self.indexRow];
    model.order_status = [NSString stringWithFormat:@"%@", text.userInfo[@"order_status"]];
    [self.dataArray replaceObjectAtIndex:self.indexRow withObject:model];
    [self.tableView reloadData];
    
}

#pragma mark - Remove Notification
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

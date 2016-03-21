//
//  ODMyOrderRecordController.m
//  ODApp
//
//  Created by Bracelet on 16/1/8.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyOrderRecordController.h"
#import "ODUserInformation.h"

#import "ODMyOrderRecordView.h"

#define kMyOrderRecordCellId @"ODMyOrderRecordCell"

NSString *const ODMyOrderRecordViewID = @"ODMyOrderRecordViewID";

@interface ODMyOrderRecordController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) ODMyOrderRecordView *orderRecordCell;


// 列表数组
@property(nonatomic, strong) NSMutableArray *orderArray;

// 数据页数
@property(nonatomic, assign) NSInteger count;

// 记录点击了哪一行
@property (nonatomic, assign) long cancelOrderRow;


@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ODMyOrderRecordController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.centerTitle;
    self.count = 1;
    self.orderArray = [[NSMutableArray alloc] init];    

    [self createRequest];
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^ {
        weakSelf.count = 1;
        [weakSelf createRequest];
                                     }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^ {
        weakSelf.count ++;
         [weakSelf createRequest];
                                     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationCancelOrder object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefresh) {
        [self.tableView.mj_header beginRefreshing];
        self.isRefresh = NO;
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}



#pragma mark - 加载数据请求
- (void)createRequest {
    
    NSDictionary *parameter = @{@"open_id":[NSString stringWithFormat:@"%@",self.open_id],@"page":[NSString stringWithFormat:@"%ld",(long)self.count]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlStoreOrders parameters:parameter modelClass:[ODMyOrderRecordModel class] success:^(id model) {
        for (ODMyOrderRecordModel *orderModel in [model result]) {
            if (![[weakSelf.orderArray valueForKey:@"order_id"] containsObject:[orderModel order_id]]) {
                [weakSelf.orderArray addObject:orderModel];
            }
        }
        [weakSelf.tableView.mj_header endRefreshing];        
        if ([[model result] count] == 0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        [weakSelf.tableView reloadData];
        
        ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
        if (weakSelf.orderArray.count == 0) {
            [noResultabel showOnSuperView:weakSelf.tableView title:@"暂无预约"];
        }
        else {
            [noResultabel hidden];
        }
    
    }
    failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];  
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(4, ODTopY  , kScreenSize.width - 8, KControllerHeight - ODNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODMyOrderRecordView class]) bundle:nil] forCellReuseIdentifier:ODMyOrderRecordViewID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODMyOrderRecordView *cell = [tableView dequeueReusableCellWithIdentifier:ODMyOrderRecordViewID];
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    [cell showDatawithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODMyOrderDetailController *vc = [[ODMyOrderDetailController alloc] init];
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    self.cancelOrderRow = indexPath.row;
    vc.isOther = self.isOther;
    vc.open_id = self.open_id;
    vc.order_id = [NSString stringWithFormat:@"%@",model.order_id];
    
    [self.navigationController pushViewController:vc animated:YES];
    vc.status_str = [self.orderArray[indexPath.row] status_str];
}

#pragma mark - Action

- (void)reloadData:(NSNotification *)text {
    @try {
        ODMyOrderRecordModel *model = self.orderArray[self.cancelOrderRow];
        model.status_str = [NSString stringWithFormat:@"%@", text.userInfo[@"status_str"]];
        [self.orderArray replaceObjectAtIndex:self.cancelOrderRow withObject:model];
        [self.tableView reloadData];
    }
    @catch (NSException *exception) {
        
    }
}
#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

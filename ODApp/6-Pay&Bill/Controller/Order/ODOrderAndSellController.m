//
//  ODMySellController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOrderAndSellController.h"
#import "ODMySellModel.h"
#import "MJRefresh.h"
#import "ODMyOrderCell.h"
#import "ODMySellDetailController.h"
#import "ODSecondMySellDetailController.h"

#import "ODBuyOrderDetailController.h"

#import "ODOrderAndSellView.h"

NSString *const ODOrderAndSellViewID = @"ODOrderAndSellViewID";
@interface ODOrderAndSellController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, assign) NSInteger indexRow;

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ODOrderAndSellController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationSellOrderSecondRefresh object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationOrderListRefresh object:nil];
    
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    [self createRequestData];
    
    
    self.navigationItem.title = @"已卖出";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isRefresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadData:(NSNotification *)text {
    
    ODMySellModel *model = self.dataArray[self.indexRow];
    model.order_status = [NSString stringWithFormat:@"%@", text.userInfo[@"order_status"]];
    [self.dataArray replaceObjectAtIndex:self.indexRow withObject:model];
    [self.collectionView reloadData];
    
}

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
            [weakSelf createRequestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^ {
            weakSelf.page++;
            [weakSelf createRequestData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 获取数据
- (void)createRequestData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.page];
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = countNumber;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapSellerOrderList parameters:params modelClass:[ODMySellModel class] success:^(id model)
     {
         if ([countNumber isEqualToString:@"1"]) {
             [weakSelf.dataArray removeAllObjects];
         }
         
         NSArray *mySellDatas = [model result];
         [weakSelf.dataArray addObjectsFromArray:mySellDatas];
         
         ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
         
         [ODHttpTool OD_endRefreshWith:weakSelf.collectionView array:mySellDatas];
         
         if (weakSelf.dataArray.count == 0) {
             [noResultabel showOnSuperView:weakSelf.collectionView title:@"暂无订单"];
         }
         else {
             [noResultabel hidden];
         }
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark - UICollectionView 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODMyOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    ODMySellModel *model = self.dataArray[indexPath.row];
    
    [cell dealWithSellModel:model];
    
    
    return cell;
}

#pragma mark - UICollectionView 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ODMyOrderModel *model = self.dataArray[indexPath.row];
    
    NSString *orderId = [NSString stringWithFormat:@"%@", model.order_id];
    NSString *orderStatus = [NSString stringWithFormat:@"%@", model.order_status];
    
    self.indexRow = indexPath.row;
    
    
    ODBuyOrderDetailController *vc = [[ODBuyOrderDetailController alloc] init];
    vc.orderType = model.status_str;
    vc.order_id = orderId;
    vc.orderStatus = orderStatus;
    vc.isSellDetail = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, 126);
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
}

@end

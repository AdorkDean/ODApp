//
//  ODMyOrderController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMyOrderController.h"
#import "ODMyOrderModel.h"
#import "MJRefresh.h"
#import "ODMyOrderCell.h"
#import "ODOrderDetailController.h"
#import "ODSecondOrderDetailController.h"


#import "ODBuyOrderDetailController.h"

@interface ODMyOrderController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, assign) NSInteger indexRow;

@end

@implementation ODMyOrderController

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationMyOrderSecondRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationOrderListRefresh object:nil];
    
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isRefresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.page = 1;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];
    self.navigationItem.title = @"已购买订单";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf DownRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf LoadMoreData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODMyOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 获取数据
- (void)getData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.page];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = countNumber;
    params[@"open_id"] = self.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapOrderList parameters:params modelClass:[ODMyOrderModel class] success:^(id model)
    {
        NSArray *orderDatas = [model result];
        if ([countNumber isEqualToString:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
        }
        [weakSelf.dataArray addObjectsFromArray:orderDatas];
        
        [ODHttpTool OD_endRefreshWith:weakSelf.collectionView array:orderDatas];
        
        ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
        if (weakSelf.dataArray.count == 0) {
            [noResultabel showOnSuperView:weakSelf.collectionView title:@"暂无订单"];
        }
        else {
            [noResultabel hidden];
        }
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
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
    
    ODMyOrderModel *model = self.dataArray[indexPath.row];
    
    [cell dealWithBuyModel:model];
    
    
    return cell;
}

#pragma mark - UICollectionView 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ODMyOrderModel *model = self.dataArray[indexPath.row];
    
    NSString *orderStatus = [NSString stringWithFormat:@"%@", model.order_status];
    
    
    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    
    self.indexRow = indexPath.row;
    
    
    ODBuyOrderDetailController *vc = [[ODBuyOrderDetailController alloc] init];

    vc.order_id = [NSString stringWithFormat:@"%@", model.order_id];
    vc.orderType = model.status_str;
    vc.orderStatus = orderStatus;
    [self.navigationController pushViewController:vc animated:YES];
    
    __weakSelf
    vc.getRefresh = ^(NSString *isRefresh) {
        
        weakSelf.isRefresh = isRefresh;
    };
    
    
//    if ([swap_type isEqualToString:@"1"]) {
//        ODSecondOrderDetailController *vc = [[ODSecondOrderDetailController alloc] init];
//        vc.order_id = [NSString stringWithFormat:@"%@", model.order_id];
//        vc.orderType = model.status_str;
//        vc.orderStatus = orderStatus;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        __weakSelf
//        vc.getRefresh = ^(NSString *isRefresh) {
//            
//            
//            weakSelf.isRefresh = isRefresh;
//        };
//        
//    } else {
//        
//        
//        
//        ODOrderDetailController *vc = [[ODOrderDetailController alloc] init];
//        vc.order_id = [NSString stringWithFormat:@"%@", model.order_id];
//        vc.orderType = model.status_str;
//        vc.orderStatus = orderStatus;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        __weakSelf
//        vc.getRefresh = ^(NSString *isRefresh) {
//            
//            weakSelf.isRefresh = isRefresh;
//        };
//    }
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, 120);
}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 6;
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

- (void)refresh:(NSNotification *)text {
    [self.collectionView.mj_header beginRefreshing];
}
- (void)reloadData:(NSNotification *)text {
    
    ODMyOrderModel *model = self.dataArray[self.indexRow];
    model.order_status = [NSString stringWithFormat:@"%@", text.userInfo[@"order_status"]];
    [self.dataArray replaceObjectAtIndex:self.indexRow withObject:model];
    [self.collectionView reloadData];
    
    
//    if (self.indexRow < self.dataArray.count) {
//        ODMyOrderModel *model = self.dataArray[self.indexRow];
//        model.order_status = [NSString stringWithFormat:@"%@", text.userInfo[@"orderStatus"]];
//        [self.dataArray replaceObjectAtIndex:self.indexRow withObject:model];
//        [self.collectionView reloadData];
//    }
}

@end

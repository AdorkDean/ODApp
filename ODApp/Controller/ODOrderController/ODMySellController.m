//
//  ODMySellController.m
//  ODApp
//
//  Created by zhz on 16/2/22.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODMySellController.h"
#import "ODMySellModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODMyOrderCell.h"
#import "ODMySellDetailController.h"
#import "ODSecondMySellDetailController.h"

@interface ODMySellController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *open_id;

@property(nonatomic, strong) UILabel *noReusltLabel;

@property(nonatomic, assign) NSInteger indexRow;


@end

@implementation ODMySellController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.page = 1;
    self.open_id = [ODUserInformation sharedODUserInformation].openID;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];


    self.navigationItem.title = @"已卖出";

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:ODNotificationSellOrderSecondRefresh object:nil];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)reloadData:(NSNotification *)text {


    NSLog(@"_____%@", text.userInfo[@"orderStatus"]);


    ODMySellModel *model = self.dataArray[self.indexRow];
    model.order_status = [NSString stringWithFormat:@"%@", text.userInfo[@"orderStatus"]];
    [self.dataArray replaceObjectAtIndex:self.indexRow withObject:model];
    [self.collectionView reloadData];


}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isRefresh = @"";
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)getData {
    NSString *countNumber = [NSString stringWithFormat:@"%ld", (long) self.page];


    self.manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"page" : countNumber, @"open_id" : self.open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];

    __weakSelf
    [self.manager GET:kMySellListUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject) {


            if ([responseObject[@"status"] isEqualToString:@"success"]) {


                if ([countNumber isEqualToString:@"1"]) {
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.noReusltLabel removeFromSuperview];
                }


                NSMutableDictionary *dic = responseObject[@"result"];

                for (NSMutableDictionary *miniDic in dic) {
                    ODMySellModel *model = [[ODMySellModel alloc] init];
                    [model setValuesForKeysWithDictionary:miniDic];
                    [weakSelf.dataArray addObject:model];
                }
                if (weakSelf.dataArray.count == 0) {
                    weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160) / 2, kScreenSize.height / 2, 160, 30) text:@"暂无订单" font:16 alignment:@"center" color:@"#000000" alpha:1];
                    [weakSelf.view addSubview:weakSelf.noReusltLabel];
                }


                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView reloadData];


                if (dic.count == 0) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }
                            
                
            }else if ([responseObject[@"status"]isEqualToString:@"error"]) {
                
                
              
                [ODProgressHUD showInfoWithStatus:responseObject[@"message"]];
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshing];
                [weakSelf.collectionView reloadData];


            }


        }
    }         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];


}

#pragma mark - 刷新

- (void)DownRefresh {

    self.page = 1;
    [self getData];

}


- (void)LoadMoreData {
    self.page++;
    [self getData];

}


#pragma mark - 初始化

- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self DownRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [self LoadMoreData];
    }];

    [self.collectionView registerNib:[UINib nibWithNibName:@"ODMyOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODMyOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    ODMySellModel *model = self.dataArray[indexPath.row];

    [cell dealWithSellModel:model];


    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ODMyOrderModel *model = self.dataArray[indexPath.row];


    NSString *swap_type = [NSString stringWithFormat:@"%@", model.swap_type];
    NSString *orderId = [NSString stringWithFormat:@"%@", model.order_id];
    NSString *orderStatus = [NSString stringWithFormat:@"%@", model.order_status];

    self.indexRow = indexPath.row;


    if ([swap_type isEqualToString:@"1"]) {
        ODSecondMySellDetailController *vc = [[ODSecondMySellDetailController alloc] init];
        vc.orderType = model.status_str;
        vc.orderId = orderId;
        vc.orderStatus = orderStatus;
        [self.navigationController pushViewController:vc animated:YES];

        __weakSelf
        vc.getRefresh = ^(NSString *isRefresh) {


            weakSelf.isRefresh = isRefresh;
        };


    } else {


        ODMySellDetailController *vc = [[ODMySellDetailController alloc] init];
        vc.orderType = model.status_str;
        vc.orderId = orderId;
        vc.orderStatus = orderStatus;
        [self.navigationController pushViewController:vc animated:YES];

        __weakSelf
        vc.getRefresh = ^(NSString *isRefresh) {


            weakSelf.isRefresh = isRefresh;
        };


    }


}


//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {


    return CGSizeMake(kScreenSize.width, 120);


}

//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 6;


}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

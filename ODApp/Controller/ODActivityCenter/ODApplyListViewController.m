//
//  ODApplyListViewController.m
//  ODApp
//
//  Created by zhz on 16/2/17.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODApplyListViewController.h"
#import "ODCollectionCell.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOthersInformationController.h"
#import "ODApplyModel.h"

@interface ODApplyListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
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
    [self createCollectionView];

    self.navigationItem.title = @"TA们申请过";
}


#pragma mark - 初始化
- (void)createCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 60) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self DownRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self LoadMoreData];
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
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

         if (applyDatas.count == 0)
         {
             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.collectionView.mj_footer endRefreshing];
         }
         [weakSelf.collectionView.mj_header endRefreshing];
         [weakSelf.collectionView reloadData];
         
     } failure:^(NSError *error) {
         [weakSelf.collectionView.mj_header endRefreshing];
         [weakSelf.collectionView.mj_footer endRefreshing];
     }];
}


#pragma mark - UICollectionView 数据源方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    ODApplyModel *model = self.dataArray[indexPath.row];

    [cell setWithApplyModel:model];

    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


#pragma mark - UICollectionView 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    ODLoveListModel *model = self.dataArray[indexPath.row];
    vc.open_id = model.open_id;
    if (![vc.open_id isEqualToString:[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].openID]]) {
        [self.navigationController pushViewController:vc animated:YES];
    }


}
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScreenSize.width, 68);


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

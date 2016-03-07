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
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODOthersInformationController.h"

#import "ODLoveListModel.h"

@interface ODCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ODCollectionController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];

    self.navigationItem.title = @"TA们收藏过";
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
- (void)getData
{
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
        NSArray *loveListData = [model result];
        if ([countNumber isEqualToString:@"1"]) [self.dataArray removeAllObjects];

        [weakSelf.dataArray addObject:loveListData.firstObject];

        [weakSelf.collectionView.mj_header endRefreshing];

        if (!loveListData.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
        [weakSelf.collectionView reloadData];
    }
    failure:^(NSError *error) {
       [weakSelf.collectionView.mj_header endRefreshing];
       [weakSelf.collectionView.mj_footer endRefreshing];
       [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark - UICollectionView 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];

    ODLoveListModel *model = self.dataArray[indexPath.row];
    [cell setWithLikeModel:model];

    return cell;
}

#pragma mark - UICollectionView 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    ODLoveListModel *model = self.dataArray[indexPath.row];
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;

    if ([openId isEqualToString:model.open_id]) {;
    } else {

        vc.open_id = model.open_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(kScreenSize.width, 68);
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

//
//  ODWithdrawalDetailController.m
//  ODApp
//
//  Created by zhz on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODWithdrawalDetailController.h"
#import "ODWithdrawalCell.h"
#import "ODBalanceModel.h"
@interface ODWithdrawalDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *noReusltLabel;

@end

@implementation ODWithdrawalDetailController

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
   
    self.navigationItem.title = @"提现明细";
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self getData];
    [self createCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:self.flowLayout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODWithdrawalCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 请求数据
- (void)getData
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"open_id"] = [ODUserInformation sharedODUserInformation].openID;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserCashList parameters:params modelClass:[ODBalanceModel class] success:^(id model)
     {
        [weakSelf.dataArray removeAllObjects];

        NSArray *balanceDatas = [model result];
        [weakSelf.dataArray addObjectsFromArray:balanceDatas];
        [weakSelf.collectionView reloadData];
        ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
        if (weakSelf.dataArray.count == 0) {
            [noResultabel showOnSuperView:weakSelf.collectionView title:@"暂无提现记录"];
        }
        else {
            [noResultabel hidden];
        }
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - UICollectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODWithdrawalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    ODBalanceModel *model = self.dataArray[indexPath.section];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionView 代理方法
//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width , 60);
    
}

@end

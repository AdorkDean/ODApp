//
//  ODCenterActivityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterActivityViewController.h"
#import "CenterActivityCell.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "CenterActivityModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ODChoseCenterController.h"
#import "ODCenterDetailController.h"
#import "ODCenterYuYueController.h"
#import "ODActivityDetailController.h"
#import "SDCycleScrollView.h"
#import "ODActivityHeadView.h"
#import "ODCenterPactureController.h"
#import "ODTabBarController.h"
#import "ChoseCenterModel.h"
#import "ODUserInformation.h"
#import "ODPersonalCenterViewController.h"
#import "ODTabBarController.h"
#import "ODCollectionController.h"
#import "ODContactAddressController.h"
#import "ODOrderController.h"
@interface ODCenterActivityViewController ()<UIScrollViewDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , SDCycleScrollViewDelegate>

@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic, strong) ODActivityHeadView *firstHeader;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
@property(nonatomic,strong)AFHTTPRequestOperationManager *centerManager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *phoneManager;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *pictureDetailArray;
@property(nonatomic,strong)NSMutableArray *centerArray;
@property (nonatomic , assign) NSInteger centerNumber;

@property (nonatomic , copy) NSString *phoneNumber;




@end

@implementation ODCenterActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.isRefresh = NO;
    
    self.centerNumber = 1;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.centerArray = [[NSMutableArray alloc] init];
    self.pictureArray = [[NSMutableArray alloc] init];
    self.pictureDetailArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.navigationItem.title = @"中心活动";
    [self createCollectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downRefresh];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}




#pragma mark - 初始化
-(void)navigationInit
{
    // 场地预约button
    
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 100, 16,90, 44) target:self sel:@selector(rightClick:) tag:0 image:nil title:@"场地预约" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    
    
    confirmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    UIImageView *releaseImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 14, 17, 17) imageName:@"场地预约icon@3x" tag:0];
    [confirmButton addSubview:releaseImageView];
    [self.headView addSubview:confirmButton];
    
}




#pragma mark - 刷新
- (void)downRefresh
{
    [self getCenter];
    
    
}


#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (self.isRefresh) {
        [self.collectionView.mj_header beginRefreshing];
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isRefresh = NO;
}



#pragma mark - 请求数据
- (void)getCenter
{
    self.centerManager = [AFHTTPRequestOperationManager manager];
    self.centerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"show_type":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/other/store/list";
    
    __weak typeof (self)weakSelf = self;
    [self.centerManager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            
            [weakSelf.centerArray removeAllObjects];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
            for (NSMutableDictionary *dic in result) {
                ChoseCenterModel *model = [[ChoseCenterModel alloc] initWithDict:dic];
                [weakSelf.centerArray addObject:model];
            }
            
            
            ChoseCenterModel *model = self.centerArray[self.centerNumber - 1];
            NSString *storeId = [NSString stringWithFormat:@"%ld" , (long)model.storeId];
            weakSelf.storeId = storeId;
            weakSelf.centerName = model.name;
            [weakSelf getLunBoPicture];
            [weakSelf getData];
            [weakSelf getPhoneNumber];
            
        }else{
            [weakSelf.collectionView.mj_header endRefreshing];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
        
    }];
    
    
}

- (void)getPhoneNumber
{
    
    self.phoneManager = [AFHTTPRequestOperationManager manager];
    self.phoneManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/other/store/detail";
    __weak typeof (self)weakSelf = self;
    [self.phoneManager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
            
            weakSelf.phoneNumber = result[@"tel"];
            
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    
    
}

- (void)getLunBoPicture
{
    
    
    self.managers = [AFHTTPRequestOperationManager manager];
    self.managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"position":@"4" , @"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/other/banner";
    
    __weak typeof (self)weakSelf = self;
    [self.managers GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        
        if (responseObject) {
            
            
            [weakSelf.pictureArray removeAllObjects];
            [weakSelf.pictureDetailArray removeAllObjects];
            [weakSelf.titleArray removeAllObjects];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result = dict[@"result"];
            
            
            for (NSDictionary *itemDict in result) {
                
                NSString *picture = itemDict[@"img_url"];
                NSString *pictureDetail = itemDict[@"banner_url"];
                NSString *title = itemDict[@"title"];
                
                
                
                
                [weakSelf.pictureArray addObject:picture];
                [weakSelf.pictureDetailArray addObject:pictureDetail];
                [weakSelf.titleArray addObject:title];
                
            }
            
            [weakSelf.collectionView reloadData];
            
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
    
    
}


-(void)getData
{
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/store/apply/list";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result = dict[@"result"];
            
            [weakSelf.dataArray removeAllObjects];
            
            for (NSDictionary *itemDict in result) {
                CenterActivityModel *model = [[CenterActivityModel alloc] initWithDict:itemDict];
                
                
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
    
}



#pragma mark - 点击事件
-(void)rightClick:(UIButton *)button
{
    
    
//    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
//        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
//        
//        
//    }else {
//        ODCenterYuYueController *vc = [[ODCenterYuYueController alloc] init];
//        
//        vc.centerName = self.centerName;
//        vc.storeId = self.storeId;
//        vc.phoneNumber = self.phoneNumber;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
    
    ODOrderController *vc = [[ODOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)centerDetail:(UIButton *)sender
{
    
    
    if ([self.storeId isEqualToString:@"0"]|| self.storeId == nil || [self.storeId isEqualToString:@""]) {
        
        ;
        
    }else {
        
        ODCenterDetailController *vc = [[ODCenterDetailController alloc] init];
        vc.storeId = self.storeId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


- (void)searchButtonClick:(UIButton *)sender
{
    ODChoseCenterController *vc = [[ODChoseCenterController alloc] init];
    vc.storeCenterNameBlock = ^(NSString *name , NSString *storeId , NSInteger storeNumber){
        self.centerNumber = storeNumber;
        
        self.firstHeader.centerNameLabel.text = name;
        
    };
    
    
    vc.isRefreshBlock = ^(BOOL isRefresh){
        
        self.isRefresh = isRefresh;
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64 - 55) collectionViewLayout:self.flowLayout];
    [self.collectionView registerClass:[ODActivityHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"firstHeader"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CenterActivityCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
}


#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CenterActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    CenterActivityModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODActivityDetailController *vc = [[ODActivityDetailController alloc] init];
    
    CenterActivityModel *model = self.dataArray[indexPath.row];
    
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
        
        vc.activityId = [NSString stringWithFormat:@"%ld" , (long)model.activity_id];
        vc.storeId = self.storeId;
        vc.openId =   [ODUserInformation sharedODUserInformation].openID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.firstHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"firstHeader" forIndexPath:indexPath];
    
    self.firstHeader.cycleScrollerView.delegate = self;
    [self.firstHeader.cycleScrollerView setImageURLStringsGroup:self.pictureArray];
    [self.firstHeader.cycleScrollerView setTitlesGroup:self.titleArray];
    
    
    
    
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchButtonClick:)];
    [self.firstHeader.coverImageView addGestureRecognizer:searchTap];
    
    
    
    [self.firstHeader.centerButton addTarget:self action:@selector(centerDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstHeader.centerNameLabel.text = self.centerName;
    
    return self.firstHeader;
    
}

//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 140);
    
}
//动态设置每个分区的缩进量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//动态设置每个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//动态返回不同区的列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, kScreenSize.height / 3.2 + 45);
    
}
//动态设置区尾的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ODCenterPactureController *vc = [[ODCenterPactureController alloc] init];
    vc.activityName = self.titleArray[index];
    vc.webUrl = self.pictureDetailArray[index];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ODHomeFoundViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODHomeFoundViewController.h"
#import "ODUserInformation.h"

@interface ODHomeFoundViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODHomeFoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pictureArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.pictureDetailArray = [[NSMutableArray alloc] init];
    
    self.dataArray = [[NSMutableArray alloc] init];
    userInfoDic = [NSMutableDictionary dictionary];
    
    [self createCollectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshdata];
        
    }];
    
}

- (void)refreshdata
{
    
    [self getHotThemeRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getHotThemeRequest];
}

- (void)getHotThemeRequest
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"type":@"3",@"page":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kHomeFoundListUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [weakSelf.dataArray removeAllObjects];
            
            NSDictionary *result = dict[@"result"];
            
            NSDictionary *bbs_list = result[@"bbs_list"];
            for (id bbsKey in bbs_list) {
                NSString *key = [NSString stringWithFormat:@"%@",bbsKey];
                NSDictionary *itemDict = bbs_list[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
    
            }
          
            [weakSelf mySort:weakSelf.dataArray];
            
            NSDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [userInfoDic setObject:model forKey:userKey];
            }
            
            [weakSelf getcycleScrollViewRequest];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
        
    }];
}

-(NSMutableArray *)mySort:(NSMutableArray *)mArray
{
    
    NSInteger i ,j ,count;
    NSObject *temp;
    count = mArray.count+1;
    for (i = count - 1; i >= 0; i--) {
        for (j= 0 ; j < i - 1 ; j++) {
            ODCommunityModel *model1 = [self.dataArray objectAtIndex:j];
            ODCommunityModel *model2 = [self.dataArray objectAtIndex:j+1];
            if ([model1.view_num compare:model2.view_num]<0) {
                temp = [mArray objectAtIndex:j];
                [mArray replaceObjectAtIndex:j withObject:[mArray objectAtIndex:j+1]];
                [mArray replaceObjectAtIndex:j+1 withObject:temp];
            }
        }
    }
    return mArray;
}

- (void)getcycleScrollViewRequest
{
    
    self.managers = [AFHTTPRequestOperationManager manager];
    self.managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"position":@"3",@"store_id":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.managers GET:kHomeFoundPictureUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [weakSelf.pictureArray removeAllObjects];
            [weakSelf.titleArray removeAllObjects];
            [weakSelf.pictureDetailArray removeAllObjects];
            
            NSMutableArray *result = dict[@"result"];
            
            for (NSDictionary *itemDict in result) {
                
                NSString *img_url = itemDict[@"img_url"];
                NSString *banner_url = itemDict[@"banner_url"];
                NSString *title = itemDict[@"title"];
                
                [weakSelf.titleArray addObject:title];
                [weakSelf.pictureArray addObject:img_url];
                [weakSelf.pictureDetailArray addObject:banner_url];
                
            }
            
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)lazyButtonClick:(UIButton *)button
{
    ODLazyViewController *vc = [[ODLazyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatButtonClick:(UIButton *)button
{
    self.tabBarController.selectedIndex = 3;
}

- (void)activityButtonClick:(UIButton *)button
{
    self.tabBarController.selectedIndex = 1;
}

- (void)placeButtonClick:(UIButton *)button
{

    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];

    }else{
        ODCenterYuYueController *vc = [[ODCenterYuYueController alloc] init];
        
        vc.centerName = @"上海第二工业大学体验中心";
        vc.phoneNumber = @"13524776010";
        vc.storeId = @"1";
        [self.navigationController pushViewController:vc animated:YES];

    }    
}

- (void)createCollectionView
{

    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64 - 55) collectionViewLayout:self.flowLayout];
    
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.minimumLineSpacing = 2;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.collectionView registerClass:[ODhomeViewCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"rollPictureView"];
   
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCommunityCellId];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommunityCellId forIndexPath:indexPath];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [cell showDateWithModel:model];
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    cell.nameLabel.text = [userInfoDic[userId]nick];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[userInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];

    return cell;
}

- (void)headButtonClick:(UIButton *)button
{

    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.dataArray[indexpath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = [userInfoDic[userId]open_id];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[userInfoDic[userId]open_id]]) {
        
    }else{
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc] init];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    self.rollPictureView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"rollPictureView" forIndexPath:indexPath];
    
    self.rollPictureView.cycleSecrollerView.delegate = self;
    
    [self.rollPictureView.cycleSecrollerView setImageURLStringsGroup:self.pictureArray];
    [self.rollPictureView.cycleSecrollerView setTitlesGroup:self.titleArray];
    
    [self.rollPictureView.lazyButton addTarget:self action:@selector(lazyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.rollPictureView.chatButton addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rollPictureView.activityButton addTarget:self action:@selector(activityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rollPictureView.placeButton addTarget:self action:@selector(placeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return self.rollPictureView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    ODCenterIntroduceController *vc = [[ODCenterIntroduceController alloc] init];
    
    vc.activityTitle = self.titleArray[index];
    vc.webUrl = self.pictureDetailArray[index];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width, 120);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 64 + kScreenSize.height / 4.4 + 195 / 2 + 24);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 0);
}
@end

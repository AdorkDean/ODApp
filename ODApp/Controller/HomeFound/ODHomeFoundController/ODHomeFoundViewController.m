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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pictureArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.pictureDetailArray = [[NSMutableArray alloc] init];
    
    self.dataArray = [[NSMutableArray alloc] init];
    userInfoDic = [NSMutableDictionary dictionary];
    
    [self navigationInit];
    
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
    
    self.navigationController.navigationBar.hidden = YES;
//    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
//    tabBar.imageView.alpha = 1;

    self.tabBarController.tabBar.hidden = NO;
    [self getHotThemeRequest];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
   
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"首页" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
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
            
            [self.dataArray removeAllObjects];
            
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
            
            [self getcycleScrollViewRequest];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        
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
            
            [self.pictureArray removeAllObjects];
            [self.titleArray removeAllObjects];
            [self.pictureDetailArray removeAllObjects];
            
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
        [self.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)lazyButtonClick:(UIButton *)button
{

    ODLazyViewController *vc = [[ODLazyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatButtonClick:(UIButton *)button
{
//    NSArray *imageArray = @[@"icon_home-find",@"icon_Center - activity",@"icon_market",@"icon_community",@"icon_Personal Center"];
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.selectedIndex = 3;
    
//    NSInteger index = 3;
//    for (NSInteger i = 0; i < 5; i++) {
//        UIButton *newButton = (UIButton *)[tabBar.imageView viewWithTag:1+i];
//        UIImageView *imageView = (UIImageView *)[newButton viewWithTag:6+i];
//        
//        if (i!=index) {
//            newButton.selected =NO;
//            button.selected = YES;
//            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default",imageArray[i]]];
//            
//        }else{
//            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected",imageArray[i]]];
//        }
//    }
}

- (void)activityButtonClick:(UIButton *)button
{

//    NSArray *imageArray = @[@"icon_home-find",@"icon_Center - activity",@"icon_market",@"icon_community",@"icon_Personal Center"];
    ODTabBarController *tabbar = (ODTabBarController *)self.navigationController.tabBarController;
    tabbar.selectedIndex = 1;
    
//    NSInteger index = 1;
//    for (NSInteger i = 0; i < 5; i++) {
//        UIButton *newButton= (UIButton *)[tabbar.imageView viewWithTag:1+i];
//        UIImageView *imageView = (UIImageView *)[newButton viewWithTag:6+i];
//        
//        if (i!=index) {
//            newButton.selected =NO;
//            button.selected = YES;
//            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_default",imageArray[i]]];
//            
//        }else{
//            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected",imageArray[i]]];
//        }
//    }
}

- (void)placeButtonClick:(UIButton *)button
{

    if ([[ODUserInformation getData].openID isEqualToString:@""]) {
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
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

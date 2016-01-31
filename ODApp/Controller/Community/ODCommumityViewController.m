//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"

@interface ODCommumityViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODCommumityViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self createKeyWordView];
    [self createRequest];
    [self joiningTogetherParmeters];
    [self createCollectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];

}

#pragma mark - 加载更多
-(void)loadMoreData
{
    self.count ++;
    NSDictionary *parameter = @{@"type":@"4",@"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":@"0",@"call_array":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsLatestUrl paramater:signParameter];
}


#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationItem.title = @"欧动社区";
   //发布任务按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeImageLeft) target:self action:@selector(publishButtonClick:) image:[UIImage imageNamed:@"发布任务icon"] highImage:nil textColor:nil highColor:nil title:@"发表话题"];
 }

-(void)publishButtonClick:(UIButton *)button
{
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
        
    }else{
        
        ODCommunityReleaseTopicViewController *releaseTopic = [[ODCommunityReleaseTopicViewController alloc]init];
        releaseTopic.myBlock = ^(NSString *refresh){
            self.refresh = refresh;
        };
        [self.navigationController pushViewController:releaseTopic animated:YES];

    }
}

#pragma mark - 关键字搜索
-(void)createKeyWordView
{
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(0, 64, kScreenSize.width, 37) tag:0 color:@"#d9d9d9"];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    UIImageView *searchImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(4, 4, kScreenSize.width-8, 29) imageName:@"" tag:0];
    searchImageView.layer.masksToBounds = YES;
    searchImageView.layer.cornerRadius = 5;
    searchImageView.layer.borderWidth = 1;
    searchImageView.userInteractionEnabled = YES;
    searchImageView.layer.borderColor = [UIColor colorWithHexString:@"000000" alpha:1].CGColor;
    searchImageView.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchButtonClick)];
    [searchImageView addGestureRecognizer:searchTap];
    [view addSubview:searchImageView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake(20, 0, 100, 29) text:@"关键字搜索" font:16 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [searchImageView addSubview:label];
}

-(void)searchButtonClick
{
    ODCommunityKeyWordSearchViewController *keyWordSearch = [[ODCommunityKeyWordSearchViewController alloc]init];
    [self.navigationController pushViewController:keyWordSearch animated:YES];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
    userInfoDic = [NSMutableDictionary dictionary];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{@"type":@"4",@"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":@"0",@"call_array":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsLatestUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject) {
            NSDictionary *dcit = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dcit[@"result"];
            NSDictionary *bbs_list = result[@"bbs_list"];
//            NSArray *allkeys = [bbs_list allKeys];
//            allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//                NSComparisonResult result = [obj1 compare:obj2];
//                return result == NSOrderedAscending;
//            }];
            for (NSDictionary *itemDict in bbs_list) {
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            
            NSDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [userInfoDic setObject:model forKey:userKey];
            }

            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (bbs_list.count == 0) {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - 创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,101, kScreenSize.width, kScreenSize.height - 101 - 55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCommunityCellId];
    [self.collectionView registerClass:[ODCommunityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supple"];
    [self.view addSubview:self.collectionView];

}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommunityCellId forIndexPath:indexPath];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    
    [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell showDateWithModel:model];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    cell.nameLabel.text = [userInfoDic[userId]nick];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[userInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];
    return cell;
}

- (void)othersInformationClick:(UIButton *)button{

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

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 120);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *viewId = @"supple";
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ODCommunityHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewId forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenSize.width, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    detailController.myBlock = ^(NSString *refresh){
        self.refresh = refresh;
    };
    ODCommunityModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if ([self.refresh isEqualToString:@"refresh"]) {
        [self.collectionView.mj_header beginRefreshing];
    }
    
}
#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = @"";
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

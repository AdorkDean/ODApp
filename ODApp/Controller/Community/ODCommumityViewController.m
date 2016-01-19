//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"

@interface ODCommumityViewController ()

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
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsListUrl paramater:signParameter];
}


#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"欧动社区" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //发布任务按钮
<<<<<<< HEAD
    UIButton *publishButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 32,95, 20) target:self sel:@selector(publishButtonClick:) tag:0 image:nil title:@"发表话题" font:16];
    [publishButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
=======
    UIButton *publishButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 110, 16,95, 44) target:self sel:@selector(publishButtonClick:) tag:0 image:nil title:@"发表话题" font:16];
    [publishButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
>>>>>>> ab9b6b0ccedcaaee159908d6427c4c8f0fa3d1a6
    publishButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.headView addSubview:publishButton];
    
    UIImageView *publishImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, 12, 20, 20) imageName:@"发布任务icon" tag:0];
    [publishButton addSubview:publishImageView];
}

-(void)publishButtonClick:(UIButton *)button
{
    if ([ODUserInformation getData].openID) {
        
        ODCommunityReleaseTopicViewController *releaseTopic = [[ODCommunityReleaseTopicViewController alloc]init];
        releaseTopic.myBlock = ^(NSString *refresh){
            self.refresh = refresh;
        };
        [self.navigationController pushViewController:releaseTopic animated:YES];

    }else{
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController pushViewController:personalCenter animated:YES];
    }
}

#pragma mark - 关键字搜索
-(void)createKeyWordView
{
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(0, 64, kScreenSize.width, 37) tag:0 color:@"#d9d9d9"];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    UIButton *searchButton = [ODClassMethod creatButtonWithFrame:CGRectMake(4, 4, kScreenSize.width-8, 29) target:self sel:@selector(searchButtonClick:) tag:0 image:nil title:@" " font:0];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 5;
    searchButton.layer.borderWidth = 1;
    [searchButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    searchButton.layer.borderColor = [UIColor colorWithHexString:@"000000" alpha:1].CGColor;
    searchButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    [view addSubview:searchButton];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake(20, 0, 100, 29) text:@"关键字搜索" font:16 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [searchButton addSubview:label];
}

-(void)searchButtonClick:(UIButton *)button
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
    self.userArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsListUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (self.count == 1) {
            [self.dataArray removeAllObjects];
        }
        if (responseObject) {
            NSDictionary *dcit = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dcit[@"result"];
            NSDictionary *bbs_list = result[@"bbs_list"];
            NSArray *allkeys = [bbs_list allKeys];
            allkeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSComparisonResult result = [obj1 compare:obj2];
                return result == NSOrderedAscending;
            }];
            for (id bbsKey in allkeys) {
                NSString *key = [NSString stringWithFormat:@"%@",bbsKey];
                NSDictionary *itemDict = bbs_list[key];
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
                [weakSelf.userArray addObject:model];
            }
            
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
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
    for (NSInteger i = 0; i < self.userArray.count; i++) {
        ODCommunityModel *userModel = self.userArray[i];
        if ([[NSString stringWithFormat:@"%@",model.user_id] isEqualToString:[NSString stringWithFormat:@"%@",userModel.id]]) {
            cell.nameLabel.text = userModel.nick;
            [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
        }
    }
    
    
    return cell;
}

- (void)othersInformationClick:(UIButton *)button{

    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.userArray[indexpath.row];
    
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.open_id;

    [self.navigationController pushViewController:vc animated:YES];
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
    if ([self.refresh isEqualToString:@"refresh"]) {
        [self.collectionView.mj_header beginRefreshing];
        [self.dataArray removeAllObjects];
    }
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1;

}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = @"";
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

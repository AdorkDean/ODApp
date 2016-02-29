//
//  ODMyApplyActivityController.m
//  ODApp
//
//  Created by Bracelet on 16/1/12.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import "ODMyApplyActivityController.h"
#import "ODUserInformation.h"

@interface ODMyApplyActivityController ()

@end

@implementation ODMyApplyActivityController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我报名的活动";
    
    self.pageCount = 1;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self createCollectionView];
    [self getCollectionViewRequest];
    
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        self.pageCount = 1;
        [weakSelf downRefresh];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^
    {
        [weakSelf loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isRefresh)
    {
        [self.collectionView.mj_header beginRefreshing];
        self.isRefresh = NO;
    }
}

- (void)downRefresh
{
    [self getCollectionViewRequest];
}

- (void)loadMoreData
{
    self.pageCount ++;
    [self getCollectionViewRequest];
}

- (void)getCollectionViewRequest
{
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"open_id":openId,@"type":@"0",@"page":[NSString stringWithFormat:@"%i", self.pageCount]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyApplyActivityUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        [weakSelf.noReusltLabel removeFromSuperview];
        
        if (weakSelf.pageCount == 1)
        {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result)
            {
                ODMyApplyActivityModel *model = [[ODMyApplyActivityModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            if (weakSelf.pageCount && weakSelf.dataArray.count == 0 )
            {
                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无活动" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:weakSelf.noReusltLabel];
            }
            else
            {
                [weakSelf.collectionView reloadData];
            }
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (result.count == 0)
            {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
        }
    }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error)
    {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ONMyApplyActivityCell" bundle:nil] forCellWithReuseIdentifier:kMyApplyActivityCellId];
    [self.view addSubview:self.collectionView];
}

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
    ONMyApplyActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyApplyActivityCellId forIndexPath:indexPath];
    ODMyApplyActivityModel *model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.layer.cornerRadius = 7;
    [cell showDataWithModel:model];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 98);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODNewActivityDetailViewController *vc = [[ODNewActivityDetailViewController alloc] init];
    ODMyApplyActivityModel *model = self.dataArray[indexPath.row];
    vc.acitityId = [model.activity_id intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

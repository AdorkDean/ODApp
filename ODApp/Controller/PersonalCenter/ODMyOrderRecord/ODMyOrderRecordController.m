//
//  ODMyOrderRecordController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODMyOrderRecordController.h"
#import "ODUserInformation.h"
@interface ODMyOrderRecordController ()

@end

@implementation ODMyOrderRecordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.count = 1;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    self.orderArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = self.centerTitle;

    [self createCollectionView];
    [self createRequest];
    [self joiningTogetherParmeters];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreData];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self joiningTogetherParmeters];

}

- (void)loadMoreData
{
    
    self.count ++;
    NSDictionary *parameter = @{@"open_id":self.open_id,@"page":[NSString stringWithFormat:@"%ld",(long)self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kMyOrderRecordUrl paramater:signParameter];
}

- (void)createRequest
{

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{@"open_id":self.open_id,@"page":[NSString stringWithFormat:@"%ld",(long)self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kMyOrderRecordUrl paramater:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [weakSelf.noReusltLabel removeFromSuperview];
        
        if (weakSelf.count == 1) {
            [weakSelf.orderArray removeAllObjects];
        }
        
        if (responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                
                ODMyOrderRecordModel *model = [[ODMyOrderRecordModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.orderArray addObject:model];
   
            }

            if (weakSelf.orderArray.count == 0) {
                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80)/2, kScreenSize.height/2, 80, 30) text:@"暂无预约" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:self.noReusltLabel];
            }
            
            [weakSelf.collectionView reloadData];
            
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (result.count == 0) {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
}

#pragma mark - 创建CollectionView
- (void)createCollectionView
{

    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODMyOrderRecordCell" bundle:nil] forCellWithReuseIdentifier:kMyOrderRecordCellId];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.orderArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ODMyOrderRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMyOrderRecordCellId forIndexPath:indexPath];
    
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
    [cell showDatawithModel:model];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 7;
    cell.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    

    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width - 6, 170);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ODMyOrderDetailController *vc = [[ODMyOrderDetailController alloc] init];
    ODMyOrderRecordModel *model = self.orderArray[indexPath.row];
  
    vc.isOther = self.isOther;
    vc.open_id = self.open_id;
    vc.order_id = [NSString stringWithFormat:@"%@",model.order_id];
    

    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

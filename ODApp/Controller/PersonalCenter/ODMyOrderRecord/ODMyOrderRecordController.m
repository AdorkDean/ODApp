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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    self.orderArray = [[NSMutableArray alloc] init];
    
    [self navigationInit];
  
    [self createCollectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self getCollectionListRequest];
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

- (void)navigationInit
{
    
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"#f3f3f3"];
    [self.view addSubview:self.headView];
    
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 160) / 2, 28, 160, 20) text:self.centerTitle font:17 alignment:@"center" color:@"#000000" alpha:1];
    [self.headView addSubview:label];
    

    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16, 44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
}

- (void)backButtonClick:(UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData
{

    [self getCollectionListRequest];
}

- (void)getCollectionListRequest
{

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    NSDictionary *parameter = @{@"open_id":self.open_id,@"page":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:kMyOrderRecordUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            [self.orderArray removeAllObjects];
            
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                
                ODMyOrderRecordModel *model = [[ODMyOrderRecordModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.orderArray addObject:model];
   
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建CollectionView
- (void)createCollectionView
{

    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
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

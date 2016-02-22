//
//  ODBazaarLabelSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarLabelSearchViewController.h"

@interface ODBazaarLabelSearchViewController ()

@end

@implementation ODBazaarLabelSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSearchBar];
    [self createRequest];
    [self createCollectionView];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length>0) {
            [weakSelf joiningTogetherParmeters];
        }else{
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    self.navigationItem.title = @"欧动集市";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
}

#pragma mark - 加载更多
-(void)loadMoreData
{
    if (self.searchBar.text.length>0) {
        self.count ++;
        NSDictionary *parameter = @{@"search":self.searchBar.text,@"task_status":@"9",@"page":[NSString stringWithFormat:@"%ld",self.count]};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl parameter:signParameter];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }

}

-(void)confirmButtonClick:(UIButton *)button
{
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length>0) {
        
        [self joiningTogetherParmeters];
        [self.collectionView.mj_header beginRefreshing];
    }else{
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入搜索内容"];
    }
}

#pragma mark - 创建searchBar
-(void)createSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 8, kScreenSize.width-20, 30)];
    [[[[ self.searchBar. subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"标签关键字";
    [self.view addSubview:self.searchBar];
}


#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self joiningTogetherParmeters];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
}


#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{@"search":self.searchBar.text,@"task_status":@"9",@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];

    [self downLoadDataWithUrl:kBazaarUnlimitTaskUrl parameter:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    
    [self.searchBar resignFirstResponder];
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.noReusltLabel  removeFromSuperview];
        }
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSArray *tasks = result[@"tasks"];
            for (NSDictionary *itemDict in tasks) {
                ODBazaarModel *model = [[ODBazaarModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (weakSelf.dataArray.count == 0) {

                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 180)/2, kScreenSize.height/2, 180, 30) text:@"没有符合条件的任务" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:weakSelf.noReusltLabel];
            }
            
            if (tasks.count == 0) {
                [self.collectionView.footer noticeNoMoreData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
    
}
#pragma mark - 创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,46, kScreenSize.width, kScreenSize.height - 110) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarCellId];
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
    ODBazaarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarCellId forIndexPath:indexPath];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    [cell shodDataWithModel:model];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 120);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc]init];
    ODBazaarModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%@",model.task_id];
    bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@",model.task_status_name];
    bazaarDetail.open_id = [NSString stringWithFormat:@"%@",model.open_id];
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

@end

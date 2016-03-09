//
//  ODBazaarLabelSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/21.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarLabelSearchViewController.h"

#define kBazaarCellId @"ODBazaarCollectionCell"
@interface ODBazaarLabelSearchViewController ()

@end

@implementation ODBazaarLabelSearchViewController

#pragma mark - lazyLoad
-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 8, kScreenSize.width - 20, 30)];
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        _searchBar.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"标签关键字";
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(kScreenSize.width, 107);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 46, kScreenSize.width, kScreenSize.height - 110) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"欧动集市";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
    [self searchBar];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length > 0) {
            weakSelf.count = 1;
            [weakSelf requestData];
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];

    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 请求数据
-(void)requestData
{
    __weakSelf;
    [self.searchBar resignFirstResponder];
    NSDictionary *parameter = @{@"search" : self.searchBar.text, @"task_status" : @"9", @"page" : [NSString stringWithFormat:@"%ld", self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID]};
    
    [ODHttpTool getWithURL:ODUrlTaskList parameters:parameter modelClass:[ODBazaarRequestHelpModel class] success:^(ODBazaarRequestHelpModelResponse  *model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        ODBazaarRequestHelpModel *helpModel = [model result];
        for (ODBazaarRequestHelpTasksModel *taskModel in helpModel.tasks) {
            [weakSelf.dataArray addObject:taskModel];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    self.count++;
    [self requestData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarCellId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarDetailViewController *bazaarDetail = [[ODBazaarDetailViewController alloc] init];
    ODBazaarRequestHelpTasksModel *model = self.dataArray[indexPath.row];
    bazaarDetail.task_id = [NSString stringWithFormat:@"%d", model.task_id];
    bazaarDetail.task_status_name = [NSString stringWithFormat:@"%@", model.task_status_name];
    bazaarDetail.open_id = [NSString stringWithFormat:@"%@", model.open_id];
    [self.navigationController pushViewController:bazaarDetail animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark - action
- (void)confirmButtonClick:(UIButton *)button {
    [self.searchBar resignFirstResponder];
    if (self.searchBar.text.length > 0) {
        [self.collectionView.mj_header beginRefreshing];
    } else {
        [ODProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
}


@end

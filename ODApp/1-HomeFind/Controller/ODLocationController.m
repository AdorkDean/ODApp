//
//  ODLocationController.m
//  ODApp
//
//  Created by Bracelet on 16/2/2.
//  Copyright © 2016年 Odong Bracelet. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODLocationController.h"

NSString *const ODLocationCellID = @"ODLocationCell";

@interface ODLocationController () <MAMapViewDelegate, AMapSearchDelegate, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    AMapSearchAPI *_search;
    MAMapView *_mapView;
}

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSArray *dataArray;



@end

@implementation ODLocationController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择城市";

    self.dataArray = [[NSArray alloc] init];
    [self getCityListRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODLocationCell class]) bundle:nil] forCellReuseIdentifier:ODLocationCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 数据请求

- (void)getCityListRequest {
    __weakSelf
    NSDictionary *parameter = @{@"region_name" : @"上海"};
    [ODHttpTool getWithURL:ODUrlOtherCityList parameters:parameter modelClass:[ODLocationModel class] success:^(id model) {
        weakSelf.dataArray = [[model result] all];
        [weakSelf.tableView reloadData];
        }
    failure:^(NSError *error) {

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ODLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:ODLocationCellID];
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWhiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ODCityNameModel *model = self.dataArray[indexPath.row];
    [ODUserInformation sharedODUserInformation].locationCity = model.name;
    [ODUserInformation sharedODUserInformation].cityID = model.id;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationLocationSuccessRefresh object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
